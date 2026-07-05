import 'package:equatable/equatable.dart';

import 'order_reference_ref.dart';

/// One line of an order: a reference and how many units were requested.
class OrderLine extends Equatable {
  const OrderLine({required this.reference, required this.quantity});

  final OrderReferenceRef reference;
  final int quantity;

  @override
  List<Object?> get props => [reference, quantity];
}
