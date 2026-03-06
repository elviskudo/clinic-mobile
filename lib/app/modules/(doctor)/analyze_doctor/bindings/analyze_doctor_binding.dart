import 'package:get/get.dart';

import '../controllers/analyze_doctor_controller.dart';

class AnalyzeDoctorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalyzeDoctorController>(
      () => AnalyzeDoctorController(),
    );
  }
}
