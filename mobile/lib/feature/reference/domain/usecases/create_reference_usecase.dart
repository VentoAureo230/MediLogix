import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/reference.dart';
import '../repository/reference_repository.dart';

class CreateReferenceParams extends Equatable {
  const CreateReferenceParams({
    required this.cip13,
    this.startingQuantity = 0,
  });

  final String cip13;
  final int startingQuantity;

  @override
  List<Object?> get props => [cip13, startingQuantity];
}

class CreateReferenceUseCase
    extends UseCase<Reference, CreateReferenceParams> {
  const CreateReferenceUseCase(this._repository);

  final ReferenceRepository _repository;

  @override
  Future<DataState<Reference>> call(CreateReferenceParams params) {
    return _repository.create(
      cip13: params.cip13,
      startingQuantity: params.startingQuantity,
    );
  }
}
