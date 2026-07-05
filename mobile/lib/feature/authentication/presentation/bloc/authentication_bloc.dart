import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/network/auth_interceptor.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/session.dart';
import '../../domain/usecases/get_cached_session_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

/// Owns the app-wide authentication state.
///
/// Registered as a singleton in `injection_container.dart` so the router,
/// interceptors and login page all read/write the same instance.
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCachedSessionUseCase getCachedSessionUseCase,
    required AuthInterceptor authInterceptor,
  })  : _login = loginUseCase,
        _logout = logoutUseCase,
        _getCachedSession = getCachedSessionUseCase,
        super(const AuthenticationState.unknown()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginSubmitted>(_onLoginSubmitted);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthUnauthorizedFromApi>(_onUnauthorizedFromApi);

    // Any 401 coming out of the API drops us back to unauthenticated.
    _unauthorizedSub = authInterceptor.onUnauthorized.listen(
      (_) => add(const AuthUnauthorizedFromApi()),
    );
  }

  final LoginUseCase _login;
  final LogoutUseCase _logout;
  final GetCachedSessionUseCase _getCachedSession;

  late final StreamSubscription<void> _unauthorizedSub;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    final result = await _getCachedSession(const NoParams());
    switch (result) {
      case DataSuccess(:final data):
        if (data != null) {
          emit(AuthenticationState.authenticated(data));
        } else {
          emit(const AuthenticationState.unauthenticated());
        }
      case DataFailed():
        emit(const AuthenticationState.unauthenticated());
    }
  }

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.unauthenticated(isSubmitting: true));
    final result = await _login(
      LoginParams(email: event.email, password: event.password),
    );
    switch (result) {
      case DataSuccess(:final data):
        emit(AuthenticationState.authenticated(data));
      case DataFailed(:final failure):
        emit(AuthenticationState.unauthenticated(
          errorMessage: failure.message ?? 'Login failed',
        ));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _logout(const NoParams());
    emit(const AuthenticationState.unauthenticated());
  }

  void _onUnauthorizedFromApi(
    AuthUnauthorizedFromApi event,
    Emitter<AuthenticationState> emit,
  ) {
    if (state.status == AuthStatus.authenticated) {
      emit(const AuthenticationState.unauthenticated(
        errorMessage: 'Session expired, please log in again.',
      ));
    }
  }

  @override
  Future<void> close() {
    _unauthorizedSub.cancel();
    return super.close();
  }
}
