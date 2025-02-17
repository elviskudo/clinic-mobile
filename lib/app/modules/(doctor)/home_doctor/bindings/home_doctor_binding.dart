import 'package:get/get.dart';

import '../controllers/home_doctor_controller.dart';

class HomeDoctorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeDoctorController>(
      () => HomeDoctorController(),
    );
  }
}
