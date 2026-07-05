import 'dart:async';

import 'package:flutter/foundation.dart';

/// Adapts any `Stream` (typically a Bloc's state stream) into a
/// `Listenable` that `GoRouter.refreshListenable` understands.
///
/// The router will re-evaluate its `redirect` callback each time the stream
/// emits, so auth state changes trigger navigation automatically.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (_) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
