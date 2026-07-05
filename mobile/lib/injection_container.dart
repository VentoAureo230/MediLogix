import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'core/network/auth_interceptor.dart';
import 'core/network/dio_client.dart';
import 'core/services/token_storage_service.dart';
import 'feature/authentication/authentication_dependencies.dart';

/// Global service locator.
///
/// Kept minimal: only holds infrastructure (Dio, storage, interceptors).
/// Each feature registers its own contributions via a
/// `registerXxxFeature(sl)` function invoked below, keeping this file
/// stable as features are added.
final GetIt sl = GetIt.instance;

/// Wires up every dependency of the app. Must be called from `main` before
/// `runApp` and after `dotenv.load` (Dio's base URL comes from `.env`).
Future<void> initDependencies() async {
  // --- Infrastructure -------------------------------------------------------

  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<TokenStorageService>(
    () => TokenStorageService(sl<FlutterSecureStorage>()),
  );

  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(sl<TokenStorageService>()),
  );

  sl.registerLazySingleton<Dio>(
    () => DioClient.create(sl<AuthInterceptor>()),
  );

  // --- Features -------------------------------------------------------------
  registerAuthenticationFeature(sl);
  //   registerOrderFeature(sl);
  //   registerReferenceFeature(sl);
  //   registerScannerFeature(sl);
}
