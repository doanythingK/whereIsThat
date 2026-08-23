import 'package:flutter/material.dart';
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

  Future<void> _invite(BuildContext context, WidgetRef ref) async {
    final invite = await ref
        .read(workspaceActionsProvider)
        .createInvite(spaceId);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.invite),
        content: SelectableText(
          '초대 코드\n${invite.code}\n\n만료: ${invite.expiresAt.toLocal()}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.close),
          ),
        ],
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
                  title: const Text('물건 목록'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/space/$spaceId/items'),
                ),
                ListTile(
                  leading: const Icon(Icons.delete_sweep_outlined),
                  title: const Text('휴지통'),
                  subtitle: const Text('30일 이내 삭제한 데이터 복구'),
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
                  title: const Text('공지'),
                  subtitle: const Text('새로운 소식을 확인하세요.'),
                  onTap: () => _showNotices(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (repository.isDemoMode)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '현재 데모 저장소를 사용 중입니다. Supabase URL과 anon key를 주입하면 dev/prod 서버로 전환됩니다.',
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showMembers(BuildContext context, WidgetRef ref) async {
    final members = await ref.read(spaceMembersProvider(spaceId).future);
    final currentUser = ref.read(currentUserProvider).value;
    final currentMember = members
        .where((member) => member.userId == currentUser?.id)
        .firstOrNull;
    final canManage = currentMember?.role == 'admin';
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final member in members)
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(member.displayName ?? member.userId),
                subtitle: Text(member.role),
                onTap: member.userId == currentUser?.id
                    ? () => _editDisplayName(context, ref, member)
                    : null,
                trailing: canManage && member.userId != currentUser?.id
                    ? PopupMenuButton<String>(
                        onSelected: (role) async {
                          await ref
                              .read(workspaceActionsProvider)
                              .updateMemberRole(member, role);
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: member.role == 'admin' ? 'member' : 'admin',
                            child: Text(
                              member.role == 'admin' ? '일반 멤버로 변경' : '관리자로 승격',
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTrash(BuildContext context, WidgetRef ref) async {
    final results = await Future.wait([
      ref.read(deletedItemsProvider(spaceId).future),
      ref.read(deletedFloorPlansProvider(spaceId).future),
      ref.read(deletedLocationsProvider(spaceId).future),
    ]);
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
              Text('휴지통', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              if (items.isEmpty && plans.isEmpty && locations.isEmpty)
                const Text('복구할 데이터가 없습니다.'),
              for (final item in items)
                ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text(item.name),
                  subtitle: Text('물건 · ${_purgeLabel(item.deletePurgeAt)}'),
                  trailing: IconButton(
                    tooltip: context.l10n.restore,
                    icon: const Icon(Icons.restore),
                    onPressed: () =>
                        ref.read(workspaceActionsProvider).restoreItem(item),
                  ),
                ),
              for (final plan in plans)
                ListTile(
                  leading: const Icon(Icons.map_outlined),
                  title: Text(plan.name),
                  subtitle: Text('평면도 · ${_purgeLabel(plan.deletePurgeAt)}'),
                  trailing: IconButton(
                    tooltip: context.l10n.restore,
                    icon: const Icon(Icons.restore),
                    onPressed: () => ref
                        .read(workspaceActionsProvider)
                        .restoreFloorPlan(plan),
                  ),
                ),
              for (final location in locations)
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(location.name),
                  subtitle: Text('위치 · ${_purgeLabel(location.deletePurgeAt)}'),
                  trailing: IconButton(
                    tooltip: context.l10n.restore,
                    icon: const Icon(Icons.restore),
                    onPressed: () => ref
                        .read(workspaceActionsProvider)
                        .restoreLocation(location),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _purgeLabel(DateTime? date) =>
      date == null ? '30일 보관' : '영구 삭제 예정 ${date.toLocal()}';

  Future<void> _showNotices(BuildContext context, WidgetRef ref) async {
    final notices = await ref.read(noticesProvider.future);
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: notices.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Text('새로운 공지가 없습니다.'),
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

  Future<void> _editDisplayName(
    BuildContext context,
    WidgetRef ref,
    SpaceMember member,
  ) async {
    final controller = TextEditingController(text: member.displayName ?? '');
    final displayName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('공간별 표시 이름'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 40,
          decoration: const InputDecoration(labelText: '표시 이름'),
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
    if (displayName == null || displayName.isEmpty) return;
    await ref
        .read(workspaceActionsProvider)
        .updateMemberDisplayName(member, displayName);
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
                  '테마',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(value: ThemeMode.system, label: Text('시스템')),
                    ButtonSegment(value: ThemeMode.light, label: Text('라이트')),
                    ButtonSegment(value: ThemeMode.dark, label: Text('다크')),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (value) async {
                    final next = value.first;
                    setState(() => themeMode = next);
                    ref.read(themeModeProvider.notifier).setMode(next);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('theme_mode', next.name);
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(context.l10n.signOut),
                onTap: () async {
                  await ref.read(authActionsProvider).signOut();
                  if (context.mounted) context.go('/auth');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_add_alt_1),
                title: const Text('로그인 수단 연결'),
                onTap: () => _showIdentityLinks(context, ref),
              ),
              ListTile(
                leading: const Icon(Icons.swap_horiz),
                title: Text(context.l10n.spaces),
                onTap: () => context.go('/spaces'),
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('이 공간에서 탈퇴'),
                onTap: () => _leave(context, ref),
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_forever_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: const Text('공간 삭제'),
                onTap: () => _deleteSpace(context, ref),
              ),
              ListTile(
                leading: Icon(
                  Icons.person_off_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: const Text('회원 탈퇴'),
                onTap: () => _deleteAccount(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _leave(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('공간에서 탈퇴할까요?'),
        content: const Text('공용 데이터는 공간에 남습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('탈퇴'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(workspaceActionsProvider).leaveSpace(spaceId);
      if (context.mounted) context.go('/spaces');
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
        title: const Text('공간을 삭제할까요?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('삭제 후 30일 동안 복구할 수 있습니다. 확인하려면 공간 이름을 입력하세요.'),
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
    await ref.read(workspaceActionsProvider).deleteSpace(space);
    if (context.mounted) context.go('/spaces');
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('회원 탈퇴'),
        content: const Text('30일 유예 기간 동안 복구할 수 있습니다. 계속할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('탈퇴 신청'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(authActionsProvider).deleteAccount();
    if (context.mounted) context.go('/auth');
  }

  Future<void> _showIdentityLinks(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            for (final entry in <(SocialProvider, String)>[
              (SocialProvider.kakao, '카카오'),
              (SocialProvider.naver, '네이버'),
              (SocialProvider.google, 'Google'),
              (SocialProvider.apple, 'Apple'),
            ])
              ListTile(
                title: Text('${entry.$2} 계정 연결'),
                onTap: () async {
                  await ref.read(authActionsProvider).linkIdentity(entry.$1);
                  if (context.mounted) Navigator.pop(context);
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
