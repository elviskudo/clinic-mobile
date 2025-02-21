import 'package:get/get.dart';

import '../controllers/summary_appointment_controller.dart';

class SummaryAppointmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SummaryAppointmentController>(
      () => SummaryAppointmentController(),
    );
  }
}
