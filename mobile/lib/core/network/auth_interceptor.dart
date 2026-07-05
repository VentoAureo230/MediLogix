import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../services/token_storage_service.dart';

/// Injects the JWT `Authorization` header on outgoing requests and turns
/// server-side `401`s into a broadcast event so the app can react
/// (typically by logging out).
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStorage);

  final TokenStorageService _tokenStorage;

  /// Fired whenever the server rejects a request with 401.
  ///
  /// Something like the `AuthenticationBloc` can listen and trigger a logout.
  final StreamController<void> _unauthorizedController =
      StreamController<void>.broadcast();

  Stream<void> get onUnauthorized => _unauthorizedController.stream;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      if (kDebugMode) {
        debugPrint('[AuthInterceptor] 401 received, broadcasting logout');
      }
      _unauthorizedController.add(null);
    }
    handler.next(err);
  }

  Future<void> dispose() async {
    await _unauthorizedController.close();
  }
}
