import 'package:flutter/material.dart';

import '../../domain/entities/order_status.dart';

/// Small colored pill showing an [OrderStatus]. Colour choices match the
/// semantics: blue for new/active, orange for in-progress, green for done,
/// red for cancelled.
class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({super.key, required this.status, this.compact = false});

  final OrderStatus status;
  final bool compact;

  Color _color(BuildContext context) {
    switch (status) {
      case OrderStatus.newOrder:
        return Colors.blue.shade600;
      case OrderStatus.ongoing:
        return Colors.orange.shade700;
      case OrderStatus.ready:
        return Colors.green.shade600;
      case OrderStatus.cancelled:
        return Colors.red.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: compact ? 11 : 12,
        ),
      ),
    );
  }
}
