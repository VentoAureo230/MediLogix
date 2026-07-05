import '../../../../core/usecases/usecase.dart';
import '../entities/session.dart';
import '../repository/authentication_repository.dart';

class GetCachedSessionUseCase extends UseCase<Session?, NoParams> {
  const GetCachedSessionUseCase(this._repository);

  final AuthenticationRepository _repository;

  @override
  Future<DataState<Session?>> call(NoParams params) {
    return _repository.getCachedSession();
  }
}
