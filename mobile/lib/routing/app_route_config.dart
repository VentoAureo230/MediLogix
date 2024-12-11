import 'package:go_router/go_router.dart';

import '../pages/main_connexion_page.dart';

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
    ],
  );
}
