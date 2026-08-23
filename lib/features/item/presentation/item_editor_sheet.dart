import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/data/repository_providers.dart';
import '../../../core/models/app_models.dart';

class ItemEditorSheet extends ConsumerStatefulWidget {
  const ItemEditorSheet({
    required this.spaceId,
    this.item,
    this.initialName,
    super.key,
  });

  final String spaceId;
  final Item? item;
  final String? initialName;

  @override
  ConsumerState<ItemEditorSheet> createState() => _ItemEditorSheetState();
}

class _ItemEditorSheetState extends ConsumerState<ItemEditorSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _unitController;
  late final TextEditingController _detailController;
  late final TextEditingController _memoController;
  String? _locationId;
  String _visibility = 'shared';
  String? _categoryId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _nameController = TextEditingController(
      text: item?.name ?? widget.initialName ?? '',
    );
    _quantityController = TextEditingController(
      text: item == null ? '1' : item.quantity.toString(),
    );
    _unitController = TextEditingController(text: item?.unit ?? '');
    _detailController = TextEditingController(text: item?.detailLocation ?? '');
    _memoController = TextEditingController(text: item?.memo ?? '');
    _locationId = item?.locationId;
    _visibility = item?.visibility ?? 'shared';
    _categoryId = item?.categoryId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _detailController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${context.l10n.itemName}을 입력해 주세요.')),
      );
      return;
    }
    setState(() => _saving = true);
    final now = DateTime.now().toUtc();
    final old = widget.item;
    final item =
        (old ??
                Item(
                  id: '',
                  spaceId: widget.spaceId,
                  name: name,
                  createdBy:
                      ref.read(appRepositoryProvider).signedInUser?.id ??
                      'demo-user',
                  createdAt: now,
                  updatedAt: now,
                  photos: const [],
                ))
            .copyWith(
              name: name,
              quantity: double.tryParse(_quantityController.text) ?? 1,
              unit: _unitController.text.trim().isEmpty
                  ? null
                  : _unitController.text.trim(),
              locationId: _locationId,
              categoryId: _categoryId,
              detailLocation: _detailController.text.trim().isEmpty
                  ? null
                  : _detailController.text.trim(),
              memo: _memoController.text.trim().isEmpty
                  ? null
                  : _memoController.text.trim(),
              visibility: _visibility,
            );
    try {
      await ref
          .read(workspaceActionsProvider)
          .saveItem(item, isNew: old == null);
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final plans =
        ref.watch(floorPlansProvider(widget.spaceId)).value ??
        const <FloorPlan>[];
    final firstPlan = plans.firstOrNull;
    final locations = firstPlan == null
        ? const AsyncValue<List<Location>>.data([])
        : ref.watch(locationsProvider(firstPlan.id));
    final categories =
        ref.watch(categoriesProvider(widget.spaceId)).value ??
        const <Category>[];
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.item == null ? context.l10n.addItem : '물건 수정',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              TextField(
                controller: _nameController,
                autofocus: widget.item == null,
                decoration: InputDecoration(labelText: context.l10n.itemName),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: context.l10n.quantity,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _unitController,
                      decoration: InputDecoration(labelText: context.l10n.unit),
                    ),
                  ),
                ],
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
                  ...locations.value?.map(
                        (location) => DropdownMenuItem<String?>(
                          value: location.id,
                          child: Text(location.name),
                        ),
                      ) ??
                      const <DropdownMenuItem<String?>>[],
                ],
                onChanged: (value) => setState(() => _locationId = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _categoryId,
                decoration: const InputDecoration(labelText: '카테고리 (선택)'),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: const Text('없음'),
                  ),
                  ...categories.map(
                    (category) => DropdownMenuItem<String?>(
                      value: category.id,
                      child: Text(category.name),
                    ),
                  ),
                ].cast<DropdownMenuItem<String>>(),
                onChanged: (value) => setState(() => _categoryId = value),
              ),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'shared',
                    label: Text(context.l10n.sharedItem),
                  ),
                  ButtonSegment(
                    value: 'private',
                    label: Text(context.l10n.privateItem),
                  ),
                ],
                selected: {_visibility},
                onSelectionChanged: (value) =>
                    setState(() => _visibility = value.first),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _detailController,
                decoration: InputDecoration(labelText: '상세 위치 (선택)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _memoController,
                maxLength: 500,
                maxLines: 3,
                decoration: InputDecoration(labelText: context.l10n.memo),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(context.l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
