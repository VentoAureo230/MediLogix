import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../entities/order_status.dart';

abstract class OrderRepository {
  /// Fetches all orders, optionally filtered to a single [status]. The API
  /// returns them pre-sorted by (status, createdAt desc).
  Future<DataState<List<Order>>> listOrders({OrderStatus? status});

  /// Updates the [status] of an existing order.
  Future<DataState<Order>> updateStatus({
    required int orderId,
    required OrderStatus status,
  });
}
