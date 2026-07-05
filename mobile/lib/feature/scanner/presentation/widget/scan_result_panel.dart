import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/scanner_bloc.dart';

/// Bottom panel shown once a barcode is decoded.
///
/// Renders one of four layouts depending on [state.status]:
/// * `lookingUp`  → progress
/// * `found`      → known reference + add-to-stock form
/// * `notFound`   → unknown reference + create form
/// * `success` / `failure` → recap + rescan button
class ScanResultPanel extends StatefulWidget {
  const ScanResultPanel({super.key, required this.state});

  final ScannerState state;

  @override
  State<ScanResultPanel> createState() => _ScanResultPanelState();
}

class _ScanResultPanelState extends State<ScanResultPanel> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final qty = int.parse(_quantityController.text);
    final bloc = context.read<ScannerBloc>();
    switch (widget.state.status) {
      case ScannerStatus.found:
        bloc.add(ScannerAddStockSubmitted(qty));
      case ScannerStatus.notFound:
        bloc.add(ScannerCreateSubmitted(qty));
      // ignore: no_default_cases
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = widget.state;
    final isSubmitting = state.status == ScannerStatus.submitting;

    return Material(
      elevation: 12,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: switch (state.status) {
            ScannerStatus.lookingUp => _lookingUp(theme, state.scannedCip13),
            ScannerStatus.found ||
            ScannerStatus.submitting =>
              _foundForm(context, theme, state, isSubmitting),
            ScannerStatus.notFound => _notFoundForm(context, theme, state),
            ScannerStatus.success => _successRecap(context, theme, state),
            ScannerStatus.failure => _failureRecap(context, theme, state),
            ScannerStatus.scanning => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }

  Widget _lookingUp(ThemeData theme, String? cip13) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(height: 12),
        Text('Recherche de $cip13…', style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _foundForm(
    BuildContext context,
    ThemeData theme,
    ScannerState state,
    bool isSubmitting,
  ) {
    final ref = state.foundReference!;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(ref.name,
              style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            'CIP13 ${ref.cip13} • Stock actuel : ${ref.quantity} u.',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _quantityController,
            autofocus: true,
            enabled: !isSubmitting,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Quantité à ajouter',
              prefixIcon: Icon(Icons.add_shopping_cart_outlined),
            ),
            validator: _quantityValidator,
            onFieldSubmitted: (_) => _submit(context),
          ),
          const SizedBox(height: 12),
          _actionsRow(
            context,
            primaryLabel: 'Ajouter au stock',
            primaryOnPressed: isSubmitting ? null : () => _submit(context),
            isBusy: isSubmitting,
          ),
        ],
      ),
    );
  }

  Widget _notFoundForm(
    BuildContext context,
    ThemeData theme,
    ScannerState state,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.help_outline,
              color: theme.colorScheme.secondary, size: 32),
          const SizedBox(height: 8),
          Text('Référence inconnue', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'CIP13 ${state.scannedCip13} • à créer',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _quantityController,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Quantité initiale',
              prefixIcon: Icon(Icons.inventory_2_outlined),
            ),
            validator: (value) {
              final parsed = int.tryParse(value ?? '');
              if (parsed == null || parsed < 0) return 'Nombre invalide';
              return null;
            },
            onFieldSubmitted: (_) => _submit(context),
          ),
          const SizedBox(height: 12),
          _actionsRow(
            context,
            primaryLabel: 'Créer',
            primaryOnPressed: () => _submit(context),
          ),
        ],
      ),
    );
  }

  Widget _successRecap(
      BuildContext context, ThemeData theme, ScannerState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle_outline,
            color: Colors.green.shade600, size: 40),
        const SizedBox(height: 8),
        Text(
          state.successMessage ?? 'Opération réussie',
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () =>
              context.read<ScannerBloc>().add(const ScannerResetRequested()),
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Scanner un autre code'),
        ),
      ],
    );
  }

  Widget _failureRecap(
      BuildContext context, ThemeData theme, ScannerState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, color: Colors.red.shade600, size: 40),
        const SizedBox(height: 8),
        Text(
          state.errorMessage ?? 'Erreur',
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () =>
              context.read<ScannerBloc>().add(const ScannerResetRequested()),
          icon: const Icon(Icons.replay),
          label: const Text('Réessayer'),
        ),
      ],
    );
  }

  Widget _actionsRow(
    BuildContext context, {
    required String primaryLabel,
    required VoidCallback? primaryOnPressed,
    bool isBusy = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isBusy
                ? null
                : () => context
                    .read<ScannerBloc>()
                    .add(const ScannerResetRequested()),
            child: const Text('Annuler'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: primaryOnPressed,
            child: isBusy
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(primaryLabel),
          ),
        ),
      ],
    );
  }

  String? _quantityValidator(String? value) {
    final parsed = int.tryParse(value ?? '');
    if (parsed == null || parsed <= 0) {
      return 'Entrez un nombre entier positif';
    }
    return null;
  }
}
