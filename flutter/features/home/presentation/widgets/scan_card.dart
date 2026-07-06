// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import '../../../../design_system/components/glass/glass_container.dart';
// import '../../../../design_system/foundations/spacing.dart';

// class ScanCard extends StatefulWidget {
//   final Function(String sku) onScanCompleted;

//   const ScanCard({super.key, required this.onScanCompleted});

//   @override
//   State<ScanCard> createState() => _ScanCardState();
// }

// class _ScanCardState extends State<ScanCard> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   void _onQRViewCreated(QRViewController ctrl) {
//     controller = ctrl;
//     controller!.scannedDataStream.listen((scanData) {
//       widget.onScanCompleted(scanData.code ?? '');
//       controller?.pauseCamera(); // pause after scan
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GlassContainer(
//       padding: const EdgeInsets.all(AppSpacing.spaceM),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text(
//             'Scan Product QR Code',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: AppSpacing.spaceM),
//           SizedBox(
//             height: 200,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//               overlay: QrScannerOverlayShape(
//                 borderColor: Colors.white,
//                 borderRadius: 16,
//                 borderLength: 30,
//                 borderWidth: 8,
//                 cutOutSize: 180,
//               ),
//             ),
//           ),
//           const SizedBox(height: AppSpacing.spaceM),
//           ElevatedButton(
//             onPressed: () => controller?.resumeCamera(),
//             child: const Text('Restart Scanner'),
//           ),
//         ],
//       ),
//     );
//   }
// }
