import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../feature/authentication/presentation/bloc/authentication_bloc.dart';
import '../../feature/authentication/presentation/pages/login_page.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

/// Builds the app-wide `GoRouter`.
///
/// The router reacts to [AuthenticationBloc] state changes to redirect
/// unauthenticated users to `/login` and authenticated users away from it.
/// The home shell (bottom-nav, feature branches) is wired in Phase 3.
GoRouter buildAppRouter(AuthenticationBloc authenticationBloc) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: GoRouterRefreshStream(authenticationBloc.stream),
    redirect: (context, state) {
      final status = authenticationBloc.state.status;
      final loggingIn = state.matchedLocation == AppRoutes.login;

      // While the initial session check hasn't resolved, keep the user where
      // they are (the splash screen is still visible).
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
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const _HomePlaceholderPage(),
      ),
    ],
  );
}

class _HomePlaceholderPage extends StatelessWidget {
  const _HomePlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediLogix'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: () => context
                .read<AuthenticationBloc>()
                .add(const AuthLogoutRequested()),
          ),
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Authenticated. Home shell + tabs arrive in Phase 3.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
