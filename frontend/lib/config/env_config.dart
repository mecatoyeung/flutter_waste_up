class EnvConfig {
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'local',
  );

  static const bool debugShowCheckedModeBanner = bool.fromEnvironment(
    'DebugShowCheckedModeBanner',
    defaultValue: true,
  );

  static const String pwaInstallationTitle = String.fromEnvironment(
    'PwaInstallationTitle',
    defaultValue: 'Waste Up',
  );

  static const String pwaInstallationDescription = String.fromEnvironment(
    'PwaInstallationDescription',
    defaultValue: 'Find meaningful work that supports your community.',
  );

  static bool get isProduction => environment == 'production';
  static bool get isStaging => environment == 'staging';
  static bool get isLocal => environment == 'local';
}