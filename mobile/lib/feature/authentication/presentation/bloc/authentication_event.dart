part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => const [];
}

/// Emitted once on app start to hydrate the auth state from secure storage.
class AuthCheckRequested extends AuthenticationEvent {
  const AuthCheckRequested();
}

class AuthLoginSubmitted extends AuthenticationEvent {
  const AuthLoginSubmitted({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class AuthLogoutRequested extends AuthenticationEvent {
  const AuthLogoutRequested();
}

/// Fired by the [AuthInterceptor] whenever the API rejects a request with 401.
class AuthUnauthorizedFromApi extends AuthenticationEvent {
  const AuthUnauthorizedFromApi();
}
