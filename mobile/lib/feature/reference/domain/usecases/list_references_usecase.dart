import 'package:equatable/equatable.dart';

import '../../../../core/models/paginated_result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reference.dart';
import '../repository/reference_repository.dart';

class ListReferencesParams extends Equatable {
  const ListReferencesParams({
    this.page = 1,
    this.limit = 20,
    this.maxQuantity,
    this.search,
  });

  final int page;
  final int limit;
  final int? maxQuantity;
  final String? search;

  @override
  List<Object?> get props => [page, limit, maxQuantity, search];
}

class ListReferencesUseCase
    extends UseCase<PaginatedResult<Reference>, ListReferencesParams> {
  const ListReferencesUseCase(this._repository);

  final ReferenceRepository _repository;

  @override
  Future<DataState<PaginatedResult<Reference>>> call(
    ListReferencesParams params,
  ) {
    return _repository.listReferences(
      page: params.page,
      limit: params.limit,
      maxQuantity: params.maxQuantity,
      search: params.search,
    );
  }
}
