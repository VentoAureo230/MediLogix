/// Route path constants used by the router and by navigation calls.
///
/// Centralising them here keeps deep-link URLs and `context.go(...)` calls
/// consistent across the app.
class AppRoutes {
  const AppRoutes._();

  static const String login = '/login';

  /// Default landing route after login. Matches the first tab of the shell.
  static const String home = orders;

  // Home shell branches
  static const String orders = '/orders';
  static const String references = '/references';
  static const String scan = '/scan';
}
