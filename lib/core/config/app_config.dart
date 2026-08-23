class AppConfig {
  const AppConfig({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    this.environment = 'dev',
  });

  const AppConfig.fromEnvironment()
    : supabaseUrl = const String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY'),
      environment = const String.fromEnvironment(
        'APP_ENV',
        defaultValue: 'dev',
      );

  final String supabaseUrl;
  final String supabaseAnonKey;
  final String environment;

  bool get hasSupabase => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  bool get isProduction => environment == 'prod';
}
