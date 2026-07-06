import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../design_system/components/glass/glass_container.dart';
import '../../../../design_system/foundations/spacing.dart';
import '../../../../design_system/foundations/typography.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../../home/application/home_bloc.dart';
import '../../../product/domain/repositories/product_repository.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with WidgetsBindingObserver {
  late final MobileScannerController _controller;
  bool _isProcessing = false;
  final Key _previewKey = UniqueKey();

  Future<void> _showVerificationPopup({
    required bool isReal,
    required String sku,
  }) async {
    final shouldOpenOverview = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _VerificationPopupContent(isReal: isReal),
    );

    if (!mounted) return;
    if (isReal && shouldOpenOverview == true) {
      await context.push('/product/$sku');
      if (!mounted) return;
    }
    setState(() => _isProcessing = false);
    _controller.start();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      returnImage: false,
      autoStart: false,
      detectionTimeoutMs: 1000,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCamera();
    });
  }

  Future<void> _initializeCamera() async {
    if (!mounted) return;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted && !_controller.value.isRunning) {
        await _controller.start();
      }
    } catch (e) {
      debugPrint('Error starting camera: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.isInitialized) return;

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        if (_controller.value.isRunning) {
          _controller.stop();
        }
        return;
      case AppLifecycleState.resumed:
        if (!_controller.value.isRunning) {
          _controller.start();
        }
        break;
      case AppLifecycleState.inactive:
        if (_controller.value.isRunning) {
          _controller.stop();
        }
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  // Future<void> _processSku(String rawValue) async {
  //   if (_isProcessing) return;
  //   if (rawValue.isEmpty) return;

  //   setState(() => _isProcessing = true);

  //   try {
  //     String sku = rawValue.trim();
  //     final uri = Uri.tryParse(rawValue);
  //     if (uri != null && uri.hasScheme && uri.pathSegments.isNotEmpty) {
  //       if (uri.pathSegments.contains('product')) {
  //         final index = uri.pathSegments.indexOf('product');
  //         if (index + 1 < uri.pathSegments.length) {
  //           sku = uri.pathSegments[index + 1];
  //         }
  //       } else {
  //         sku = uri.pathSegments.last;
  //       }
  //     }

  //     String? location;
  //     try {
  //       final (product, _, _) = await context
  //           .read<ProductRepository>()
  //           .getFullProduct(sku, verify: false);
  //       location = product.location;
  //     } catch (_) {
  //       location = null;
  //     }

  //     await SharedPreferencesService().addScanBySku(sku, location: location);
  //     if (mounted) {
  //       context.read<HomeBloc>().add(HomeLoadEvent());
  //     }

  //     if (mounted) {
  //       await _controller.stop();
  //       await context.push('/product/$sku');

  //       if (mounted) {
  //         setState(() => _isProcessing = false);
  //         _controller.start();
  //       }
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Row(
  //             children: [
  //               const Icon(Icons.error_outline, color: Colors.white),
  //               const SizedBox(width: 8),
  //               Expanded(child: Text('Product not found: $rawValue')),
  //             ],
  //           ),
  //           backgroundColor:
  //               context.colors.danger, // Changed from danger to error if needed
  //           behavior: SnackBarBehavior.floating,
  //           margin: const EdgeInsets.all(20),
  //         ),
  //       );
  //       await Future.delayed(const Duration(seconds: 2));
  //       if (mounted) {
  //         setState(() => _isProcessing = false);
  //       }
  //     }
  //   }
  // }
  static String _extractSku(String rawValue) {
    final trimmed = rawValue.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || uri.pathSegments.isEmpty) return trimmed;
    if (uri.pathSegments.contains('product')) {
      final index = uri.pathSegments.indexOf('product');
      if (index + 1 < uri.pathSegments.length) {
        return uri.pathSegments[index + 1];
      }
      return trimmed;
    }
    return uri.pathSegments.last;
  }

  Future<void> _processSku(String rawValue) async {
    if (_isProcessing) return;
    if (rawValue.isEmpty) return;

    setState(() => _isProcessing = true);
    final sku = _extractSku(rawValue);

    try {
      final (product, _, _) = await context
          .read<ProductRepository>()
          .getFullProduct(sku, verify: false);

      await SharedPreferencesService().addScanBySku(
        sku,
        location: product.location,
      );

      if (mounted) {
        context.read<HomeBloc>().add(HomeLoadEvent());
      }

      if (mounted) {
        await _controller.stop();
        if (!mounted) return;
        await _showVerificationPopup(isReal: true, sku: sku);
      }
    } catch (e) {
      if (mounted) {
        await _controller.stop();
        if (!mounted) return;
        await _showVerificationPopup(isReal: false, sku: sku);
      }
    }
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (_isProcessing) return;
    if (capture.barcodes.isEmpty) return;
    final value = capture.barcodes.first.rawValue;
    if (value != null) {
      _processSku(value);
    }
  }

  void _showManualInput() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.background,
        title: Text(
          'Enter SKU Manually',
          style: AppTypography.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'e.g. SKU0',
                hintStyle: TextStyle(color: context.colors.textSecondary),
                filled: true,
                fillColor: context.colors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusS),
                  borderSide: BorderSide(color: context.colors.primary),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.colors.textSecondary),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _navigateWithoutRecording(textController.text);
            },
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.primary,
            ),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateWithoutRecording(String raw) async {
    final value = raw.trim();
    if (value.isEmpty) return;
    final sku = _extractSku(value);
    try {
      final (product, _, _) = await context
          .read<ProductRepository>()
          .getFullProduct(sku, verify: false);

      await SharedPreferencesService().addScanBySku(
        sku,
        location: product.location,
      );
      if (mounted) {
        context.read<HomeBloc>().add(HomeLoadEvent());
      }

      await _controller.stop();
      if (!mounted) return;
      await _showVerificationPopup(isReal: true, sku: sku);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _controller.dispose();
        return true;
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: MobileScanner(
              key: _previewKey,
              controller: _controller,
              onDetect: _handleBarcode,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.spaceM),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spaceM,
                  ),
                  child: GlassContainer(
                    borderRadius: AppSpacing.radiusM,
                    padding: const EdgeInsets.all(AppSpacing.spaceM),
                    child: Row(
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          color: context.colors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: AppSpacing.spaceM),
                        Expanded(
                          child: Text(
                            'Point camera at a product QR code',
                            style: AppTypography.textTheme.bodyMedium?.copyWith(
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.spaceL * 2,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _isProcessing
                                ? context.colors.primary
                                : Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusM,
                          ),
                        ),
                        child: const AspectRatio(
                          aspectRatio: 1,
                          child: SizedBox(),
                        ),
                      ),
                      if (_isProcessing)
                        CircularProgressIndicator(
                          color: context.colors.primary,
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.spaceM),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // --- FIXED FLASHLIGHT LOGIC HERE ---
                      ValueListenableBuilder(
                        valueListenable:
                            _controller, // Listen to controller directly
                        builder: (context, state, child) {
                          // Access torchState from the state object
                          final isFlashOn = state.torchState == TorchState.on;

                          return GlassContainer(
                            borderRadius: AppSpacing.radiusM,
                            padding: const EdgeInsets.all(AppSpacing.spaceM),
                            child: IconButton(
                              icon: Icon(
                                isFlashOn ? Icons.flash_on : Icons.flash_off,
                                color: isFlashOn
                                    ? Colors.yellow
                                    : context.colors.textPrimary,
                              ),
                              onPressed: () => _controller.toggleTorch(),
                            ),
                          );
                        },
                      ),
                      // -----------------------------------
                      GlassContainer(
                        borderRadius: AppSpacing.radiusM,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.spaceL,
                          vertical: AppSpacing.spaceM,
                        ),
                        child: TextButton.icon(
                          onPressed: _showManualInput,
                          icon: Icon(
                            Icons.keyboard,
                            color: context.colors.primary,
                          ),
                          label: Text(
                            'Enter Manually',
                            style: AppTypography.textTheme.bodyMedium?.copyWith(
                              color: context.colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.spaceM),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerificationPopupContent extends StatelessWidget {
  const _VerificationPopupContent({required this.isReal});
  final bool isReal;

  @override
  Widget build(BuildContext context) {
    final icon = isReal ? '✅' : '🛑';
    final headline = isReal ? 'Safe' : 'Unsafe';
    final description = isReal
        ? 'Verified official item. Safe to purchase.'
        : 'This item failed our authenticity check. It is likely fake.';
    final accentColor = isReal ? context.colors.primary : context.colors.danger;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusL),
          border: Border.all(color: accentColor.withOpacity(0.35), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.spaceL,
          AppSpacing.spaceM,
          AppSpacing.spaceL,
          AppSpacing.spaceL,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.close, color: context.colors.textSecondary),
                tooltip: 'Close',
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: AppSpacing.spaceS),
            Text(
              '$icon $headline',
              style: AppTypography.textTheme.headlineMedium?.copyWith(
                color: accentColor,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceM),
            Text(
              description,
              style: AppTypography.textTheme.bodyLarge?.copyWith(
                color: context.colors.textPrimary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: AppSpacing.spaceL),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context, isReal),
                style: FilledButton.styleFrom(
                  backgroundColor: accentColor,
                  minimumSize: const Size.fromHeight(44),
                ),
                child: Text(
                  isReal ? 'View More' : 'OK',
                  style: isReal ? null : const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
