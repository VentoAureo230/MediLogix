import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Lightweight logging interceptor.
///
/// Kept intentionally minimal: only fires in debug builds and never prints
/// request/response bodies (they may contain the JWT or user data).
class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[HTTP] → ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '[HTTP] ← ${response.statusCode} ${response.requestOptions.uri}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final status = err.response?.statusCode?.toString() ?? 'no-response';
      debugPrint(
        '[HTTP] ✗ $status ${err.requestOptions.uri} (${err.type.name})',
      );
      if (err.response == null) {
        // No HTTP response at all → transport / OS-level failure.
        // Surface the underlying cause so we can tell apart ATS blocks,
        // Local-Network permission denial, DNS, unreachable host, …
        debugPrint('[HTTP]   message: ${err.message}');
        if (err.error != null) {
          debugPrint('[HTTP]   error  : ${err.error} (${err.error.runtimeType})');
        }
      }
    }
    handler.next(err);
  }
}
