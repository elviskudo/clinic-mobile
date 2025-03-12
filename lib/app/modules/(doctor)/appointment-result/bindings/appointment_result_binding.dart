import 'package:get/get.dart';

import '../controllers/appointment_result_controller.dart';

class AppointmentResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointmentResultController>(
      () => AppointmentResultController(),
    );
  }
}
