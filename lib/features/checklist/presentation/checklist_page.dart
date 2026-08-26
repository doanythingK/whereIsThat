import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/data/repository_providers.dart';
import '../../../core/models/app_models.dart';

class ChecklistPage extends ConsumerStatefulWidget {
  const ChecklistPage({required this.spaceId, super.key});

  final String spaceId;

  @override
  ConsumerState<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends ConsumerState<ChecklistPage> {
  String? _selectedId;

  Future<void> _createChecklist() async {
    final controller = TextEditingController();
    var visibility = 'shared';
    String? templateId;
    final templates =
        ref.read(checklistTemplatesProvider).value ??
        const <ChecklistTemplate>[];
    final result = await showDialog<(String, String, String?)?>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.l10n.addChecklist),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: context.l10n.checklistName,
                ),
              ),
              if (templates.isNotEmpty) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: templateId,
                  decoration: InputDecoration(
                    labelText: context.l10n.defaultTemplateOptional,
                  ),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(context.l10n.checklistDirectCreate),
                    ),
                    for (final template in templates)
                      DropdownMenuItem<String?>(
                        value: template.id,
                        child: Text(template.name),
                      ),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      templateId = value;
                      if (value != null && controller.text.trim().isEmpty) {
                        controller.text = templates
                            .firstWhere((template) => template.id == value)
                            .name;
                      }
                    });
                  },
                ),
              ],
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'shared',
                    label: Text(context.l10n.sharedItem),
                  ),
                  ButtonSegment(
                    value: 'personal',
                    label: Text(context.l10n.privateItem),
                  ),
                ],
                selected: {visibility},
                onSelectionChanged: (value) =>
                    setDialogState(() => visibility = value.first),
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
                controller.text.trim(),
                visibility,
                templateId,
              )),
              child: Text(context.l10n.add),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (result == null || result.$1.isEmpty) return;
    if (!mounted) return;
    try {
      final checklist = await ref
          .read(workspaceActionsProvider)
          .createChecklist(
            spaceId: result.$2 == 'shared' ? widget.spaceId : null,
            name: result.$1,
            visibility: result.$2,
          );
      if (!mounted) return;
      if (result.$3 != null) {
        final templateItems = await ref.read(
          checklistTemplateItemsProvider(result.$3!).future,
        );
        for (final templateItem in templateItems) {
          if (!mounted) return;
          await ref
              .read(workspaceActionsProvider)
              .saveChecklistItem(
                ChecklistItem(
                  id: '',
                  checklistId: checklist.id,
                  name: templateItem.name,
                  sortOrder: templateItem.sortOrder,
                ),
                isNew: true,
              );
        }
      }
      if (!mounted) return;
      ref.invalidate(checklistsProvider(widget.spaceId));
      setState(() => _selectedId = checklist.id);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  Future<void> _toggleChecklistCompletion(Checklist checklist) async {
    try {
      await ref
          .read(workspaceActionsProvider)
          .completeChecklist(checklist, complete: !checklist.isCompleted);
      if (mounted) ref.invalidate(checklistsProvider(widget.spaceId));
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  Future<void> _addItem(Checklist checklist, {ChecklistItem? existing}) async {
    final controller = TextEditingController();
    controller.text = existing?.name ?? '';
    final linkedItemsState = ref.read(
      itemsProvider((spaceId: widget.spaceId, search: null)),
    );
    final linkedItems = linkedItemsState.value ?? const <Item>[];
    final existingLinkedItemId = existing?.linkedItemId;
    String? linkedItemId =
        linkedItemsState.hasValue &&
            existingLinkedItemId != null &&
            !linkedItems.any((item) => item.id == existingLinkedItemId)
        ? null
        : existingLinkedItemId;
    var suggestions = <Item>[];
    final result = await showDialog<(String, String?)?>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final selectedLinkedItemId =
              linkedItems.any((item) => item.id == linkedItemId)
              ? linkedItemId
              : null;
          return AlertDialog(
            title: Text(
              existing == null
                  ? context.l10n.checklistItemAdd
                  : context.l10n.checklistItemEdit,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.prepareItem,
                  ),
                  onChanged: (value) => setDialogState(() {
                    final query = value.trim().toLowerCase();
                    suggestions = query.length < 2
                        ? const <Item>[]
                        : linkedItems
                              .where(
                                (item) =>
                                    item.name.toLowerCase().contains(query),
                              )
                              .take(3)
                              .toList();
                    if (suggestions.length == 1 && linkedItemId == null) {
                      linkedItemId = suggestions.single.id;
                    }
                  }),
                ),
                if (suggestions.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 6,
                      children: [
                        for (final suggestion in suggestions)
                          ActionChip(
                            label: Text(suggestion.name),
                            onPressed: () => setDialogState(
                              () => linkedItemId = suggestion.id,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: selectedLinkedItemId,
                  decoration: InputDecoration(
                    labelText: context.l10n.linkedItemOptional,
                  ),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(context.l10n.notLinked),
                    ),
                    for (final item in linkedItems)
                      DropdownMenuItem<String?>(
                        value: item.id,
                        child: Text(item.name),
                      ),
                  ],
                  onChanged: (value) =>
                      setDialogState(() => linkedItemId = value),
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
                  controller.text.trim(),
                  linkedItemId,
                )),
                child: Text(context.l10n.add),
              ),
            ],
          );
        },
      ),
    );
    controller.dispose();
    if (result == null || result.$1.isEmpty) return;
    if (!mounted) return;
    late List<ChecklistItem> currentItems;
    try {
      currentItems = await ref.read(
        checklistItemsProvider(checklist.id).future,
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
      return;
    }
    if (!mounted) return;
    if (existing == null) {
      final duplicate = currentItems.any(
        (item) => item.name.toLowerCase() == result.$1.toLowerCase(),
      );
      if (duplicate) {
        final addAnyway = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.l10n.duplicateChecklistItem),
            content: Text(context.l10n.duplicateChecklistMessage(result.$1)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(context.l10n.add),
              ),
            ],
          ),
        );
        if (addAnyway != true) return;
      }
    }
    final item =
        existing?.copyWith(name: result.$1, linkedItemId: result.$2) ??
        ChecklistItem(
          id: '',
          checklistId: checklist.id,
          name: result.$1,
          linkedItemId: result.$2,
          sortOrder: currentItems.length.toDouble(),
        );
    try {
      await ref
          .read(workspaceActionsProvider)
          .saveChecklistItem(item, isNew: existing == null);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  Future<void> _saveAsTemplate(Checklist checklist) async {
    try {
      await ref
          .read(workspaceActionsProvider)
          .saveChecklistAsTemplate(checklist);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.templateSaved)));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  Future<void> _toggleChecklistItem(ChecklistItem item) async {
    try {
      await ref.read(workspaceActionsProvider).toggleChecklistItem(item);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  Future<void> _deleteChecklistItem(ChecklistItem item) async {
    try {
      await ref.read(workspaceActionsProvider).deleteChecklistItem(item);
    } catch (error) {
      if (mounted) {
        ref.invalidate(checklistItemsStreamProvider(item.checklistId));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  Future<void> _toggleMemberCheck(ChecklistMemberCheck check) async {
    try {
      await ref.read(workspaceActionsProvider).toggleMemberCheck(check);
    } catch (error) {
      if (mounted) {
        ref.invalidate(memberChecksStreamProvider(check.checklistItemId));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lists = ref.watch(checklistsProvider(widget.spaceId));
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.checklist),
        actions: [
          IconButton(onPressed: _createChecklist, icon: const Icon(Icons.add)),
        ],
      ),
      body: lists.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(error.toString())),
        data: (values) {
          if (values.isEmpty) {
            return Center(
              child: FilledButton.icon(
                onPressed: _createChecklist,
                icon: const Icon(Icons.add),
                label: Text(context.l10n.addChecklist),
              ),
            );
          }
          final selected =
              values.where((item) => item.id == _selectedId).firstOrNull ??
              values.first;
          if (_selectedId != selected.id) _selectedId = selected.id;
          final items = ref.watch(checklistItemsStreamProvider(selected.id));
          final members =
              ref.watch(spaceMembersProvider(widget.spaceId)).value ??
              const <SpaceMember>[];
          final currentUser = ref.watch(currentUserProvider).value;
          final linkedItems =
              ref
                  .watch(itemsProvider((spaceId: widget.spaceId, search: null)))
                  .value ??
              const <Item>[];
          final locations =
              ref.watch(locationsForSpaceProvider(widget.spaceId)).value ??
              const <Location>[];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: DropdownButtonFormField<String>(
                  initialValue: selected.id,
                  decoration: InputDecoration(
                    labelText: context.l10n.checklistList,
                  ),
                  items: [
                    for (final checklist in values)
                      DropdownMenuItem(
                        value: checklist.id,
                        child: Text(checklist.name),
                      ),
                  ],
                  onChanged: (value) => setState(() => _selectedId = value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selected.visibility == 'shared'
                            ? context.l10n.sharedChecklist
                            : context.l10n.personalChecklist,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _toggleChecklistCompletion(selected),
                      child: Text(
                        selected.isCompleted
                            ? context.l10n.checklistCompleteCancel
                            : context.l10n.checklistComplete,
                      ),
                    ),
                    IconButton(
                      tooltip: context.l10n.saveAsTemplate,
                      onPressed: () => _saveAsTemplate(selected),
                      icon: const Icon(Icons.bookmark_add_outlined),
                    ),
                    IconButton(
                      onPressed: () => _addItem(selected),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: items.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) =>
                      Center(child: Text(error.toString())),
                  data: (itemValues) {
                    if (itemValues.isEmpty) {
                      return Center(child: Text(context.l10n.checklistEmpty));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                      itemCount: itemValues.length,
                      itemBuilder: (context, index) {
                        final item = itemValues[index];
                        final linked = linkedItems
                            .where(
                              (candidate) => candidate.id == item.linkedItemId,
                            )
                            .firstOrNull;
                        final locationName = locations
                            .where(
                              (location) => location.id == linked?.locationId,
                            )
                            .map((location) => location.name)
                            .firstOrNull;
                        final checks = ref.watch(
                          memberChecksStreamProvider(item.id),
                        );
                        return Dismissible(
                          key: ValueKey(item.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Theme.of(context).colorScheme.errorContainer,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 24),
                            child: const Icon(Icons.delete_outline),
                          ),
                          onDismissed: (_) => _deleteChecklistItem(item),
                          child: GestureDetector(
                            onLongPress: () =>
                                _addItem(selected, existing: item),
                            child: Card(
                              child: ExpansionTile(
                                title: Text(item.name),
                                subtitle: Text(
                                  linked == null
                                      ? context.l10n.noLinkedItem
                                      : '${linked.name} · ${locationName ?? context.l10n.unassignedLocation}',
                                ),
                                trailing: Checkbox(
                                  value: item.isFinalCompleted,
                                  onChanged: (_) => _toggleChecklistItem(item),
                                ),
                                children: selected.visibility != 'shared'
                                    ? const []
                                    : [
                                        checks.when(
                                          loading: () => const Padding(
                                            padding: EdgeInsets.all(12),
                                            child: CircularProgressIndicator(),
                                          ),
                                          error: (error, stack) => Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Text(error.toString()),
                                          ),
                                          data: (checkValues) => Column(
                                            children: [
                                              for (final member in members)
                                                _MemberCheckTile(
                                                  member: member,
                                                  check:
                                                      checkValues
                                                          .where(
                                                            (check) =>
                                                                check.userId ==
                                                                member.userId,
                                                          )
                                                          .firstOrNull ??
                                                      ChecklistMemberCheck(
                                                        checklistItemId:
                                                            item.id,
                                                        userId: member.userId,
                                                      ),
                                                  enabled:
                                                      currentUser?.id ==
                                                      member.userId,
                                                  onChanged: (check) =>
                                                      _toggleMemberCheck(check),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MemberCheckTile extends StatelessWidget {
  const _MemberCheckTile({
    required this.member,
    required this.check,
    required this.enabled,
    required this.onChanged,
  });

  final SpaceMember member;
  final ChecklistMemberCheck check;
  final bool enabled;
  final ValueChanged<ChecklistMemberCheck> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      dense: true,
      value: check.isChecked,
      onChanged: enabled ? (_) => onChanged(check) : null,
      title: Text(member.displayName ?? member.userId),
      subtitle: Text(
        enabled ? context.l10n.myPreparation : context.l10n.memberPreparation,
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
