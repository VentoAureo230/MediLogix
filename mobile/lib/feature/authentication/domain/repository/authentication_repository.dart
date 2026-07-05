import '../../../../core/usecases/usecase.dart';
import '../entities/session.dart';

/// Contract the authentication use cases depend on.
///
/// The concrete implementation lives in the data layer and is injected via
/// `get_it`, so the domain never imports Dio/Retrofit.
abstract class AuthenticationRepository {
  /// Attempts to log the user in and, on success, persists the resulting
  /// [Session] locally so subsequent cold starts stay authenticated.
  Future<DataState<Session>> login({
    required String email,
    required String password,
  });

  /// Clears any cached session (token in secure storage, cached user, etc.).
  Future<DataState<void>> logout();

  /// Returns the currently cached session, or `null` when the user is
  /// unauthenticated / the token has expired.
  Future<DataState<Session?>> getCachedSession();
}
