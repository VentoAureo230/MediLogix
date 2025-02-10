import 'package:go_router/go_router.dart';
import 'package:mobile/pages/home/home.dart';

import '../pages/auth/main_connexion_page.dart';

GoRouter appRouting() {
  return GoRouter(
    initialLocation: '/',
    observers: [],
    routes: <RouteBase>[
      GoRoute(
        name: 'connexion_page',
        path: '/',
        builder: (context, state) {
          return const MainConnexionPage();
        },
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) {
          return const Home();
        }
      )
    ],
  );
}
