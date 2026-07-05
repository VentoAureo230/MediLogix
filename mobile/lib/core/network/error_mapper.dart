import 'package:dio/dio.dart';

import '../error/exceptions.dart';
import '../error/failures.dart';

/// Helpers used by repositories to translate transport-level errors into
/// domain-level `Failure`s (or the internal `Exception`s that precede them
/// in data sources).
class ErrorMapper {
  const ErrorMapper._();

  /// Turns a raw [DioException] into one of our data-source-level exceptions.
  ///
  /// Call this inside a data source's `catch (e)` block so the repository
  /// only ever deals with our exception hierarchy.
  static Exception fromDio(DioException error) {
    final status = error.response?.statusCode;
    final message = _extractMessage(error);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(message: message ?? 'Network unreachable');
      case DioExceptionType.badResponse:
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
      default:
        break;
    }

    if (status == 401) return UnauthorizedException(message: message);
    if (status == 404) return NotFoundException(message: message);
    if (status != null && status >= 400 && status < 500) {
      return ValidationException(message: message, statusCode: status);
    }
    return ServerException(message: message, statusCode: status);
  }

  /// Turns a data-source exception into the matching domain `Failure`.
  ///
  /// Used inside repository `catch` blocks.
  static Failure toFailure(Object error) {
    if (error is UnauthorizedException) {
      return UnauthorizedFailure(message: error.message);
    }
    if (error is NotFoundException) {
      return NotFoundFailure(message: error.message);
    }
    if (error is ValidationException) {
      return ValidationFailure(
        message: error.message,
        statusCode: error.statusCode,
      );
    }
    if (error is NetworkException) {
      return NetworkFailure(message: error.message);
    }
    if (error is ServerException) {
      return ServerFailure(message: error.message, statusCode: error.statusCode);
    }
    return UnknownFailure(message: error.toString());
  }

  static String? _extractMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final raw = data['message'] ?? data['error'];
      if (raw is String) return raw;
      if (raw is List && raw.isNotEmpty) return raw.join(', ');
    }
    return error.message;
  }
}
