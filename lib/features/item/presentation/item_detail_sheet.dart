import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/data/repository_providers.dart';
import '../../../core/models/app_models.dart';
import 'item_editor_sheet.dart';

class ItemDetailSheet extends ConsumerWidget {
  const ItemDetailSheet({required this.item, super.key});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(itemLocationHistoryProvider(item.id));
    final spaces = ref.watch(spacesProvider).value ?? const <Space>[];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.close,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  item.visibility == 'private'
                      ? Icons.lock_outline
                      : Icons.inventory_2_outlined,
                ),
                title: Text(
                  '${item.quantity}${item.unit == null ? '' : ' ${item.unit}'}',
                ),
                subtitle: Text(
                  item.locationId == null
                      ? context.l10n.unassignedLocation
                      : context.l10n.location,
                ),
                trailing: IconButton(
                  icon: Icon(item.isFavorite ? Icons.star : Icons.star_border),
                  onPressed: () =>
                      ref.read(workspaceActionsProvider).toggleFavorite(item),
                ),
              ),
              if (item.detailLocation != null)
                _DetailLine(label: '상세 위치', value: item.detailLocation!),
              if (item.memo != null)
                _DetailLine(label: context.l10n.memo, value: item.memo!),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _move(context, ref, spaces),
                icon: const Icon(Icons.drive_file_move_outlined),
                label: const Text('다른 공간/위치로 이동'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  await showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) =>
                        ItemEditorSheet(spaceId: item.spaceId, item: item),
                  );
                  if (context.mounted) Navigator.pop(context);
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('물건 수정'),
              ),
              const SizedBox(height: 16),
              Text('위치 이동 이력', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              history.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => Text(error.toString()),
                data: (values) => values.isEmpty
                    ? const Text('아직 위치 이동 이력이 없습니다.')
                    : Column(
                        children: [
                          for (final entry in values)
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.history),
                              title: Text(
                                '${entry.fromLocationId ?? context.l10n.unassignedLocation} → ${entry.toLocationId ?? context.l10n.unassignedLocation}',
                              ),
                              subtitle: Text(
                                entry.movedAt.toLocal().toString(),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _move(
    BuildContext context,
    WidgetRef ref,
    List<Space> spaces,
  ) async {
    if (spaces.isEmpty) return;
    final result = await showDialog<({String spaceId, String? locationId})>(
      context: context,
      builder: (_) => _MoveDialog(item: item, spaces: spaces),
    );
    if (result == null) return;
    try {
      await ref
          .read(workspaceActionsProvider)
          .moveItem(
            item,
            targetSpaceId: result.spaceId,
            targetLocationId: result.locationId,
          );
      if (context.mounted) Navigator.pop(context);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }
}

class _MoveDialog extends ConsumerStatefulWidget {
  const _MoveDialog({required this.item, required this.spaces});

  final Item item;
  final List<Space> spaces;

  @override
  ConsumerState<_MoveDialog> createState() => _MoveDialogState();
}

class _MoveDialogState extends ConsumerState<_MoveDialog> {
  late String _spaceId = widget.item.spaceId;
  String? _locationId;

  @override
  Widget build(BuildContext context) {
    final plans =
        ref.watch(floorPlansProvider(_spaceId)).value ?? const <FloorPlan>[];
    final locations = plans.isEmpty
        ? const <Location>[]
        : ref.watch(locationsProvider(plans.first.id)).value ??
              const <Location>[];
    return AlertDialog(
      title: const Text('이동할 위치 선택'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _spaceId,
            decoration: const InputDecoration(labelText: '공간'),
            items: [
              for (final space in widget.spaces)
                DropdownMenuItem(value: space.id, child: Text(space.name)),
            ],
            onChanged: (value) => setState(() {
              _spaceId = value ?? _spaceId;
              _locationId = null;
            }),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            initialValue: _locationId,
            decoration: const InputDecoration(labelText: '보관 위치'),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('위치 미지정'),
              ),
              for (final location in locations)
                DropdownMenuItem<String?>(
                  value: location.id,
                  child: Text(location.name),
                ),
            ],
            onChanged: (value) => setState(() => _locationId = value),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, (
            spaceId: _spaceId,
            locationId: _locationId,
          )),
          child: Text(context.l10n.save),
        ),
      ],
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 80, child: Text(label)),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
