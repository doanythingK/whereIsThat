import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/data/repository_providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/models/app_models.dart';

class ItemEditorSheet extends ConsumerStatefulWidget {
  const ItemEditorSheet({
    required this.spaceId,
    this.item,
    this.initialName,
    this.initialLocationId,
    super.key,
  });

  final String spaceId;
  final Item? item;
  final String? initialName;
  final String? initialLocationId;

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
  String? _ownerUserId;
  bool _saving = false;
  String? _primaryPhotoId;
  final ImagePicker _imagePicker = ImagePicker();
  final List<Uint8List> _pendingPhotos = [];

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
    _locationId = item?.locationId ?? widget.initialLocationId;
    _visibility = item?.visibility ?? 'shared';
    _categoryId = item?.categoryId;
    _ownerUserId =
        item?.ownerUserId ?? ref.read(appRepositoryProvider).signedInUser?.id;
    _primaryPhotoId = item?.photos
        .where((photo) => photo.isPrimary)
        .firstOrNull
        ?.id;
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
        SnackBar(
          content: Text(context.l10n.requiredField(context.l10n.itemName)),
        ),
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
              ownerUserId: _visibility == 'private' ? _ownerUserId : null,
            );
    try {
      var saved = await ref
          .read(workspaceActionsProvider)
          .saveItem(item, isNew: old == null);
      for (final bytes in _pendingPhotos) {
        final photo = await ref
            .read(workspaceActionsProvider)
            .uploadItemPhoto(item: saved, bytes: bytes, extension: 'jpg');
        saved = saved.copyWith(photos: [...saved.photos, photo]);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        if (error is ConflictException) {
          final reload = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(context.l10n.conflictTitle),
              content: Text(context.l10n.conflictBody),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(context.l10n.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(context.l10n.reloadLatest),
                ),
              ],
            ),
          );
          if (reload == true && mounted) Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error.toString())));
        }
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final existingCount =
        (widget.item?.photos.length ?? 0) + _pendingPhotos.length;
    if (existingCount >= 3) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.photoLimit)));
      return;
    }
    final image = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
    if (image == null) return;
    final bytes = await image.readAsBytes();
    if (!mounted) return;
    setState(() => _pendingPhotos.add(bytes));
  }

  Future<void> _createCategory(List<Category> categories) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.categoryAdd),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: context.l10n.categoryName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(context.l10n.add),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;
    try {
      final category = await ref
          .read(workspaceActionsProvider)
          .createCategory(spaceId: widget.spaceId, name: name);
      if (mounted) setState(() => _categoryId = category.id);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(locationsForSpaceProvider(widget.spaceId));
    final categories =
        ref.watch(categoriesProvider(widget.spaceId)).value ??
        const <Category>[];
    final members =
        ref.watch(spaceMembersProvider(widget.spaceId)).value ??
        const <SpaceMember>[];
    final currentUserId = ref.read(appRepositoryProvider).signedInUser?.id;
    final currentMember = members
        .where((member) => member.userId == currentUserId)
        .firstOrNull;
    final ownerMembers = currentMember?.role == 'admin'
        ? members
        : members.where((member) => member.userId == currentUserId).toList();
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
                      widget.item == null
                          ? context.l10n.addItem
                          : context.l10n.itemEdit,
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
                decoration: InputDecoration(
                  labelText: context.l10n.categoryOptional,
                ),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(context.l10n.none),
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _createCategory(categories),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(context.l10n.categoryAdd),
                ),
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
                onSelectionChanged: (value) => setState(() {
                  _visibility = value.first;
                  if (_visibility == 'private' && _ownerUserId == null) {
                    _ownerUserId = currentUserId;
                  }
                }),
              ),
              if (_visibility == 'private' && ownerMembers.isNotEmpty) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue:
                      ownerMembers.any(
                        (member) => member.userId == _ownerUserId,
                      )
                      ? _ownerUserId
                      : currentUserId,
                  decoration: InputDecoration(labelText: context.l10n.owner),
                  items: [
                    for (final member in ownerMembers)
                      DropdownMenuItem(
                        value: member.userId,
                        child: Text(member.displayName ?? member.userId),
                      ),
                  ],
                  onChanged: (value) => setState(() => _ownerUserId = value),
                ),
              ],
              const SizedBox(height: 12),
              TextField(
                controller: _detailController,
                decoration: InputDecoration(
                  labelText: context.l10n.detailLocationOptional,
                ),
              ),
              const SizedBox(height: 12),
              _PhotoSection(
                item: widget.item,
                pendingPhotos: _pendingPhotos,
                onPickCamera: () => _pickPhoto(ImageSource.camera),
                onPickGallery: () => _pickPhoto(ImageSource.gallery),
                onRemovePending: (index) =>
                    setState(() => _pendingPhotos.removeAt(index)),
                onDeleteExisting: (photo) async {
                  if (widget.item == null) return;
                  await ref
                      .read(workspaceActionsProvider)
                      .deleteItemPhoto(widget.item!, photo);
                  if (mounted) setState(() {});
                },
                primaryPhotoId: _primaryPhotoId,
                onSetPrimary: (photo) async {
                  if (widget.item == null) return;
                  await ref
                      .read(workspaceActionsProvider)
                      .setPrimaryItemPhoto(widget.item!, photo);
                  if (mounted) setState(() => _primaryPhotoId = photo.id);
                },
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

class _PhotoSection extends StatelessWidget {
  const _PhotoSection({
    required this.item,
    required this.pendingPhotos,
    required this.onPickCamera,
    required this.onPickGallery,
    required this.onRemovePending,
    required this.onDeleteExisting,
    required this.primaryPhotoId,
    required this.onSetPrimary,
  });

  final Item? item;
  final List<Uint8List> pendingPhotos;
  final VoidCallback onPickCamera;
  final VoidCallback onPickGallery;
  final ValueChanged<int> onRemovePending;
  final ValueChanged<ItemPhoto> onDeleteExisting;
  final String? primaryPhotoId;
  final ValueChanged<ItemPhoto> onSetPrimary;

  @override
  Widget build(BuildContext context) {
    final photos = item?.photos ?? const <ItemPhoto>[];
    final total = photos.length + pendingPhotos.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.photoCount(total),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              onPressed: total >= 3 ? null : onPickCamera,
              tooltip: context.l10n.camera,
              icon: const Icon(Icons.camera_alt_outlined),
            ),
            IconButton(
              onPressed: total >= 3 ? null : onPickGallery,
              tooltip: context.l10n.gallery,
              icon: const Icon(Icons.photo_library_outlined),
            ),
          ],
        ),
        if (total == 0)
          Text(
            context.l10n.photoHint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        if (total > 0)
          SizedBox(
            height: 92,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final photo in photos)
                  _ExistingPhotoTile(
                    photo: photo,
                    onDelete: () => onDeleteExisting(photo),
                    isPrimary:
                        primaryPhotoId == photo.id ||
                        (primaryPhotoId == null && photo.isPrimary),
                    onSetPrimary: () => onSetPrimary(photo),
                  ),
                for (var index = 0; index < pendingPhotos.length; index++)
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            pendingPhotos[index],
                            width: 92,
                            height: 92,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 0,
                        child: IconButton.filledTonal(
                          onPressed: () => onRemovePending(index),
                          icon: const Icon(Icons.close, size: 16),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ExistingPhotoTile extends ConsumerWidget {
  const _ExistingPhotoTile({
    required this.photo,
    required this.onDelete,
    required this.isPrimary,
    required this.onSetPrimary,
  });

  final ItemPhoto photo;
  final VoidCallback onDelete;
  final bool isPrimary;
  final VoidCallback onSetPrimary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<String>(
      future: ref
          .read(workspaceActionsProvider)
          .createItemPhotoSignedUrl(photo),
      builder: (context, snapshot) => Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: snapshot.hasData && snapshot.data!.isNotEmpty
                  ? Image.network(
                      snapshot.data!,
                      width: 92,
                      height: 92,
                      fit: BoxFit.cover,
                      errorBuilder: (_, error, stack) =>
                          const _PhotoPlaceholder(),
                    )
                  : const _PhotoPlaceholder(),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: IconButton.filledTonal(
              onPressed: onSetPrimary,
              icon: Icon(isPrimary ? Icons.star : Icons.star_border, size: 16),
              visualDensity: VisualDensity.compact,
            ),
          ),
          Positioned(
            right: 8,
            top: 0,
            child: IconButton.filledTonal(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, size: 16),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) => Container(
    width: 92,
    height: 92,
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: const Icon(Icons.image_outlined),
  );
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
