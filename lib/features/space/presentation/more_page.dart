import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/data/app_repository.dart';
import '../../../core/data/repository_providers.dart';
import '../../../core/models/app_models.dart';
import '../../../app/theme/theme_providers.dart';
import '../../auth/application/auth_actions.dart';

class MorePage extends ConsumerWidget {
  const MorePage({required this.spaceId, super.key});

  final String spaceId;

  void _closeSheetAndGo(BuildContext context, String location) {
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    router.go(location);
  }

  void _showError(BuildContext context, Object error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(error.toString())));
  }

  Future<void> _invite(BuildContext context, WidgetRef ref) async {
    late List<SpaceInvite> invites;
    try {
      invites = await ref.read(invitesProvider(spaceId).future);
    } catch (error) {
      if (context.mounted) _showError(context, error);
      return;
    }
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final now = DateTime.now().toUtc();
          return AlertDialog(
            title: Text(context.l10n.invite),
            content: SizedBox(
              width: 420,
              child: invites.isEmpty
                  ? Text(context.l10n.inviteUnavailable)
                  : ListView(
                      shrinkWrap: true,
                      children: [
                        for (final invite in invites)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: SelectableText(invite.code),
                            subtitle: Text(
                              invite.revokedAt != null
                                  ? context.l10n.revoked
                                  : invite.expiresAt.isBefore(now)
                                  ? context.l10n.expired
                                  : context.l10n.expiry(invite.expiresAt),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: context.l10n.copyLink,
                                  icon: const Icon(Icons.copy),
                                  onPressed: invite.revokedAt != null
                                      ? null
                                      : () async {
                                          final link =
                                              'whereisthat:///invite/${invite.code}';
                                          await Clipboard.setData(
                                            ClipboardData(text: link),
                                          );
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      context.l10n.linkCopied,
                                                    ),
                                                  ),
                                                );
                                          }
                                        },
                                ),
                                IconButton(
                                  tooltip: context.l10n.delete,
                                  icon: const Icon(Icons.block_outlined),
                                  onPressed:
                                      invite.revokedAt != null ||
                                          invite.expiresAt.isBefore(now)
                                      ? null
                                      : () async {
                                          try {
                                            await ref
                                                .read(workspaceActionsProvider)
                                                .revokeInvite(invite);
                                            if (context.mounted) {
                                              setDialogState(
                                                () => invites = invites
                                                    .map(
                                                      (entry) =>
                                                          entry.id == invite.id
                                                          ? entry.copyWith(
                                                              revokedAt:
                                                                  DateTime.now()
                                                                      .toUtc(),
                                                            )
                                                          : entry,
                                                    )
                                                    .toList(),
                                              );
                                            }
                                          } catch (error) {
                                            if (context.mounted) {
                                              _showError(context, error);
                                            }
                                          }
                                        },
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.l10n.close),
              ),
              FilledButton.icon(
                onPressed: () async {
                  try {
                    final created = await ref
                        .read(workspaceActionsProvider)
                        .createInvite(spaceId);
                    if (context.mounted) {
                      setDialogState(() => invites = [created, ...invites]);
                    }
                  } catch (error) {
                    if (context.mounted) _showError(context, error);
                  }
                },
                icon: const Icon(Icons.add_link),
                label: Text(context.l10n.add),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(appRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.more)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text(context.l10n.itemList),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/space/$spaceId/items'),
                ),
                ListTile(
                  leading: const Icon(Icons.delete_sweep_outlined),
                  title: Text(context.l10n.trash),
                  subtitle: Text(context.l10n.trashSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showTrash(context, ref),
                ),
                ListTile(
                  leading: const Icon(Icons.people_outline),
                  title: Text(context.l10n.members),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showMembers(context, ref),
                ),
                ListTile(
                  leading: const Icon(Icons.person_add_alt),
                  title: Text(context.l10n.invite),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _invite(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: Text(context.l10n.settings),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showSettings(context, ref),
                ),
                ListTile(
                  leading: const Icon(Icons.campaign_outlined),
                  title: Text(context.l10n.notice),
                  subtitle: Text(context.l10n.noticeSubtitle),
                  onTap: () => _showNotices(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (repository.isDemoMode)
            Padding(
              padding: EdgeInsets.all(12),
              child: Text(context.l10n.demoRepositoryMessage),
            ),
        ],
      ),
    );
  }

  Future<void> _showMembers(BuildContext context, WidgetRef ref) async {
    late List<SpaceMember> members;
    try {
      members = await ref.read(spaceMembersProvider(spaceId).future);
    } catch (error) {
      if (context.mounted) _showError(context, error);
      return;
    }
    final currentUser = ref.read(appRepositoryProvider).signedInUser;
    final currentMember = members
        .where((member) => member.userId == currentUser?.id)
        .firstOrNull;
    final canManage = currentMember?.role == 'admin';
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final member in members)
                ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(member.displayName ?? member.userId),
                  subtitle: Text(member.role),
                  onTap: member.userId == currentUser?.id
                      ? () async {
                          final displayName = await _editDisplayName(
                            context,
                            ref,
                            member,
                          );
                          if (displayName == null || !context.mounted) return;
                          setModalState(() {
                            members = members
                                .map(
                                  (entry) => entry.id == member.id
                                      ? entry.copyWith(displayName: displayName)
                                      : entry,
                                )
                                .toList();
                          });
                        }
                      : null,
                  trailing: canManage && member.userId != currentUser?.id
                      ? PopupMenuButton<String>(
                          onSelected: (role) async {
                            try {
                              await ref
                                  .read(workspaceActionsProvider)
                                  .updateMemberRole(member, role);
                              if (!context.mounted) return;
                              setModalState(() {
                                members = members
                                    .map(
                                      (entry) => entry.id == member.id
                                          ? entry.copyWith(role: role)
                                          : entry,
                                    )
                                    .toList();
                              });
                            } catch (error) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error.toString())),
                                );
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: member.role == 'admin'
                                  ? 'member'
                                  : 'admin',
                              child: Text(
                                member.role == 'admin'
                                    ? context.l10n.demoteMember
                                    : context.l10n.promoteAdmin,
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTrash(BuildContext context, WidgetRef ref) async {
    late List<Object?> results;
    try {
      results = await Future.wait<Object?>([
        ref.read(deletedItemsProvider(spaceId).future),
        ref.read(deletedFloorPlansProvider(spaceId).future),
        ref.read(deletedLocationsProvider(spaceId).future),
      ]);
    } catch (error) {
      if (context.mounted) _showError(context, error);
      return;
    }
    if (!context.mounted) return;
    final items = results[0] as List<Item>;
    final plans = results[1] as List<FloorPlan>;
    final locations = results[2] as List<Location>;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * .75,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Text(
                context.l10n.trash,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (items.isEmpty && plans.isEmpty && locations.isEmpty)
                Text(context.l10n.noRestorableData),
              for (final item in items)
                ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text(item.name),
                  subtitle: Text(
                    context.l10n.trashEntry(
                      context.l10n.itemList,
                      item.deletePurgeAt,
                    ),
                  ),
                  trailing: IconButton(
                    tooltip: context.l10n.restore,
                    icon: const Icon(Icons.restore),
                    onPressed: () async {
                      try {
                        await ref
                            .read(workspaceActionsProvider)
                            .restoreItem(item);
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
              for (final plan in plans)
                ListTile(
                  leading: const Icon(Icons.map_outlined),
                  title: Text(plan.name),
                  subtitle: Text(
                    context.l10n.trashEntry(
                      context.l10n.floorPlan,
                      plan.deletePurgeAt,
                    ),
                  ),
                  trailing: IconButton(
                    tooltip: context.l10n.restore,
                    icon: const Icon(Icons.restore),
                    onPressed: () async {
                      try {
                        await ref
                            .read(workspaceActionsProvider)
                            .restoreFloorPlan(plan);
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
              for (final location in locations)
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(location.name),
                  subtitle: Text(
                    context.l10n.trashEntry(
                      context.l10n.location,
                      location.deletePurgeAt,
                    ),
                  ),
                  trailing: IconButton(
                    tooltip: context.l10n.restore,
                    icon: const Icon(Icons.restore),
                    onPressed: () async {
                      try {
                        await ref
                            .read(workspaceActionsProvider)
                            .restoreLocation(location);
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
      ),
    );
  }

  Future<void> _showNotices(BuildContext context, WidgetRef ref) async {
    late List<AppNotice> notices;
    try {
      notices = await ref.read(noticesProvider.future);
    } catch (error) {
      if (context.mounted) _showError(context, error);
      return;
    }
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: notices.isEmpty
            ? Padding(
                padding: EdgeInsets.all(24),
                child: Text(context.l10n.noNotices),
              )
            : ListView(
                shrinkWrap: true,
                children: [
                  for (final notice in notices)
                    ListTile(
                      leading: Icon(
                        notice.importance == 'critical'
                            ? Icons.priority_high
                            : Icons.campaign_outlined,
                      ),
                      title: Text(notice.title),
                      subtitle: Text(notice.body),
                    ),
                ],
              ),
      ),
    );
  }

  Future<String?> _editDisplayName(
    BuildContext context,
    WidgetRef ref,
    SpaceMember member,
  ) async {
    final controller = TextEditingController(text: member.displayName ?? '');
    final displayName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.displayNameTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 40,
          decoration: InputDecoration(labelText: context.l10n.displayName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
    controller.dispose();
    if (displayName == null || displayName.isEmpty || !context.mounted) {
      return null;
    }
    try {
      await ref
          .read(workspaceActionsProvider)
          .updateMemberDisplayName(member, displayName);
      return displayName;
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
      return null;
    }
  }

  Future<void> _showSettings(BuildContext context, WidgetRef ref) async {
    var themeMode = ref.read(themeModeProvider);
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(
                  context.l10n.theme,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text(context.l10n.systemTheme),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text(context.l10n.lightTheme),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text(context.l10n.darkTheme),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (value) async {
                    final next = value.first;
                    setState(() => themeMode = next);
                    ref.read(themeModeProvider.notifier).setMode(next);
                    try {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('theme_mode', next.name);
                    } catch (error) {
                      if (context.mounted) _showError(context, error);
                    }
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(context.l10n.signOut),
                onTap: () async {
                  try {
                    await ref.read(authActionsProvider).signOut();
                    if (context.mounted) _closeSheetAndGo(context, '/auth');
                  } catch (error) {
                    if (context.mounted) _showError(context, error);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_add_alt_1),
                title: Text(context.l10n.linkIdentity),
                onTap: () => _showIdentityLinks(context, ref),
              ),
              ListTile(
                leading: const Icon(Icons.swap_horiz),
                title: Text(context.l10n.spaces),
                onTap: () => _closeSheetAndGo(context, '/spaces'),
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: Text(context.l10n.leaveSpace),
                onTap: () => _leave(context, ref),
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_forever_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(context.l10n.deleteSpace),
                onTap: () => _deleteSpace(context, ref),
              ),
              ListTile(
                leading: Icon(
                  Icons.person_off_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(context.l10n.deleteAccount),
                onTap: () => _deleteAccount(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _leave(BuildContext context, WidgetRef ref) async {
    final otherSpaces = (ref.read(spacesProvider).value ?? const <Space>[])
        .where((space) => space.id != spaceId)
        .toList();
    var action = 'keep';
    String? targetSpaceId = otherSpaces.firstOrNull?.id;
    final choice = await showDialog<({String action, String? targetSpaceId})>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.l10n.leaveSpaceQuestion),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.l10n.leaveSpaceDescription),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'keep',
                    label: Text(context.l10n.keepData),
                  ),
                  ButtonSegment(
                    value: 'move',
                    label: Text(context.l10n.moveData),
                  ),
                  ButtonSegment(
                    value: 'delete',
                    label: Text(context.l10n.deleteData),
                  ),
                ],
                selected: {action},
                onSelectionChanged: (value) =>
                    setDialogState(() => action = value.first),
              ),
              if (action == 'move' && otherSpaces.isNotEmpty) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: targetSpaceId,
                  decoration: InputDecoration(
                    labelText: context.l10n.targetSpace,
                  ),
                  items: [
                    for (final space in otherSpaces)
                      DropdownMenuItem(
                        value: space.id,
                        child: Text(space.name),
                      ),
                  ],
                  onChanged: (value) =>
                      setDialogState(() => targetSpaceId = value),
                ),
              ],
              if (action == 'move' && otherSpaces.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(context.l10n.noOtherSpace),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: action == 'move' && targetSpaceId == null
                  ? null
                  : () => Navigator.pop(context, (
                      action: action,
                      targetSpaceId: targetSpaceId,
                    )),
              child: Text(context.l10n.leave),
            ),
          ],
        ),
      ),
    );
    if (choice == null) return;
    try {
      await ref
          .read(workspaceActionsProvider)
          .leaveSpaceWithDataAction(
            spaceId,
            personalDataAction: choice.action,
            targetSpaceId: choice.targetSpaceId,
          );
      if (context.mounted) _closeSheetAndGo(context, '/spaces');
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  Future<void> _deleteSpace(BuildContext context, WidgetRef ref) async {
    final spaces = ref.read(spacesProvider).value ?? const <Space>[];
    final space = spaces.where((entry) => entry.id == spaceId).firstOrNull;
    if (space == null) return;
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.deleteSpaceQuestion),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.deleteSpaceDescription),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: space.name),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, controller.text.trim() == space.name),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    controller.dispose();
    if (confirmed != true) return;
    try {
      await ref.read(workspaceActionsProvider).deleteSpace(space);
      if (context.mounted) _closeSheetAndGo(context, '/spaces');
    } catch (error) {
      if (context.mounted) _showError(context, error);
    }
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.deleteAccountQuestion),
        content: Text(context.l10n.deleteAccountDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.requestDeletion),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(authActionsProvider).deleteAccount();
      if (context.mounted) _closeSheetAndGo(context, '/account-recovery');
    } catch (error) {
      if (context.mounted) _showError(context, error);
    }
  }

  Future<void> _showIdentityLinks(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            for (final entry in <(SocialProvider, String)>[
              (SocialProvider.kakao, 'kakao'),
              (SocialProvider.naver, 'naver'),
              (SocialProvider.google, 'google'),
              (SocialProvider.apple, 'apple'),
            ])
              ListTile(
                title: Text(
                  context.l10n.identityLink(
                    context.l10n.providerName(entry.$2),
                  ),
                ),
                onTap: () async {
                  try {
                    await ref.read(authActionsProvider).linkIdentity(entry.$1);
                    if (context.mounted) Navigator.pop(context);
                  } catch (error) {
                    if (context.mounted) _showError(context, error);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
