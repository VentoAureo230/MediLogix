import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feature/authentication/presentation/bloc/authentication_bloc.dart';
import '../../feature/authentication/presentation/pages/login_page.dart';
import '../../feature/home/presentation/pages/home_shell_page.dart';
import '../../feature/order/presentation/pages/order_list_page.dart';
import '../../feature/reference/presentation/pages/reference_list_page.dart';
import '../../feature/scanner/presentation/pages/scanner_page.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _ordersNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'orders');
final _referencesNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'references');
final _scannerNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'scanner');

/// Builds the app-wide `GoRouter`.
///
/// * Redirects unauthenticated users to `/login` and authenticated users
///   away from it via [AuthenticationBloc].
/// * The authenticated area is a `StatefulShellRoute.indexedStack` with three
///   independent navigation stacks — one per bottom-nav tab — so switching
///   tabs preserves scroll position and any pushed sub-pages.
GoRouter buildAppRouter(AuthenticationBloc authenticationBloc) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login,
    refreshListenable: GoRouterRefreshStream(authenticationBloc.stream),
    redirect: (context, state) {
      final status = authenticationBloc.state.status;
      final loggingIn = state.matchedLocation == AppRoutes.login;

      // Wait for the initial session check to resolve before redirecting.
      if (status == AuthStatus.unknown) return null;

      if (status == AuthStatus.unauthenticated && !loggingIn) {
        return AppRoutes.login;
      }
      if (status == AuthStatus.authenticated && loggingIn) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            HomeShellPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _ordersNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.orders,
                name: 'orders',
                builder: (context, state) => const OrderListPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _referencesNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.references,
                name: 'references',
                builder: (context, state) => const ReferenceListPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _scannerNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.scan,
                name: 'scan',
                builder: (context, state) => const ScannerPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
