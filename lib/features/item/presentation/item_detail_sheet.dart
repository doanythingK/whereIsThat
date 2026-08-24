import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    final locations =
        ref.watch(locationsForSpaceProvider(item.spaceId)).value ??
        const <Location>[];
    final location = locations
        .where((entry) => entry.id == item.locationId)
        .firstOrNull;
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
                  location?.name ?? context.l10n.unassignedLocation,
                ),
                trailing: IconButton(
                  icon: Icon(item.isFavorite ? Icons.star : Icons.star_border),
                  onPressed: () =>
                      ref.read(workspaceActionsProvider).toggleFavorite(item),
                ),
              ),
              if (item.photos.isNotEmpty) ...[
                const SizedBox(height: 8),
                SizedBox(
                  height: 112,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: item.photos.length,
                    separatorBuilder: (_, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) =>
                        _PhotoPreview(photo: item.photos[index], ref: ref),
                  ),
                ),
              ],
              if (item.detailLocation != null)
                _DetailLine(
                  label: context.l10n.detailLocationOptional,
                  value: item.detailLocation!,
                ),
              if (item.memo != null)
                _DetailLine(label: context.l10n.memo, value: item.memo!),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _move(context, ref, spaces),
                icon: const Icon(Icons.drive_file_move_outlined),
                label: Text(context.l10n.moveItem),
              ),
              const SizedBox(height: 8),
              if (item.locationId != null)
                OutlinedButton.icon(
                  onPressed: () => context.go(
                    '/space/${item.spaceId}/floor-plan?location=${Uri.encodeQueryComponent(item.locationId!)}',
                  ),
                  icon: const Icon(Icons.map_outlined),
                  label: Text(context.l10n.showOnFloorPlan),
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
                label: Text(context.l10n.itemEdit),
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.itemLocationHistory,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              history.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => Text(error.toString()),
                data: (values) => values.isEmpty
                    ? Text(context.l10n.noItemLocationHistory)
                    : Column(
                        children: [
                          for (final entry in values)
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.history),
                              title: Text(
                                '${_locationName(locations, entry.fromLocationId, context)} → ${_locationName(locations, entry.toLocationId, context)}',
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

  String _locationName(
    List<Location> locations,
    String? id,
    BuildContext context,
  ) => id == null
      ? context.l10n.unassignedLocation
      : locations.where((location) => location.id == id).firstOrNull?.name ??
            context.l10n.unassignedLocation;

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
    final locations =
        ref.watch(locationsForSpaceProvider(_spaceId)).value ??
        const <Location>[];
    return AlertDialog(
      title: Text(context.l10n.chooseMoveLocation),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _spaceId,
            decoration: InputDecoration(labelText: context.l10n.spaces),
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
            decoration: InputDecoration(labelText: context.l10n.location),
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(context.l10n.unassignedLocation),
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

class _PhotoPreview extends StatelessWidget {
  const _PhotoPreview({required this.photo, required this.ref});

  final ItemPhoto photo;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: ref
          .read(workspaceActionsProvider)
          .createItemPhotoSignedUrl(photo),
      builder: (context, snapshot) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: snapshot.hasData && snapshot.data!.isNotEmpty
            ? Image.network(
                snapshot.data!,
                width: 112,
                height: 112,
                fit: BoxFit.cover,
                errorBuilder: (_, error, stack) => const _PhotoFallback(),
              )
            : const _PhotoFallback(),
      ),
    );
  }
}

class _PhotoFallback extends StatelessWidget {
  const _PhotoFallback();

  @override
  Widget build(BuildContext context) => Container(
    width: 112,
    height: 112,
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: const Icon(Icons.image_outlined),
  );
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
