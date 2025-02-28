import 'package:get/get.dart';

import '../controllers/medical_history_controller.dart';

class MedicalHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicalHistoryController>(
      () => MedicalHistoryController(),
    );
  }
}
