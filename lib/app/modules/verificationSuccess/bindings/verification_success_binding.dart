import 'package:get/get.dart';

import '../controllers/verification_success_controller.dart';

class VerivicationSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerificationSuccessController>(
      () => VerificationSuccessController(),
    );
  }
}
