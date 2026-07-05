import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';

part 'order_list_event.dart';
part 'order_list_state.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  OrderListBloc({
    required GetOrdersUseCase getOrdersUseCase,
    required UpdateOrderStatusUseCase updateOrderStatusUseCase,
  })  : _getOrders = getOrdersUseCase,
        _updateStatus = updateOrderStatusUseCase,
        super(const OrderListState()) {
    on<OrderListRequested>(_onListRequested);
    on<OrderListRefreshRequested>(_onRefreshRequested);
    on<OrderStatusChangeRequested>(_onStatusChangeRequested);
  }

  final GetOrdersUseCase _getOrders;
  final UpdateOrderStatusUseCase _updateStatus;

  Future<void> _onListRequested(
    OrderListRequested event,
    Emitter<OrderListState> emit,
  ) async {
    emit(state.copyWith(
      status: OrderListStatus.loading,
      filter: event.statusFilter,
      clearFilter: event.statusFilter == null,
      clearErrorMessage: true,
    ));
    await _load(emit, event.statusFilter);
  }

  Future<void> _onRefreshRequested(
    OrderListRefreshRequested event,
    Emitter<OrderListState> emit,
  ) async {
    await _load(emit, state.filter);
  }

  Future<void> _load(
    Emitter<OrderListState> emit,
    OrderStatus? filter,
  ) async {
    final result = await _getOrders(GetOrdersParams(status: filter));
    switch (result) {
      case DataSuccess(:final data):
        emit(state.copyWith(
          status: OrderListStatus.success,
          orders: data,
          clearErrorMessage: true,
        ));
      case DataFailed(:final failure):
        emit(state.copyWith(
          status: OrderListStatus.failure,
          errorMessage: failure.message ?? 'Impossible de charger les commandes',
        ));
    }
  }

  Future<void> _onStatusChangeRequested(
    OrderStatusChangeRequested event,
    Emitter<OrderListState> emit,
  ) async {
    // Optimistic UI: mark the row as updating so the UI shows progress but
    // don't touch the underlying list until the server confirms.
    emit(state.copyWith(updatingIds: {...state.updatingIds, event.orderId}));

    final result = await _updateStatus(UpdateOrderStatusParams(
      orderId: event.orderId,
      status: event.newStatus,
    ));

    final nextUpdating = {...state.updatingIds}..remove(event.orderId);

    switch (result) {
      case DataSuccess(:final data):
        final updatedOrders = state.orders
            .map((o) => o.id == data.id ? data : o)
            .toList(growable: false);
        // Drop the order if the current filter no longer matches its status.
        final filtered = state.filter == null
            ? updatedOrders
            : updatedOrders.where((o) => o.status == state.filter).toList();
        emit(state.copyWith(
          orders: filtered,
          updatingIds: nextUpdating,
          clearErrorMessage: true,
        ));
      case DataFailed(:final failure):
        emit(state.copyWith(
          updatingIds: nextUpdating,
          errorMessage: failure.message ?? 'Mise à jour impossible',
        ));
    }
  }
}
