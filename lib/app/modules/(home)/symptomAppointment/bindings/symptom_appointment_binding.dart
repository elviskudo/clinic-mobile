import 'package:get/get.dart';

import '../controllers/symptom_appointment_controller.dart';

class SymptomAppointmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SymptomAppointmentController>(
      () => SymptomAppointmentController(),
    );
  }
}
