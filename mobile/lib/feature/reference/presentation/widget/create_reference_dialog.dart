import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Dialog to create a new reference by CIP13.
///
/// The backend does the enrichment (name + cip7) from its local catalogue.
/// Returns a `(cip13, startingQuantity)` tuple via `Navigator.pop` on submit.
class CreateReferenceDialog extends StatefulWidget {
  const CreateReferenceDialog({super.key});

  static Future<CreateReferenceResult?> show(BuildContext context) {
    return showDialog<CreateReferenceResult>(
      context: context,
      builder: (_) => const CreateReferenceDialog(),
    );
  }

  @override
  State<CreateReferenceDialog> createState() => _CreateReferenceDialogState();
}

class CreateReferenceResult {
  const CreateReferenceResult({required this.cip13, required this.quantity});

  final String cip13;
  final int quantity;
}

class _CreateReferenceDialogState extends State<CreateReferenceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cip13Controller = TextEditingController();
  final _quantityController = TextEditingController(text: '0');

  @override
  void dispose() {
    _cip13Controller.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pop(
        CreateReferenceResult(
          cip13: _cip13Controller.text.trim(),
          quantity: int.parse(_quantityController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouveau médicament'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _cip13Controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(13),
              ],
              decoration: const InputDecoration(
                labelText: 'CIP13',
                hintText: '13 chiffres',
              ),
              validator: (value) {
                final v = value?.trim() ?? '';
                if (v.length != 13) return 'Le CIP13 doit faire 13 chiffres';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Quantité initiale',
              ),
              validator: (value) {
                final parsed = int.tryParse(value ?? '');
                if (parsed == null || parsed < 0) return 'Nombre invalide';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Créer')),
      ],
    );
  }
}
