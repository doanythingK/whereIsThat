import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/data/repository_providers.dart';

class MorePage extends ConsumerWidget {
  const MorePage({required this.spaceId, super.key});

  final String spaceId;

  Future<void> _invite(BuildContext context, WidgetRef ref) async {
    final invite = await ref
        .read(appRepositoryProvider)
        .createInvite(spaceId, const Duration(days: 7));
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
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSettings(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(context.l10n.signOut),
              onTap: () async {
                await ref.read(appRepositoryProvider).signOut();
                if (context.mounted) context.go('/auth');
              },
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(context.l10n.spaces),
              onTap: () => context.go('/spaces'),
            ),
          ],
        ),
      ),
    );
  }
}
