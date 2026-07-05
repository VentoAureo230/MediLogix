import 'package:dio/dio.dart';

import '../../../../core/models/paginated_result.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/reference.dart';
import '../../domain/repository/reference_repository.dart';
import '../data_sources/remote/reference_api_service.dart';
import '../models/create_reference_request_dto.dart';
import '../models/update_reference_quantity_dto.dart';

class ReferenceRepositoryImpl implements ReferenceRepository {
  ReferenceRepositoryImpl(this._api);

  final ReferenceApiService _api;

  @override
  Future<DataState<PaginatedResult<Reference>>> listReferences({
    int page = 1,
    int limit = 20,
    int? maxQuantity,
    String? search,
  }) async {
    try {
      final response = await _api.listReferences(
        page: page,
        limit: limit,
        maxQuantity: maxQuantity,
        search: (search != null && search.isNotEmpty) ? search : null,
      );
      return DataSuccess(
        PaginatedResult<Reference>(
          items: response.data
              .map((d) => d.toDomain())
              .toList(growable: false),
          total: response.total,
          page: response.page,
          limit: response.limit,
        ),
      );
    } on DioException catch (e) {
      return DataFailed(ErrorMapper.toFailure(ErrorMapper.fromDio(e)));
    } catch (e) {
      return DataFailed(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<DataState<Reference?>> getByCip13(String cip13) async {
    try {
      final dto = await _api.getByCip13(cip13);
      return DataSuccess(dto?.toDomain());
    } on DioException catch (e) {
      // Backend returns `null` for unknown cip13 rather than 404, but the
      // scanner may still hit a 404 in edge cases — treat both as "not found".
      if (e.response?.statusCode == 404) {
        return const DataSuccess(null);
      }
      return DataFailed(ErrorMapper.toFailure(ErrorMapper.fromDio(e)));
    } catch (e) {
      return DataFailed(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<DataState<Reference>> create({
    required String cip13,
    int startingQuantity = 0,
  }) async {
    try {
      final dto = await _api.create(
        CreateReferenceRequestDto(
          cip13: cip13,
          quantity: startingQuantity > 0 ? startingQuantity : null,
        ),
      );
      return DataSuccess(dto.toDomain());
    } on DioException catch (e) {
      return DataFailed(ErrorMapper.toFailure(ErrorMapper.fromDio(e)));
    } catch (e) {
      return DataFailed(ErrorMapper.toFailure(e));
    }
  }

  @override
  Future<DataState<Reference>> addToStock({
    required String cip13,
    required int additionalQuantity,
  }) async {
    try {
      final dto = await _api.updateQuantity(
        cip13,
        UpdateReferenceQuantityDto(quantity: additionalQuantity),
      );
      return DataSuccess(dto.toDomain());
    } on DioException catch (e) {
      return DataFailed(ErrorMapper.toFailure(ErrorMapper.fromDio(e)));
    } catch (e) {
      return DataFailed(ErrorMapper.toFailure(e));
    }
  }
}
