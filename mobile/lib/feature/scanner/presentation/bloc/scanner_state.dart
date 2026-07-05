part of 'scanner_bloc.dart';

/// The stages the scanner UI goes through:
///
/// * `scanning`   — camera live, waiting for a code
/// * `lookingUp`  — API round-trip for `GET /reference/:cip13`
/// * `found`      — reference exists → show add-stock form
/// * `notFound`   — reference unknown → show create form
/// * `submitting` — a POST/PATCH is in flight
/// * `success`    — success feedback shown before auto-reset (optional)
/// * `failure`    — error to display; the user can retry or reset
enum ScannerStatus {
  scanning,
  lookingUp,
  found,
  notFound,
  submitting,
  success,
  failure,
}

class ScannerState extends Equatable {
  const ScannerState({
    this.status = ScannerStatus.scanning,
    this.scannedCip13,
    this.foundReference,
    this.successMessage,
    this.errorMessage,
  });

  final ScannerStatus status;

  /// The barcode last emitted by the camera, kept even when we transition to
  /// `notFound` so the create form can preselect it.
  final String? scannedCip13;

  /// Populated in `found` and `success` (after add-stock) states.
  final Reference? foundReference;

  final String? successMessage;
  final String? errorMessage;

  ScannerState copyWith({
    ScannerStatus? status,
    String? scannedCip13,
    Reference? foundReference,
    bool clearFoundReference = false,
    String? successMessage,
    bool clearSuccessMessage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ScannerState(
      status: status ?? this.status,
      scannedCip13: scannedCip13 ?? this.scannedCip13,
      foundReference:
          clearFoundReference ? null : (foundReference ?? this.foundReference),
      successMessage:
          clearSuccessMessage ? null : (successMessage ?? this.successMessage),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        scannedCip13,
        foundReference,
        successMessage,
        errorMessage,
      ];
}
