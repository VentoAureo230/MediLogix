import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mobile/core/error/failures.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/services/token_storage_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/session.dart';
import '../../domain/repository/authentication_repository.dart';
import '../data_sources/remote/authentication_api_service.dart';
import '../models/login_request_dto.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required AuthenticationApiService apiService,
    required TokenStorageService tokenStorage,
  })  : _api = apiService,
        _tokenStorage = tokenStorage;

  final AuthenticationApiService _api;
  final TokenStorageService _tokenStorage;

  @override
  Future<DataState<Session>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.login(
        LoginRequestDto(email: email, password: password),
      );

      // Backend quirk: on unknown email it returns 201 with `{message: 'User
      // not found'}` — Retrofit will still succeed the call, so we detect the
      // missing token here and reject it.
      if (response.token.isEmpty) {
        return const DataFailed(UnauthorizedFailure(
          message: 'Invalid credentials',
        ));
      }

      final session = _buildSession(response.token);
      await _tokenStorage.saveToken(session.token);
      return DataSuccess(session);
    } on DioException catch (e) {
      return DataFailed(ErrorMapper.toFailure(ErrorMapper.fromDio(e)));
    } on TypeError {
      // Response shape didn't include a token — treat like invalid credentials.
      return const DataFailed(UnauthorizedFailure(
        message: 'Invalid credentials',
      ));
    } catch (e) {
      return DataFailed(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<DataState<void>> logout() async {
    try {
      await _tokenStorage.deleteToken();
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<DataState<Session?>> getCachedSession() async {
    try {
      final token = await _tokenStorage.readToken();
      if (token == null || token.isEmpty) {
        return const DataSuccess(null);
      }
      final session = _buildSession(token);
      if (session.isExpired) {
        await _tokenStorage.deleteToken();
        return const DataSuccess(null);
      }
      return DataSuccess(session);
    } catch (e) {
      return DataFailed(ErrorMapper.toFailure(e));
    }
  }

  /// Parses the JWT payload manually to avoid pulling in `dart_jsonwebtoken`.
  ///
  /// Signature validation is not performed on the client — it lives on the
  /// backend (and the token is treated as opaque otherwise).
  Session _buildSession(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const ServerException(message: 'Malformed JWT');
    }

    final payload = _decodeJwtPart(parts[1]);
    final userIdRaw = payload['userId'];
    if (userIdRaw is! int) {
      throw const ServerException(message: 'JWT missing userId claim');
    }

    DateTime? expiresAt;
    final exp = payload['exp'];
    if (exp is int) {
      expiresAt = DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
    }

    return Session(token: token, userId: userIdRaw, expiresAt: expiresAt);
  }

  Map<String, dynamic> _decodeJwtPart(String part) {
    final normalized = base64Url.normalize(part);
    final decoded = utf8.decode(base64Url.decode(normalized));
    final parsed = json.decode(decoded);
    if (parsed is! Map<String, dynamic>) {
      throw const ServerException(message: 'JWT payload is not an object');
    }
    return parsed;
  }
}
