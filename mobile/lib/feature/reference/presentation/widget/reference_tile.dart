import 'package:flutter/material.dart';

import '../../domain/entities/reference.dart';

/// A single row in the references list.
///
/// The stock chip goes red when the quantity is below [lowStockThreshold] so
/// the pharmacist can spot critical items at a glance.
class ReferenceTile extends StatelessWidget {
  const ReferenceTile({
    super.key,
    required this.reference,
    required this.onTap,
    this.lowStockThreshold = 20,
  });

  final Reference reference;
  final VoidCallback onTap;
  final int lowStockThreshold;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLow = reference.quantity <= lowStockThreshold;
    final chipColor = isLow ? Colors.red.shade600 : Colors.green.shade600;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        reference.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        'CIP13 ${reference.cip13} • CIP7 ${reference.cip7}',
        style: theme.textTheme.bodySmall,
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: chipColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: chipColor.withValues(alpha: 0.4)),
        ),
        child: Text(
          '${reference.quantity} u.',
          style: TextStyle(
            color: chipColor,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
