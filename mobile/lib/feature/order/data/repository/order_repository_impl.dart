import 'package:dio/dio.dart';

import '../../../../core/network/error_mapper.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/repository/order_repository.dart';
import '../data_sources/remote/order_api_service.dart';
import '../models/order_dto.dart';
import '../models/update_order_status_dto.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this._api);

  final OrderApiService _api;

  /// Cache of the last-fetched DTOs, keyed by order id.
  ///
  /// `PATCH /order/:id` returns a slim payload without the user and
  /// references, so we fall back to the last full fetch to rebuild a complete
  /// [Order] entity after an update. This avoids a second GET round-trip.
  final Map<int, OrderDto> _dtoCache = {};

  @override
  Future<DataState<List<Order>>> listOrders({OrderStatus? status}) async {
    try {
      final dtos = await _api.listOrders(status: status?.apiValue);
      _dtoCache
        ..clear()
        ..addEntries(dtos.map((d) => MapEntry(d.id, d)));
      return DataSuccess(
        dtos.map((d) => d.toDomain()).toList(growable: false),
      );
    } on DioException catch (e) {
      return DataFailed(ErrorMapper.toFailure(ErrorMapper.fromDio(e)));
    } catch (e) {
      return DataFailed(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<DataState<Order>> updateStatus({
    required int orderId,
    required OrderStatus status,
  }) async {
    try {
      final dto = await _api.updateStatus(
        orderId,
        UpdateOrderStatusDto(status: status.apiValue),
      );
      final cached = _dtoCache[orderId];
      final domain = dto.toDomain(
        fallbackUser: cached?.user,
        fallbackLines: cached?.references,
      );
      // Refresh the cache with the updated status + timestamps.
      _dtoCache[orderId] = OrderDto(
        id: dto.id,
        status: dto.status,
        createdAt: dto.createdAt,
        updatedAt: dto.updatedAt,
        user: dto.user ?? cached?.user,
        references: dto.references ?? cached?.references,
      );
      return DataSuccess(domain);
    } on DioException catch (e) {
      return DataFailed(ErrorMapper.toFailure(ErrorMapper.fromDio(e)));
    } catch (e) {
      return DataFailed(ErrorMapper.toFailure(e));
    }
  }
}
