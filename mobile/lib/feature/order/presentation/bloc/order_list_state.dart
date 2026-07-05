part of 'order_list_bloc.dart';

enum OrderListStatus { initial, loading, success, failure }

class OrderListState extends Equatable {
  const OrderListState({
    this.status = OrderListStatus.initial,
    this.orders = const [],
    this.filter,
    this.errorMessage,
    this.updatingIds = const {},
  });

  final OrderListStatus status;
  final List<Order> orders;
  final OrderStatus? filter;
  final String? errorMessage;

  /// Order ids currently being PATCHed (used to disable row-level buttons and
  /// show a spinner without blocking the rest of the list).
  final Set<int> updatingIds;

  OrderListState copyWith({
    OrderListStatus? status,
    List<Order>? orders,
    OrderStatus? filter,
    bool clearFilter = false,
    String? errorMessage,
    bool clearErrorMessage = false,
    Set<int>? updatingIds,
  }) {
    return OrderListState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      filter: clearFilter ? null : (filter ?? this.filter),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      updatingIds: updatingIds ?? this.updatingIds,
    );
  }

  @override
  List<Object?> get props => [status, orders, filter, errorMessage, updatingIds];
}
