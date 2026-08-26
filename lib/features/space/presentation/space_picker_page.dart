import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/data/repository_providers.dart';
import '../../../core/models/app_models.dart';
import '../../auth/application/auth_actions.dart';

class SpacePickerPage extends ConsumerWidget {
  const SpacePickerPage({super.key});

  Future<void> _createSpace(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    var iconKey = 'home';
    var iconColor = '#2563EB';
    final result =
        await showDialog<({String name, String iconKey, String iconColor})?>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.l10n.createSpace),
            content: StatefulBuilder(
              builder: (context, setDialogState) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: context.l10n.spaceName,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: iconKey,
                    decoration: InputDecoration(
                      labelText: context.l10n.spaceIcon,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'home',
                        child: Text(context.l10n.homeSpace),
                      ),
                      DropdownMenuItem(
                        value: 'office',
                        child: Text(context.l10n.officeSpace),
                      ),
                      DropdownMenuItem(
                        value: 'storage',
                        child: Text(context.l10n.storageSpace),
                      ),
                    ],
                    onChanged: (value) =>
                        setDialogState(() => iconKey = value ?? iconKey),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final color in <String>[
                        '#2563EB',
                        '#16A34A',
                        '#EA580C',
                        '#9333EA',
                      ])
                        ChoiceChip(
                          label: CircleAvatar(
                            backgroundColor: _hexColor(color),
                            radius: 10,
                          ),
                          selected: iconColor == color,
                          onSelected: (_) =>
                              setDialogState(() => iconColor = color),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop((
                  name: controller.text.trim(),
                  iconKey: iconKey,
                  iconColor: iconColor,
                )),
                child: Text(context.l10n.save),
              ),
            ],
          ),
        );
    controller.dispose();
    if (result == null || result.name.isEmpty || !context.mounted) return;
    try {
      final space = await ref
          .read(workspaceActionsProvider)
          .createSpace(
            name: result.name,
            iconKey: result.iconKey,
            iconColor: result.iconColor,
          );
      if (context.mounted) context.go('/space/${space.id}/home');
    } catch (error) {
      if (context.mounted) _showError(context, error.toString());
    }
  }

  Color _hexColor(String value) {
    final hex = value.replaceFirst('#', '');
    final parsed = int.tryParse('FF$hex', radix: 16);
    return parsed == null ? Colors.blue : Color(parsed);
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spaces = ref.watch(spacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.chooseSpace),
        actions: [
          IconButton(
            tooltip: context.l10n.invite,
            onPressed: () => _enterInviteCode(context),
            icon: const Icon(Icons.group_add_outlined),
          ),
          IconButton(
            tooltip: context.l10n.restore,
            onPressed: () => _showDeletedSpaces(context, ref),
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
          IconButton(
            tooltip: context.l10n.signOut,
            onPressed: () async {
              try {
                await ref.read(authActionsProvider).signOut();
                if (context.mounted) context.go('/auth');
              } catch (error) {
                if (context.mounted) _showError(context, error.toString());
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createSpace(context, ref),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.createSpace),
      ),
      body: spaces.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _ErrorView(
          error: error,
          onRetry: () => ref.invalidate(spacesProvider),
        ),
        data: (values) => values.isEmpty
            ? Center(child: Text(context.l10n.noSpaces))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                itemCount: values.length,
                separatorBuilder: (_, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _SpaceCard(space: values[index]),
              ),
      ),
    );
  }

  Future<void> _enterInviteCode(BuildContext context) async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.invite),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(labelText: context.l10n.inviteCode),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(context.l10n.continueLabel),
          ),
        ],
      ),
    );
    controller.dispose();
    if (code == null || code.isEmpty || !context.mounted) return;
    context.go('/invite/${Uri.encodeComponent(code)}');
  }

  Future<void> _showDeletedSpaces(BuildContext context, WidgetRef ref) async {
    late List<Space> spaces;
    try {
      spaces = await ref.read(deletedSpacesProvider.future);
    } catch (error) {
      if (context.mounted) _showError(context, error.toString());
      return;
    }
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: spaces.isEmpty
            ? Padding(
                padding: EdgeInsets.all(24),
                child: Text(context.l10n.noDeletedSpace),
              )
            : ListView(
                shrinkWrap: true,
                children: [
                  for (final space in spaces)
                    ListTile(
                      title: Text(space.name),
                      subtitle: Text(
                        space.deletePurgeAt == null
                            ? context.l10n.thirtyDayRetention
                            : context.l10n.scheduledDeletion(
                                space.deletePurgeAt!,
                              ),
                      ),
                      trailing: IconButton(
                        tooltip: context.l10n.restore,
                        icon: const Icon(Icons.restore),
                        onPressed: () async {
                          try {
                            await ref
                                .read(workspaceActionsProvider)
                                .restoreSpace(space);
                            if (context.mounted) Navigator.pop(context);
                          } catch (error) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString())),
                              );
                            }
                          }
                        },
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _SpaceCard extends ConsumerWidget {
  const _SpaceCard({required this.space});

  final Space space;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          try {
            await ref.read(workspaceActionsProvider).accessSpace(space.id);
            if (context.mounted) context.go('/space/${space.id}/home');
          } catch (error) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.toString())),
              );
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: space.iconColor == null
                    ? null
                    : _parseColor(space.iconColor!),
                child: Icon(switch (space.iconKey) {
                  'office' => Icons.business,
                  'storage' => Icons.inventory_2_outlined,
                  _ => Icons.home_outlined,
                }),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      space.name,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(context.l10n.memberCount(space.memberCount)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

Color _parseColor(String value) {
  final hex = value.replaceFirst('#', '');
  final parsed = int.tryParse('FF$hex', radix: 16);
  return parsed == null ? Colors.blue : Color(parsed);
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(error.toString(), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: Text(context.l10n.retry)),
        ],
      ),
    ),
  );
}
