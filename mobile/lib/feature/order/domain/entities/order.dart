import 'package:equatable/equatable.dart';

import 'order_line.dart';
import 'order_status.dart';
import 'order_user.dart';

/// Aggregate root of the order feature.
class Order extends Equatable {
  const Order({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.lines,
  });

  final int id;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final OrderUser user;
  final List<OrderLine> lines;

  /// Total unit count across all lines (handy for card summaries).
  int get totalQuantity =>
      lines.fold(0, (sum, line) => sum + line.quantity);

  @override
  List<Object?> get props => [id, status, createdAt, updatedAt, user, lines];

  Order copyWith({OrderStatus? status, DateTime? updatedAt}) {
    return Order(
      id: id,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user,
      lines: lines,
    );
  }
}
