import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/data/repository_providers.dart';
import '../../../core/models/app_models.dart';
import '../../item/presentation/item_editor_sheet.dart';

class ShoppingPage extends ConsumerWidget {
  const ShoppingPage({required this.spaceId, super.key});

  final String spaceId;

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.addShoppingItem),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: context.l10n.purchaseItem),
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
    if (!context.mounted) return;
    final existing =
        ref.read(shoppingItemsStreamProvider(spaceId)).value ??
        const <ShoppingItem>[];
    if (existing.any((item) => item.name.toLowerCase() == name.toLowerCase())) {
      final addAnyway = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.duplicateShoppingItem),
          content: Text(context.l10n.duplicateShoppingMessage(name)),
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
    await ref
        .read(workspaceActionsProvider)
        .addShoppingItem(spaceId: spaceId, name: name);
  }

  Future<void> _complete(
    BuildContext context,
    WidgetRef ref,
    ShoppingItem item,
  ) async {
    final updated = item.copyWith(
      isCompleted: !item.isCompleted,
      completedBy: !item.isCompleted
          ? ref.read(appRepositoryProvider).signedInUser?.id
          : null,
      completedAt: !item.isCompleted ? DateTime.now().toUtc() : null,
    );
    await ref.read(workspaceActionsProvider).updateShoppingItem(updated);
    if (!updated.isCompleted || !context.mounted) return;
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: Text(context.l10n.registerAtHome),
              onTap: () => Navigator.pop(context, 'register'),
            ),
            ListTile(
              leading: const Icon(Icons.check),
              title: Text(context.l10n.completeOnly),
              onTap: () => Navigator.pop(context, 'done'),
            ),
          ],
        ),
      ),
    );
    if (choice == 'register' && context.mounted) {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) =>
            ItemEditorSheet(spaceId: spaceId, initialName: item.name),
      );
    }
  }

  Future<void> _assign(
    BuildContext context,
    WidgetRef ref,
    ShoppingItem item,
  ) async {
    final members =
        ref.read(spaceMembersProvider(spaceId)).value ?? const <SpaceMember>[];
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(context.l10n.chooseAssignee),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ''),
            child: Text(context.l10n.noAssignee),
          ),
          for (final member in members)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, member.userId),
              child: Text(member.displayName ?? member.userId),
            ),
        ],
      ),
    );
    if (selected == null) return;
    await ref
        .read(workspaceActionsProvider)
        .updateShoppingItem(
          item.copyWith(assigneeUserId: selected.isEmpty ? null : selected),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(shoppingItemsStreamProvider(spaceId));
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.shopping)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context, ref),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.add),
      ),
      body: items.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(error.toString())),
        data: (values) => values.isEmpty
            ? Center(child: Text(context.l10n.shoppingEmpty))
            : RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(shoppingItemsProvider(spaceId));
                  ref.invalidate(shoppingItemsStreamProvider(spaceId));
                },
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                  itemCount: values.length,
                  onReorderItem: (oldIndex, newIndex) async {
                    final moved = values.removeAt(oldIndex);
                    if (newIndex > oldIndex) newIndex -= 1;
                    values.insert(newIndex, moved);
                    for (var index = 0; index < values.length; index++) {
                      await ref
                          .read(workspaceActionsProvider)
                          .updateShoppingItem(
                            values[index].copyWith(sortOrder: index.toDouble()),
                          );
                    }
                  },
                  itemBuilder: (context, index) {
                    final item = values[index];
                    return Card(
                      key: ValueKey(item.id),
                      child: Dismissible(
                        key: ValueKey('dismiss-${item.id}'),
                        background: Container(
                          color: Theme.of(context).colorScheme.errorContainer,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          child: const Icon(Icons.delete_outline),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => ref
                            .read(workspaceActionsProvider)
                            .deleteShoppingItem(item),
                        child: CheckboxListTile(
                          value: item.isCompleted,
                          onChanged: (_) => _complete(context, ref, item),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              decoration: item.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: item.assigneeUserId == null
                              ? null
                              : Text(context.l10n.assigned),
                          secondary: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'assign') {
                                _assign(context, ref, item);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'assign',
                                child: Text(context.l10n.assign),
                              ),
                            ],
                            icon: const Icon(Icons.person_outline),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
