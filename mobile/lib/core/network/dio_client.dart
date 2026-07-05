import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'auth_interceptor.dart';
import 'logging_interceptor.dart';

/// Builds the app-wide [Dio] instance.
///
/// The base URL is resolved at runtime from the loaded `.env` and depends on
/// the platform (Android emulators reach the host via `10.0.2.2`, iOS
/// simulators via `localhost`).
class DioClient {
  const DioClient._();

  static Dio create(AuthInterceptor authInterceptor) {
    final baseUrl = _resolveBaseUrl();

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      authInterceptor,
      const LoggingInterceptor(),
    ]);

    return dio;
  }

  static String _resolveBaseUrl() {
    final key = Platform.isIOS ? 'API_URL_IOS' : 'API_URL_ANDROID';
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError(
        'Missing $key in .env — cannot resolve backend base URL.',
      );
    }
    return value;
  }
}
