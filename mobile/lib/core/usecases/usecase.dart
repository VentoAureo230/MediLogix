import 'package:equatable/equatable.dart';

import '../error/failures.dart';

/// Contract every use case must implement.
///
/// * [T]      — the success value returned by the use case
/// * [Params] — the input arguments (use [NoParams] when there aren't any)
///
/// Returning a [DataState] avoids exceptions crossing the domain boundary and
/// forces callers (BLoCs) to handle both success and failure paths explicitly.
abstract class UseCase<T, Params> {
  const UseCase();

  Future<DataState<T>> call(Params params);
}

/// Placeholder for use cases that take no input.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => const [];
}

/// Sealed result type used across the domain layer.
///
/// Kept as a hand-rolled sum type (rather than pulling in `dartz`) to keep
/// the dependency surface small and the pattern easy to read.
sealed class DataState<T> {
  const DataState();
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(this.data);
  final T data;
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(this.failure);
  final Failure failure;
}
