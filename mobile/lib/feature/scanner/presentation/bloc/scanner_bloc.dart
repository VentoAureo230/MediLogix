import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../reference/domain/entities/reference.dart';
import '../../../reference/domain/usecases/add_to_stock_usecase.dart';
import '../../../reference/domain/usecases/create_reference_usecase.dart';
import '../../../reference/domain/usecases/get_reference_by_cip13_usecase.dart';

part 'scanner_event.dart';
part 'scanner_state.dart';

/// State machine driving the scanner page.
///
/// Reuses the `Reference` use cases — the scanner does not own any repository
/// of its own.
class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  ScannerBloc({
    required GetReferenceByCip13UseCase getReferenceByCip13,
    required AddToStockUseCase addToStock,
    required CreateReferenceUseCase createReference,
  })  : _getReferenceByCip13 = getReferenceByCip13,
        _addToStock = addToStock,
        _createReference = createReference,
        super(const ScannerState()) {
    on<ScannerBarcodeDetected>(_onBarcodeDetected);
    on<ScannerAddStockSubmitted>(_onAddStockSubmitted);
    on<ScannerCreateSubmitted>(_onCreateSubmitted);
    on<ScannerResetRequested>(_onResetRequested);
  }

  final GetReferenceByCip13UseCase _getReferenceByCip13;
  final AddToStockUseCase _addToStock;
  final CreateReferenceUseCase _createReference;

  Future<void> _onBarcodeDetected(
    ScannerBarcodeDetected event,
    Emitter<ScannerState> emit,
  ) async {
    // Only accept detections while the camera is armed. Anything else means
    // a stale frame during a result screen, ignore it.
    if (state.status != ScannerStatus.scanning) return;

    final cip13 = event.cip13.trim();
    if (cip13.length != 13 || int.tryParse(cip13) == null) {
      emit(state.copyWith(
        status: ScannerStatus.failure,
        scannedCip13: cip13,
        errorMessage: 'Code invalide (CIP13 attendu, 13 chiffres)',
      ));
      return;
    }

    emit(state.copyWith(
      status: ScannerStatus.lookingUp,
      scannedCip13: cip13,
      clearFoundReference: true,
      clearErrorMessage: true,
      clearSuccessMessage: true,
    ));

    final result = await _getReferenceByCip13(cip13);
    switch (result) {
      case DataSuccess(:final data):
        if (data == null) {
          emit(state.copyWith(status: ScannerStatus.notFound));
        } else {
          emit(state.copyWith(
            status: ScannerStatus.found,
            foundReference: data,
          ));
        }
      case DataFailed(:final failure):
        emit(state.copyWith(
          status: ScannerStatus.failure,
          errorMessage: failure.message ?? 'Erreur lors de la recherche',
        ));
    }
  }

  Future<void> _onAddStockSubmitted(
    ScannerAddStockSubmitted event,
    Emitter<ScannerState> emit,
  ) async {
    final cip13 = state.scannedCip13;
    if (cip13 == null || state.status != ScannerStatus.found) return;

    emit(state.copyWith(status: ScannerStatus.submitting));
    final result = await _addToStock(AddToStockParams(
      cip13: cip13,
      additionalQuantity: event.additionalQuantity,
    ));

    switch (result) {
      case DataSuccess(:final data):
        emit(state.copyWith(
          status: ScannerStatus.success,
          foundReference: data,
          successMessage:
              '+${event.additionalQuantity} ajouté à ${data.name}',
        ));
      case DataFailed(:final failure):
        emit(state.copyWith(
          status: ScannerStatus.failure,
          errorMessage: failure.message ?? 'Ajout au stock impossible',
        ));
    }
  }

  Future<void> _onCreateSubmitted(
    ScannerCreateSubmitted event,
    Emitter<ScannerState> emit,
  ) async {
    final cip13 = state.scannedCip13;
    if (cip13 == null || state.status != ScannerStatus.notFound) return;

    emit(state.copyWith(status: ScannerStatus.submitting));
    final result = await _createReference(CreateReferenceParams(
      cip13: cip13,
      startingQuantity: event.startingQuantity,
    ));

    switch (result) {
      case DataSuccess(:final data):
        emit(state.copyWith(
          status: ScannerStatus.success,
          foundReference: data,
          successMessage: '${data.name} créé (${data.quantity} u.)',
        ));
      case DataFailed(:final failure):
        emit(state.copyWith(
          status: ScannerStatus.failure,
          errorMessage: failure.message ?? 'Création impossible',
        ));
    }
  }

  void _onResetRequested(
    ScannerResetRequested event,
    Emitter<ScannerState> emit,
  ) {
    emit(const ScannerState());
  }
}
