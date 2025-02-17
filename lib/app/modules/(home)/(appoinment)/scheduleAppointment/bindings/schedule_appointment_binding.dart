import 'package:get/get.dart';

import '../controllers/schedule_appointment_controller.dart';

class ScheduleAppointmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleAppointmentController>(
      () => ScheduleAppointmentController(),
    );
  }
}
