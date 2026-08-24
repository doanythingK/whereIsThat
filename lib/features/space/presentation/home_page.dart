import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/data/repository_providers.dart';
import '../../../core/models/app_models.dart';
import '../../../core/widgets/ad_banner.dart';
import '../../item/presentation/item_editor_sheet.dart';

class HomePage extends ConsumerWidget {
  const HomePage({required this.spaceId, super.key});

  final String spaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spaces = ref.watch(spacesProvider).value ?? const <Space>[];
    final space = spaces.where((item) => item.id == spaceId).firstOrNull;
    final items = ref.watch(itemsProvider((spaceId: spaceId, search: null)));
    final user = ref.watch(currentUserProvider).value;
    final strings = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: PopupMenuButton<String>(
          onSelected: (value) => value == '__spaces__'
              ? context.go('/spaces')
              : context.go('/space/$value/home'),
          itemBuilder: (context) => [
            for (final other in spaces)
              PopupMenuItem(value: other.id, child: Text(other.name)),
            const PopupMenuDivider(),
            PopupMenuItem(value: '__spaces__', child: Text(strings.spaces)),
          ],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(space?.name ?? strings.home),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        actions: [
          IconButton(
            tooltip: strings.addItem,
            onPressed: () => _openItemEditor(context, ref),
            icon: const Icon(Icons.add_box_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(itemsProvider((spaceId: spaceId, search: null))),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Text(
              strings.greeting(user?.nickname ?? strings.neighbor),
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 18),
            TextField(
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: strings.search,
              ),
              onSubmitted: (query) {
                final encoded = Uri.encodeQueryComponent(query.trim());
                context.go('/space/$spaceId/items?q=$encoded');
              },
            ),
            const SizedBox(height: 22),
            _ShortcutGrid(spaceId: spaceId),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strings.favorites,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                TextButton(
                  onPressed: () => context.go('/space/$spaceId/items'),
                  child: Text(strings.more),
                ),
              ],
            ),
            const SizedBox(height: 8),
            items.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => Text(error.toString()),
              data: (values) {
                final favorites = values
                    .where((item) => item.isFavorite)
                    .toList();
                if (favorites.isEmpty) return Text(strings.noItems);
                return Column(
                  children: [
                    for (final item in favorites)
                      _FavoriteItemCard(
                        item: item,
                        onChanged: () => ref.invalidate(
                          itemsProvider((spaceId: spaceId, search: null)),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }

  Future<void> _openItemEditor(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ItemEditorSheet(spaceId: spaceId),
    );
    ref.invalidate(itemsProvider((spaceId: spaceId, search: null)));
  }
}

class _ShortcutGrid extends ConsumerWidget {
  const _ShortcutGrid({required this.spaceId});

  final String spaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const defaultKeys = ['floor_plan', 'items', 'shopping', 'checklist'];
    final configured = ref.watch(homeShortcutsProvider).value ?? defaultKeys;
    final keys = configured.isEmpty ? defaultKeys : configured.take(4).toList();
    final allShortcuts = _shortcutDefinitions(context);
    final shortcuts = keys
        .map((key) => allShortcuts[key])
        .whereType<({IconData icon, String label, String path})>()
        .toList();
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _editShortcuts(context, ref, keys),
            icon: const Icon(Icons.tune, size: 18),
            label: Text(context.l10n.editShortcuts),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: shortcuts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.8,
          ),
          itemBuilder: (context, index) => Card(
            color: Theme.of(context).colorScheme.primaryContainer
                .withValues(alpha: .55),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => context.go(shortcuts[index].path),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(shortcuts[index].icon),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        shortcuts[index].label,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Map<String, ({IconData icon, String label, String path})>
  _shortcutDefinitions(BuildContext context) => {
    'floor_plan': (
      icon: Icons.map_outlined,
      label: context.l10n.floorPlan,
      path: '/space/$spaceId/floor-plan',
    ),
    'items': (
      icon: Icons.inventory_2_outlined,
      label: context.l10n.addItem,
      path: '/space/$spaceId/items',
    ),
    'shopping': (
      icon: Icons.shopping_cart_outlined,
      label: context.l10n.shopping,
      path: '/space/$spaceId/shopping',
    ),
    'checklist': (
      icon: Icons.checklist_outlined,
      label: context.l10n.checklist,
      path: '/space/$spaceId/checklist',
    ),
    'more': (
      icon: Icons.menu,
      label: context.l10n.more,
      path: '/space/$spaceId/more',
    ),
  };

  Future<void> _editShortcuts(
    BuildContext context,
    WidgetRef ref,
    List<String> current,
  ) async {
    final definitions = _shortcutDefinitions(context);
    final selected = current.toSet();
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.l10n.editShortcuts),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final entry in definitions.entries)
                CheckboxListTile(
                  value: selected.contains(entry.key),
                  title: Text(entry.value.label),
                  secondary: Icon(entry.value.icon),
                  onChanged: (value) {
                    if (value == true && selected.length >= 4) return;
                    setDialogState(() {
                      if (value == true) {
                        selected.add(entry.key);
                      } else {
                        selected.remove(entry.key);
                      }
                    });
                  },
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(context.l10n.shortcutLimit),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: selected.isEmpty
                  ? null
                  : () => Navigator.pop(context, selected.toList()),
              child: Text(context.l10n.save),
            ),
          ],
        ),
      ),
    );
    if (result == null) return;
    await ref.read(workspaceActionsProvider).saveHomeShortcuts(result);
  }
}

class _FavoriteItemCard extends ConsumerWidget {
  const _FavoriteItemCard({required this.item, required this.onChanged});

  final Item item;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.inventory_2_outlined)),
        title: Text(item.name),
        subtitle: Text(
          item.locationId == null
              ? context.l10n.unassignedLocation
              : context.l10n.location,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.star),
          onPressed: () async {
            await ref.read(workspaceActionsProvider).toggleFavorite(item);
            onChanged();
          },
        ),
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
