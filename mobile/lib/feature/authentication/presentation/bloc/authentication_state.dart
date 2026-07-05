part of 'authentication_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    required this.status,
    this.session,
    this.isSubmitting = false,
    this.errorMessage,
  });

  const AuthenticationState.unknown()
      : this._(status: AuthStatus.unknown);

  const AuthenticationState.unauthenticated({
    bool isSubmitting = false,
    String? errorMessage,
  }) : this._(
          status: AuthStatus.unauthenticated,
          isSubmitting: isSubmitting,
          errorMessage: errorMessage,
        );

  const AuthenticationState.authenticated(Session session)
      : this._(status: AuthStatus.authenticated, session: session);

  final AuthStatus status;
  final Session? session;
  final bool isSubmitting;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, session, isSubmitting, errorMessage];
}
