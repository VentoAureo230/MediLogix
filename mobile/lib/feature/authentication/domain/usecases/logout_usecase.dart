import '../../../../core/usecases/usecase.dart';
import '../repository/authentication_repository.dart';

class LogoutUseCase extends UseCase<void, NoParams> {
  const LogoutUseCase(this._repository);

  final AuthenticationRepository _repository;

  @override
  Future<DataState<void>> call(NoParams params) {
    return _repository.logout();
  }
}
