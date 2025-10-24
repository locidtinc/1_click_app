class EnvironmentConfig {
  // ignore: constant_identifier_names
  static const APP_NAME =
      String.fromEnvironment('DART_DEFINES_APP_NAME', defaultValue: 'MyKios');
  // ignore: constant_identifier_names
  static const APP_SUFFIX = String.fromEnvironment('DART_DEFINES_APP_SUFFIX');
  // ignore: constant_identifier_names
  static const BASE_URL = String.fromEnvironment(
    'DART_DEFINES_BASE_URL',
    defaultValue: 'https://api.onkiot.com',
  );
}
