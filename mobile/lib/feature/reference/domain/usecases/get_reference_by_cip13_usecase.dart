import '../../../../core/usecases/usecase.dart';
import '../entities/reference.dart';
import '../repository/reference_repository.dart';

/// Params: the raw CIP13 string (13 digits).
class GetReferenceByCip13UseCase extends UseCase<Reference?, String> {
  const GetReferenceByCip13UseCase(this._repository);

  final ReferenceRepository _repository;

  @override
  Future<DataState<Reference?>> call(String cip13) {
    return _repository.getByCip13(cip13);
  }
}
