part of 'scanner_bloc.dart';

sealed class ScannerEvent extends Equatable {
  const ScannerEvent();

  @override
  List<Object?> get props => const [];
}

/// Emitted every time the camera detects a barcode. The bloc dedupes and
/// looks it up against the API.
class ScannerBarcodeDetected extends ScannerEvent {
  const ScannerBarcodeDetected(this.cip13);

  final String cip13;

  @override
  List<Object?> get props => [cip13];
}

/// User confirmed the quantity to add to an already-existing reference.
class ScannerAddStockSubmitted extends ScannerEvent {
  const ScannerAddStockSubmitted(this.additionalQuantity);

  final int additionalQuantity;

  @override
  List<Object?> get props => [additionalQuantity];
}

/// User confirmed the quantity for a brand-new reference (POST /reference).
class ScannerCreateSubmitted extends ScannerEvent {
  const ScannerCreateSubmitted(this.startingQuantity);

  final int startingQuantity;

  @override
  List<Object?> get props => [startingQuantity];
}

/// Discards the current result and re-arms the camera for another scan.
class ScannerResetRequested extends ScannerEvent {
  const ScannerResetRequested();
}
