import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/data/repository_providers.dart';

class InvitePage extends ConsumerStatefulWidget {
  const InvitePage({required this.code, super.key});

  final String code;

  @override
  ConsumerState<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends ConsumerState<InvitePage> {
  bool _accepting = false;
  String? _error;

  Future<void> _accept() async {
    setState(() {
      _accepting = true;
      _error = null;
    });
    try {
      final spaceId = await ref
          .read(workspaceActionsProvider)
          .acceptInvite(widget.code);
      if (mounted) context.go('/space/$spaceId/home');
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _accepting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.invite)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.group_add_outlined, size: 64),
                const SizedBox(height: 16),
                Text(
                  context.l10n.inviteReceived,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 24),
                if (user == null)
                  FilledButton(
                    onPressed: () => context.go(
                      '/auth?invite=${Uri.encodeQueryComponent(widget.code)}',
                    ),
                    child: Text(context.l10n.signIn),
                  )
                else
                  FilledButton(
                    onPressed: _accepting ? null : _accept,
                    child: _accepting
                        ? const CircularProgressIndicator()
                        : Text(context.l10n.acceptInvite),
                  ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
