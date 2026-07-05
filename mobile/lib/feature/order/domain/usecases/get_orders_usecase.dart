import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../entities/order_status.dart';
import '../repository/order_repository.dart';

class GetOrdersParams extends Equatable {
  const GetOrdersParams({this.status});

  final OrderStatus? status;

  @override
  List<Object?> get props => [status];
}

class GetOrdersUseCase extends UseCase<List<Order>, GetOrdersParams> {
  const GetOrdersUseCase(this._repository);

  final OrderRepository _repository;

  @override
  Future<DataState<List<Order>>> call(GetOrdersParams params) {
    return _repository.listOrders(status: params.status);
  }
}
