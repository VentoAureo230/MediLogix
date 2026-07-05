import 'package:get_it/get_it.dart';

import '../reference/domain/usecases/add_to_stock_usecase.dart';
import '../reference/domain/usecases/create_reference_usecase.dart';
import '../reference/domain/usecases/get_reference_by_cip13_usecase.dart';
import 'presentation/bloc/scanner_bloc.dart';

/// Registers scanner-specific dependencies.
///
/// The scanner has no data/domain layer of its own — it reuses the reference
/// use cases wired by [registerReferenceFeature], which must run first.
void registerScannerFeature(GetIt sl) {
  sl.registerFactory<ScannerBloc>(
    () => ScannerBloc(
      getReferenceByCip13: sl<GetReferenceByCip13UseCase>(),
      addToStock: sl<AddToStockUseCase>(),
      createReference: sl<CreateReferenceUseCase>(),
    ),
  );
}
