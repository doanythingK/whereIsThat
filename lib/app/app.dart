import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'localization/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_providers.dart';
import '../core/data/repository_providers.dart';
import '../core/services/app_services.dart';

const _currentAppVersion = String.fromEnvironment(
  'APP_VERSION',
  defaultValue: '1.0.0',
);

class WhereIsThatApp extends ConsumerWidget {
  const WhereIsThatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (previous, next) {
      if (next.value != null) {
        unawaited(
          AppServices.current.syncDevice(ref.read(appRepositoryProvider)),
        );
      }
    });
    final minimumVersion = ref.watch(minimumSupportedVersionProvider).value;
    return MaterialApp.router(
      title: '엄마 이거 어딨어?',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(themeModeProvider),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko'), Locale('en')],
      routerConfig: ref.watch(appRouterProvider),
      builder: (context, child) =>
          minimumVersion != null &&
              _compareVersions(_currentAppVersion, minimumVersion) < 0
          ? const _UpdateRequiredPage()
          : child ?? const SizedBox.shrink(),
    );
  }
}

int _compareVersions(String left, String right) {
  final leftParts = left.split('.').map((part) => int.tryParse(part) ?? 0);
  final rightParts = right.split('.').map((part) => int.tryParse(part) ?? 0);
  final leftList = [...leftParts, 0, 0, 0];
  final rightList = [...rightParts, 0, 0, 0];
  for (var index = 0; index < 3; index++) {
    final comparison = leftList[index].compareTo(rightList[index]);
    if (comparison != 0) return comparison;
  }
  return 0;
}

class _UpdateRequiredPage extends StatelessWidget {
  const _UpdateRequiredPage();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.system_update, size: 72),
            const SizedBox(height: 20),
            Text(
              context.l10n.updateRequired,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(context.l10n.updateRequiredBody, textAlign: TextAlign.center),
          ],
        ),
      ),
    ),
  );
}
