part of 'order_list_bloc.dart';

sealed class OrderListEvent extends Equatable {
  const OrderListEvent();

  @override
  List<Object?> get props => const [];
}

/// Fetches the list of orders. If [statusFilter] is null, all orders are
/// returned (backend already orders them by status).
class OrderListRequested extends OrderListEvent {
  const OrderListRequested({this.statusFilter});

  final OrderStatus? statusFilter;

  @override
  List<Object?> get props => [statusFilter];
}

/// Same as [OrderListRequested] but preserves the current list while the
/// refresh is in flight — used by pull-to-refresh.
class OrderListRefreshRequested extends OrderListEvent {
  const OrderListRefreshRequested();
}

class OrderStatusChangeRequested extends OrderListEvent {
  const OrderStatusChangeRequested({
    required this.orderId,
    required this.newStatus,
  });

  final int orderId;
  final OrderStatus newStatus;

  @override
  List<Object?> get props => [orderId, newStatus];
}
