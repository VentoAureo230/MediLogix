import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/reference.dart';

/// Bottom sheet used to add stock to an existing reference.
///
/// Returns the entered delta (an [int] > 0) via `Navigator.pop`, or `null` if
/// the user cancels.
class AddStockBottomSheet extends StatefulWidget {
  const AddStockBottomSheet({super.key, required this.reference});

  final Reference reference;

  static Future<int?> show(BuildContext context, Reference reference) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddStockBottomSheet(reference: reference),
      ),
    );
  }

  @override
  State<AddStockBottomSheet> createState() => _AddStockBottomSheetState();
}

class _AddStockBottomSheetState extends State<AddStockBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(int.parse(_controller.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              widget.reference.name,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'CIP13 ${widget.reference.cip13} • Stock actuel : '
              '${widget.reference.quantity} u.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Quantité à ajouter',
                prefixIcon: Icon(Icons.add_shopping_cart_outlined),
              ),
              validator: (value) {
                final parsed = int.tryParse(value ?? '');
                if (parsed == null || parsed <= 0) {
                  return 'Entrez un nombre entier positif';
                }
                return null;
              },
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _submit,
                    child: const Text('Ajouter'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
