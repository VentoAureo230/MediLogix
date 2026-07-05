import 'package:equatable/equatable.dart';

/// Represents an authenticated user session.
///
/// Only what we can safely derive from the JWT is exposed. Role is not
/// present in the token (see `api/src/services/jwt.service.ts`) so it stays
/// null until a dedicated `/me` endpoint is added.
class Session extends Equatable {
  const Session({
    required this.token,
    required this.userId,
    this.expiresAt,
  });

  final String token;
  final int userId;
  final DateTime? expiresAt;

  bool get isExpired {
    final exp = expiresAt;
    if (exp == null) return false;
    return DateTime.now().isAfter(exp);
  }

  @override
  List<Object?> get props => [token, userId, expiresAt];
}
