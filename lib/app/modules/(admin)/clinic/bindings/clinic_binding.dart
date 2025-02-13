import 'package:get/get.dart';

import '../controllers/clinic_controller.dart';

class ClinicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicController>(
      () => ClinicController(),
    );
  }
}
