class EnvConfig {
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'local',
  );

  static const bool debugShowCheckedModeBanner = bool.fromEnvironment(
    'DebugShowCheckedModeBanner',
    defaultValue: true,
  );

  static bool get isProduction => environment == 'production';
  static bool get isStaging => environment == 'staging';
  static bool get isLocal => environment == 'local';
}