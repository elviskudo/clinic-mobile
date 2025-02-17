// View
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../controllers/qr_scanner_screen_controller.dart';

class QrScannerScreenView extends GetView<QrScannerScreenController> {
  const QrScannerScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Patient QR Code'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.flash_on),
            onPressed: controller.toggleFlash,
          ),
        ],
      ),
      body: MobileScanner(
        controller: controller.scannerController,
        onDetect: controller.onDetect,
        
      ),
    );
  }
}
