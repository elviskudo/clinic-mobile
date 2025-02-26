import 'package:get/get.dart';

import '../controllers/detail_diagnose_controller.dart';

class DetailDiagnoseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailDiagnoseController>(
      () => DetailDiagnoseController(),
    );
  }
}
