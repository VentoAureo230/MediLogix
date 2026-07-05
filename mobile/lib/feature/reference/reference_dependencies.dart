import 'package:get_it/get_it.dart';

import 'data/data_sources/remote/reference_api_service.dart';
import 'data/repository/reference_repository_impl.dart';
import 'domain/repository/reference_repository.dart';
import 'domain/usecases/add_to_stock_usecase.dart';
import 'domain/usecases/create_reference_usecase.dart';
import 'domain/usecases/get_reference_by_cip13_usecase.dart';
import 'domain/usecases/list_references_usecase.dart';
import 'presentation/bloc/reference_list_bloc.dart';

/// Wires every dependency owned by the Reference (medication) feature.
///
/// The scanner feature (Phase 6) will reuse [ReferenceRepository] and
/// [GetReferenceByCip13UseCase] from this registration — no duplication.
void registerReferenceFeature(GetIt sl) {
  sl.registerLazySingleton<ReferenceApiService>(
    () => ReferenceApiService(sl()),
  );

  sl.registerLazySingleton<ReferenceRepository>(
    () => ReferenceRepositoryImpl(sl<ReferenceApiService>()),
  );

  sl.registerLazySingleton(
    () => ListReferencesUseCase(sl<ReferenceRepository>()),
  );
  sl.registerLazySingleton(
    () => GetReferenceByCip13UseCase(sl<ReferenceRepository>()),
  );
  sl.registerLazySingleton(
    () => CreateReferenceUseCase(sl<ReferenceRepository>()),
  );
  sl.registerLazySingleton(
    () => AddToStockUseCase(sl<ReferenceRepository>()),
  );

  sl.registerFactory<ReferenceListBloc>(
    () => ReferenceListBloc(
      listReferencesUseCase: sl<ListReferencesUseCase>(),
    ),
  );
}
