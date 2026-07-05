import 'package:equatable/equatable.dart';

/// Base class for all domain-level failures returned to the presentation layer.
///
/// Repositories must map [Exception]s from data sources into [Failure]s so
/// BLoCs never have to know about `DioException` or transport concerns.
sealed class Failure extends Equatable {
  const Failure({this.message, this.statusCode});

  final String? message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message, super.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message}) : super(statusCode: 401);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message}) : super(statusCode: 404);
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message, super.statusCode});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message});
}
