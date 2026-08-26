import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/data/repository_providers.dart';
import '../application/auth_actions.dart';

class AccountRecoveryPage extends ConsumerStatefulWidget {
  const AccountRecoveryPage({super.key});

  @override
  ConsumerState<AccountRecoveryPage> createState() =>
      _AccountRecoveryPageState();
}

class _AccountRecoveryPageState extends ConsumerState<AccountRecoveryPage> {
  bool _loading = false;
  String? _error;

  Future<void> _restore() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(authActionsProvider).restoreAccount();
      if (mounted) context.go('/spaces');
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signOut() async {
    setState(() => _error = null);
    try {
      await ref.read(authActionsProvider).signOut();
      if (mounted) context.go('/auth');
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final pending = ref.watch(accountDeletionPendingProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: pending.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('${strings.errorTitle}: $error'),
                data: (isPending) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.restore, size: 72),
                    const SizedBox(height: 20),
                    Text(
                      isPending
                          ? strings.accountDeletionScheduled
                          : strings.appTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isPending
                          ? strings.accountRecoveryBody
                          : strings.appTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    FilledButton.icon(
                      onPressed: _loading ? null : _restore,
                      icon: const Icon(Icons.restore),
                      label: Text(strings.restoreAccount),
                    ),
                    TextButton(
                      onPressed: _loading ? null : _signOut,
                      child: Text(strings.continueAfterSignOut),
                    ),
                    if (_loading)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: LinearProgressIndicator(),
                      ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
