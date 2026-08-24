import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/localization/app_localizations.dart';
import '../../../core/data/app_repository.dart';
import '../../../core/data/repository_providers.dart';
import '../application/auth_actions.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  SocialProvider? _loading;
  String? _error;

  Future<void> _signIn(SocialProvider provider) async {
    setState(() {
      _loading = provider;
      _error = null;
    });
    try {
      await ref.read(authActionsProvider).signIn(provider);
      if (mounted && ref.read(appRepositoryProvider).isDemoMode) {
        final invite = GoRouterState.of(context).uri.queryParameters['invite'];
        context.go(
          invite == null ? '/spaces' : '/invite/${Uri.encodeComponent(invite)}',
        );
      }
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _loading = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final repository = ref.watch(appRepositoryProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.location_searching, size: 72),
                  const SizedBox(height: 20),
                  Text(
                    strings.appTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    strings.loginTagline,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  for (final entry in <(SocialProvider, String, IconData)>[
                    (SocialProvider.kakao, 'kakao', Icons.chat_bubble),
                    (SocialProvider.naver, 'naver', Icons.language),
                    (SocialProvider.google, 'google', Icons.g_mobiledata),
                    (SocialProvider.apple, 'apple', Icons.apple),
                  ]) ...[
                    FilledButton.tonalIcon(
                      onPressed: _loading == null
                          ? () => _signIn(entry.$1)
                          : null,
                      icon: Icon(entry.$3),
                      label: Text(
                        strings.socialLogin(strings.providerName(entry.$2)),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (repository.isDemoMode)
                    TextButton.icon(
                      onPressed: () => context.go('/spaces'),
                      icon: const Icon(Icons.preview_outlined),
                      label: Text(strings.demoMode),
                    ),
                  if (_loading != null)
                    const Center(child: CircularProgressIndicator()),
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
    );
  }
}
