import '../../../../core/models/paginated_result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reference.dart';

abstract class ReferenceRepository {
  /// Fetches one page of references, optionally filtered by [search] (name or
  /// cip13 contains) and/or by low-stock threshold [maxQuantity].
  Future<DataState<PaginatedResult<Reference>>> listReferences({
    int page = 1,
    int limit = 20,
    int? maxQuantity,
    String? search,
  });

  /// Returns the reference matching [cip13], or `null` when the backend has
  /// no such reference (used mostly by the scanner feature).
  Future<DataState<Reference?>> getByCip13(String cip13);

  /// Creates a new reference from a scanned CIP13. The backend enriches the
  /// row with name/cip7 pulled from its local CSV catalogue.
  Future<DataState<Reference>> create({
    required String cip13,
    int startingQuantity = 0,
  });

  /// Adds [additionalQuantity] to the existing stock of the reference at
  /// [cip13]. The backend performs an increment, not a replace — pass the
  /// delta, not the target total.
  Future<DataState<Reference>> addToStock({
    required String cip13,
    required int additionalQuantity,
  });
}
