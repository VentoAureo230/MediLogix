import 'package:get_it/get_it.dart';

import '../../core/network/auth_interceptor.dart';
import '../../core/services/token_storage_service.dart';
import 'data/data_sources/remote/authentication_api_service.dart';
import 'data/repository/authentication_repository_impl.dart';
import 'domain/repository/authentication_repository.dart';
import 'domain/usecases/get_cached_session_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'presentation/bloc/authentication_bloc.dart';

/// Registers every dependency owned by the Authentication feature.
///
/// Invoked from `injection_container.dart` after the shared infrastructure
/// (`Dio`, `TokenStorageService`, `AuthInterceptor`) has been registered.
void registerAuthenticationFeature(GetIt sl) {
  // Data source (Retrofit-generated implementation is wired via factory ctor)
  sl.registerLazySingleton<AuthenticationApiService>(
    () => AuthenticationApiService(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      apiService: sl<AuthenticationApiService>(),
      tokenStorage: sl<TokenStorageService>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(
    () => LoginUseCase(sl<AuthenticationRepository>()),
  );
  sl.registerLazySingleton(
    () => LogoutUseCase(sl<AuthenticationRepository>()),
  );
  sl.registerLazySingleton(
    () => GetCachedSessionUseCase(sl<AuthenticationRepository>()),
  );

  // Bloc — singleton so the router and pages share the same auth state.
  sl.registerLazySingleton<AuthenticationBloc>(
    () => AuthenticationBloc(
      loginUseCase: sl<LoginUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      getCachedSessionUseCase: sl<GetCachedSessionUseCase>(),
      authInterceptor: sl<AuthInterceptor>(),
    ),
  );
}
