// import 'package:get/get.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QRCodeScannerController extends GetxController {
//   QRViewController? controller;
//   RxString scannedData = ''.obs; // Store scanned data as observable

//   // Initialize QR controller and start listening to scanned data
//   void initialize(QRViewController qrController) {
//     controller = qrController;
//     controller?.scannedDataStream.listen((scanData) {
//       scannedData.value = scanData.code ?? ''; // Update scanned data
//     });
//   }

//   // Dispose of the QRViewController when no longer needed
//   @override
//   void onClose() {
//     controller?.dispose();
//     super.onClose();
//   }
// }
