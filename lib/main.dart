import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/data/app_repository.dart';
import 'core/data/demo_app_repository.dart';
import 'core/data/repository_providers.dart';
import 'core/data/supabase_app_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = const AppConfig.fromEnvironment();
  final repository = await _createRepository(config);
  runApp(
    ProviderScope(
      overrides: [appRepositoryProvider.overrideWithValue(repository)],
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
