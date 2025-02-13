import 'package:get/get.dart';

import '../controllers/barcode_appointment_controller.dart';

class BarcodeAppointmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BarcodeAppointmentController>(
      () => BarcodeAppointmentController(),
    );
  }
}
