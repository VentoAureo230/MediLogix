import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../entities/order_status.dart';
import '../repository/order_repository.dart';

class UpdateOrderStatusParams extends Equatable {
  const UpdateOrderStatusParams({
    required this.orderId,
    required this.status,
  });

  final int orderId;
  final OrderStatus status;

  @override
  List<Object?> get props => [orderId, status];
}

class UpdateOrderStatusUseCase
    extends UseCase<Order, UpdateOrderStatusParams> {
  const UpdateOrderStatusUseCase(this._repository);

  final OrderRepository _repository;

  @override
  Future<DataState<Order>> call(UpdateOrderStatusParams params) {
    return _repository.updateStatus(
      orderId: params.orderId,
      status: params.status,
    );
  }
}
