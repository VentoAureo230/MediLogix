import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../bloc/scanner_bloc.dart';
import '../widget/scan_result_panel.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<ScannerBloc>(),
      child: const _ScannerView(),
    );
  }
}

class _ScannerView extends StatefulWidget {
  const _ScannerView();

  @override
  State<_ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<_ScannerView> {
  late final MobileScannerController _cameraController =
      MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [
      BarcodeFormat.ean13,
      BarcodeFormat.dataMatrix,
      BarcodeFormat.code128,
    ],
  );

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (capture.barcodes.isEmpty) return;
    final raw = capture.barcodes.first.rawValue;
    if (raw == null || raw.isEmpty) return;
    // GS1 DataMatrix codes on French drug boxes prefix the CIP13 with `01`.
    // Strip it if present so downstream code sees a clean 13-digit string.
    final normalized =
        raw.startsWith('01') && raw.length >= 15 ? raw.substring(2, 15) : raw;
    context.read<ScannerBloc>().add(ScannerBarcodeDetected(normalized));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScannerBloc, ScannerState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        // Pause the camera while a result overlay is visible so it doesn't
        // burn battery, resume when the user rearms it.
        if (state.status == ScannerStatus.scanning) {
          _cameraController.start();
        } else {
          _cameraController.stop();
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Positioned.fill(
              child: MobileScanner(
                controller: _cameraController,
                onDetect: _onDetect,
                errorBuilder: (context, error) => _CameraErrorView(error: error),
              ),
            ),
            const Positioned.fill(child: _ScannerOverlay()),
            if (state.status != ScannerStatus.scanning)
              Align(
                alignment: Alignment.bottomCenter,
                child: ScanResultPanel(state: state),
              ),
          ],
        );
      },
    );
  }
}

/// Translucent frame with a cutout that guides the user to align the barcode.
class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 260,
          height: 160,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 3),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _CameraErrorView extends StatelessWidget {
  const _CameraErrorView({required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.no_photography_outlined,
                  color: Colors.white, size: 48),
              const SizedBox(height: 12),
              Text(
                'Impossible d\'accéder à la caméra',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error.errorDetails?.message ?? error.errorCode.name,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
