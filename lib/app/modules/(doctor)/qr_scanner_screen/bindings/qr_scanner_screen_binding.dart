import 'package:get/get.dart';

import '../controllers/qr_scanner_screen_controller.dart';

class QrScannerScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrScannerScreenController>(
      () => QrScannerScreenController(),
    );
  }
}
