import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/session.dart';
import '../repository/authentication_repository.dart';

class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class LoginUseCase extends UseCase<Session, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthenticationRepository _repository;

  @override
  Future<DataState<Session>> call(LoginParams params) {
    return _repository.login(email: params.email, password: params.password);
  }
}
