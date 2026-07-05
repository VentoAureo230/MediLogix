/// Route path constants used by the router and by navigation calls.
///
/// Centralising them here keeps deep-link URLs and `context.go(...)` calls
/// consistent across the app.
class AppRoutes {
  const AppRoutes._();

  static const String login = '/login';
  static const String home = '/home';
}
