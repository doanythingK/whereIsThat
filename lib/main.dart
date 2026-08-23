import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/data/app_repository.dart';
import 'core/data/demo_app_repository.dart';
import 'core/data/repository_providers.dart';
import 'core/data/supabase_app_repository.dart';
import 'core/services/app_services.dart';
import 'app/theme/theme_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = const AppConfig.fromEnvironment();
  await AppServices.initialize(config);
  final repository = await _createRepository(config);
  final preferences = await SharedPreferences.getInstance();
  final themeMode = switch (preferences.getString('theme_mode')) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
  runApp(
    ProviderScope(
      overrides: [
        appRepositoryProvider.overrideWithValue(repository),
        themeModeProvider.overrideWith(() => ThemeModeController(themeMode)),
      ],
      child: const WhereIsThatApp(),
    ),
  );
}

Future<AppRepository> _createRepository(AppConfig config) async {
  if (!config.hasSupabase) return DemoAppRepository();
  await Supabase.initialize(
    url: config.supabaseUrl,
    publishableKey: config.supabaseAnonKey,
    debug: !config.isProduction,
  );
  return SupabaseAppRepository(Supabase.instance.client);
}
