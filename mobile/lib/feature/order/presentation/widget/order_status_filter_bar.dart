import 'package:flutter/material.dart';

import '../../domain/entities/order_status.dart';
import 'order_status_chip.dart';

/// Horizontal row of filter chips for the order status. A `null` value means
/// "all statuses".
class OrderStatusFilterBar extends StatelessWidget {
  const OrderStatusFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final OrderStatus? selected;
  final ValueChanged<OrderStatus?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Toutes'),
            selected: selected == null,
            onSelected: (_) => onSelected(null),
          ),
          for (final status in OrderStatus.values) ...[
            const SizedBox(width: 8),
            ChoiceChip(
              label: OrderStatusChip(status: status, compact: true),
              selected: selected == status,
              onSelected: (_) => onSelected(status),
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
          ],
        ],
      ),
    );
  }
}
