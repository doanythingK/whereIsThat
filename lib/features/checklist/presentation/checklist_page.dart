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
    final result = await showDialog<(String, String)?>(
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
                decoration: const InputDecoration(labelText: '이름'),
              ),
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
              onPressed: () =>
                  Navigator.pop(context, (controller.text.trim(), visibility)),
              child: Text(context.l10n.add),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (result == null || result.$1.isEmpty) return;
    final checklist = await ref
        .read(workspaceActionsProvider)
        .createChecklist(
          spaceId: widget.spaceId,
          name: result.$1,
          visibility: result.$2,
        );
    setState(() => _selectedId = checklist.id);
  }

  Future<void> _addItem(Checklist checklist) async {
    final controller = TextEditingController();
    final linkedItems =
        ref
            .read(itemsProvider((spaceId: widget.spaceId, search: null)))
            .value ??
        const <Item>[];
    String? linkedItemId;
    final result = await showDialog<(String, String?)?>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('항목 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(labelText: '준비할 물건'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                initialValue: linkedItemId,
                decoration: const InputDecoration(labelText: '연결할 물건 (선택)'),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('연결하지 않음'),
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
        ),
      ),
    );
    controller.dispose();
    if (result == null || result.$1.isEmpty) return;
    await ref
        .read(workspaceActionsProvider)
        .saveChecklistItem(
          ChecklistItem(
            id: '',
            checklistId: checklist.id,
            name: result.$1,
            linkedItemId: result.$2,
            sortOrder:
                (ref.read(checklistItemsProvider(checklist.id)).value?.length ??
                        0)
                    .toDouble(),
          ),
          isNew: true,
        );
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
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: DropdownButtonFormField<String>(
                  initialValue: selected.id,
                  decoration: const InputDecoration(labelText: '목록'),
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
                        selected.visibility == 'shared' ? '공간 공유 목록' : '개인 목록',
                      ),
                    ),
                    TextButton(
                      onPressed: () => ref
                          .read(workspaceActionsProvider)
                          .completeChecklist(
                            selected,
                            complete: !selected.isCompleted,
                          ),
                      child: Text(selected.isCompleted ? '완료 취소' : '목록 완료'),
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
                        final checks = ref.watch(memberChecksProvider(item.id));
                        return Card(
                          child: ExpansionTile(
                            title: Text(item.name),
                            subtitle: Text(
                              linked == null
                                  ? '연결된 물건 없음'
                                  : '${linked.name} · ${linked.locationId == null ? context.l10n.unassignedLocation : context.l10n.location}',
                            ),
                            trailing: Checkbox(
                              value: item.isFinalCompleted,
                              onChanged: (_) => ref
                                  .read(workspaceActionsProvider)
                                  .toggleChecklistItem(item),
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
                                                    checklistItemId: item.id,
                                                    userId: member.userId,
                                                  ),
                                              enabled:
                                                  currentUser?.id ==
                                                  member.userId,
                                              onChanged: (check) => ref
                                                  .read(
                                                    workspaceActionsProvider,
                                                  )
                                                  .toggleMemberCheck(check),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
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
      subtitle: Text(enabled ? '내 준비 상태' : '멤버 준비 상태'),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
