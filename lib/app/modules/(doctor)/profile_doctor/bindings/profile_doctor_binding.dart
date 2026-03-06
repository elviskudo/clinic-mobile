import 'package:get/get.dart';

import '../controllers/profile_doctor_controller.dart';

class ProfileDoctorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileDoctorController>(
      () => ProfileDoctorController(),
    );
  }
}
