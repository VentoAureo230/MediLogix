import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the JWT in the platform keychain / keystore.
///
/// Wraps [FlutterSecureStorage] so the rest of the app never touches the
/// underlying storage directly (easier to mock, easier to swap).
class TokenStorageService {
  TokenStorageService(this._storage);

  static const String _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) {
    return _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> readToken() {
    return _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() {
    return _storage.delete(key: _tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await readToken();
    return token != null && token.isNotEmpty;
  }
}
