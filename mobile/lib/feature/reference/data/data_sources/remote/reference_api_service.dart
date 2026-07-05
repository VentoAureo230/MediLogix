import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../models/create_reference_request_dto.dart';
import '../../models/paginated_reference_response_dto.dart';
import '../../models/reference_dto.dart';
import '../../models/update_reference_quantity_dto.dart';

part 'reference_api_service.g.dart';

@RestApi()
abstract class ReferenceApiService {
  factory ReferenceApiService(Dio dio, {String? baseUrl}) =
      _ReferenceApiService;

  @GET(ApiConstants.references)
  Future<PaginatedReferenceResponseDto> listReferences({
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('maxQuantity') int? maxQuantity,
    @Query('search') String? search,
  });

  @GET('${ApiConstants.references}/{cip13}')
  Future<ReferenceDto?> getByCip13(@Path('cip13') String cip13);

  @POST(ApiConstants.references)
  Future<ReferenceDto> create(@Body() CreateReferenceRequestDto body);

  @PATCH('${ApiConstants.references}/{cip13}')
  Future<ReferenceDto> updateQuantity(
    @Path('cip13') String cip13,
    @Body() UpdateReferenceQuantityDto body,
  );
}
