import 'package:get/get.dart';

import '../controllers/capture_appointment_controller.dart';

class CaptureAppointmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CaptureAppointmentController>(
      () => CaptureAppointmentController(),
    );
  }
}
