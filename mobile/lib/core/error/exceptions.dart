/// Internal exceptions thrown by data sources.
///
/// They are caught inside repositories and translated into `Failure`s.
/// Presentation code never sees these.
class ServerException implements Exception {
  const ServerException({this.message, this.statusCode});

  final String? message;
  final int? statusCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class NetworkException implements Exception {
  const NetworkException({this.message});

  final String? message;

  @override
  String toString() => 'NetworkException: $message';
}

class UnauthorizedException implements Exception {
  const UnauthorizedException({this.message});

  final String? message;

  @override
  String toString() => 'UnauthorizedException: $message';
}

class NotFoundException implements Exception {
  const NotFoundException({this.message});

  final String? message;

  @override
  String toString() => 'NotFoundException: $message';
}

class ValidationException implements Exception {
  const ValidationException({this.message, this.statusCode});

  final String? message;
  final int? statusCode;

  @override
  String toString() => 'ValidationException($statusCode): $message';
}

class CacheException implements Exception {
  const CacheException({this.message});

  final String? message;

  @override
  String toString() => 'CacheException: $message';
}
