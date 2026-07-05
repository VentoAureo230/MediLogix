import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/reference.dart';
import '../repository/reference_repository.dart';

class AddToStockParams extends Equatable {
  const AddToStockParams({
    required this.cip13,
    required this.additionalQuantity,
  });

  final String cip13;

  /// Delta to add to the current stock — the backend increments, it does not
  /// replace. Must be > 0 (server-side validation enforces `Min(1)`).
  final int additionalQuantity;

  @override
  List<Object?> get props => [cip13, additionalQuantity];
}

class AddToStockUseCase extends UseCase<Reference, AddToStockParams> {
  const AddToStockUseCase(this._repository);

  final ReferenceRepository _repository;

  @override
  Future<DataState<Reference>> call(AddToStockParams params) {
    return _repository.addToStock(
      cip13: params.cip13,
      additionalQuantity: params.additionalQuantity,
    );
  }
}
