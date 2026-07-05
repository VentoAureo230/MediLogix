import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/order_dto.dart';
import '../../models/update_order_status_dto.dart';

part 'order_api_service.g.dart';

@RestApi()
abstract class OrderApiService {
  factory OrderApiService(Dio dio, {String? baseUrl}) = _OrderApiService;

  @GET(ApiConstants.orders)
  Future<List<OrderDto>> listOrders({@Query('status') String? status});

  @PATCH('${ApiConstants.orders}/{id}')
  Future<OrderDto> updateStatus(
    @Path('id') int id,
    @Body() UpdateOrderStatusDto body,
  );
}
