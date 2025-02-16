import 'package:go_router/go_router.dart';
import 'package:mobile/pages/home/home.dart';

import 'package:mobile/pages/auth/main_connexion_page.dart';
import 'package:mobile/pages/scanner/scanner.dart';

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
      ),
      GoRoute(
        name: 'scanner',
        path: '/scanner',
        builder: (context, state) {
          return const BarcodeScannerPage();
        }
      )
    ],
  );
}
