import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/order.dart';
import '../../domain/entities/order_status.dart';
import '../bloc/order_list_bloc.dart';
import 'order_status_chip.dart';

/// One order rendered as an [ExpansionTile] card. Header shows the essentials
/// (id, requester, status), body reveals every reference in the order and the
/// available status transitions.
class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, required this.isUpdating});

  final Order order;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final transitions = order.status.nextAllowed;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Commande #${order.id}',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            if (isUpdating)
              const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              OrderStatusChip(status: order.status, compact: true),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${order.user.email} • ${order.lines.length} réf. • '
            '${order.totalQuantity} u.',
            style: theme.textTheme.bodySmall,
          ),
        ),
        children: [
          const Divider(height: 1),
          const SizedBox(height: 12),
          ...order.lines.map(
            (line) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line.reference.name,
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'CIP13 ${line.reference.cip13}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '×${line.quantity}',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          if (transitions.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              children: transitions
                  .map(
                    (target) => OutlinedButton(
                      onPressed: isUpdating
                          ? null
                          : () => context.read<OrderListBloc>().add(
                                OrderStatusChangeRequested(
                                  orderId: order.id,
                                  newStatus: target,
                                ),
                              ),
                      child: Text(_actionLabel(target)),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ],
      ),
    );
  }

  String _actionLabel(OrderStatus target) {
    switch (target) {
      case OrderStatus.ongoing:
        return 'Prendre en charge';
      case OrderStatus.ready:
        return 'Marquer prête';
      case OrderStatus.cancelled:
        return 'Annuler';
      case OrderStatus.newOrder:
        return 'Rouvrir';
    }
  }
}
