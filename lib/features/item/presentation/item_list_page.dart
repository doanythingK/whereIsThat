import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/data/repository_providers.dart';
import '../../../core/models/app_models.dart';
import 'item_detail_sheet.dart';
import 'item_editor_sheet.dart';

class ItemListPage extends ConsumerStatefulWidget {
  const ItemListPage({required this.spaceId, this.initialQuery, super.key});

  final String spaceId;
  final String? initialQuery;

  @override
  ConsumerState<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends ConsumerState<ItemListPage> {
  late final TextEditingController _searchController;
  String? _query;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _edit([Item? item]) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ItemEditorSheet(spaceId: widget.spaceId, item: item),
    );
    ref.invalidate(itemsProvider((spaceId: widget.spaceId, search: _query)));
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(
      itemsProvider((spaceId: widget.spaceId, search: _query)),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.itemList),
        actions: [
          IconButton(onPressed: () => _edit(), icon: const Icon(Icons.add)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.addItem),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: context.l10n.search,
                suffixIcon: _query?.isNotEmpty == true
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = null);
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
              onSubmitted: (value) => setState(
                () => _query = value.trim().isEmpty ? null : value.trim(),
              ),
            ),
          ),
          Expanded(
            child: items.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text(error.toString())),
              data: (values) => values.isEmpty
                  ? Center(child: Text(context.l10n.noItems))
                  : RefreshIndicator(
                      onRefresh: () async => ref.invalidate(
                        itemsProvider((
                          spaceId: widget.spaceId,
                          search: _query,
                        )),
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
                        itemCount: values.length,
                        itemBuilder: (context, index) => _ItemTile(
                          item: values[index],
                          onEdit: () => _edit(values[index]),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemTile extends ConsumerWidget {
  const _ItemTile({required this.item, required this.onEdit});

  final Item item;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => ItemDetailSheet(item: item),
        ),
        onLongPress: onEdit,
        leading: CircleAvatar(
          child: Icon(
            item.visibility == 'private'
                ? Icons.lock_outline
                : Icons.inventory_2_outlined,
          ),
        ),
        title: Text(item.name),
        subtitle: Text(
          '${item.quantity}${item.unit == null ? '' : ' ${item.unit}'} · ${item.locationId == null ? context.l10n.unassignedLocation : context.l10n.location}',
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'favorite') {
              await ref.read(workspaceActionsProvider).toggleFavorite(item);
            }
            if (value == 'delete') {
              await ref.read(workspaceActionsProvider).deleteItem(item);
            }
            if (context.mounted) {
              ref.invalidate(
                itemsProvider((spaceId: item.spaceId, search: null)),
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'favorite',
              child: Text(context.l10n.favoriteAction(item.isFavorite)),
            ),
            PopupMenuItem(value: 'delete', child: Text(context.l10n.delete)),
          ],
        ),
      ),
    );
  }
}
