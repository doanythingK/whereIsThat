class AppConfig {
  const AppConfig({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    this.environment = 'dev',
    this.firebaseEnabled = false,
    this.adsEnabled = false,
  });

  const AppConfig.fromEnvironment()
    : supabaseUrl = const String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY'),
      environment = const String.fromEnvironment(
        'APP_ENV',
        defaultValue: 'dev',
      ),
      firebaseEnabled = const bool.fromEnvironment('FIREBASE_ENABLED'),
      adsEnabled = const bool.fromEnvironment('ADS_ENABLED');

  final String supabaseUrl;
  final String supabaseAnonKey;
  final String environment;
  final bool firebaseEnabled;
  final bool adsEnabled;

  bool get hasSupabase => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  bool get isProduction => environment == 'prod';
}
