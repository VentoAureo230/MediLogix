import 'package:equatable/equatable.dart';

/// Minimal reference info embedded in an [OrderLine].
///
/// This is intentionally *not* the full `Reference` entity used by the
/// medication feature — the order endpoint only returns id/name/cip13.
class OrderReferenceRef extends Equatable {
  const OrderReferenceRef({
    required this.id,
    required this.name,
    required this.cip13,
  });

  final int id;
  final String name;
  final String cip13;

  @override
  List<Object?> get props => [id, name, cip13];
}
