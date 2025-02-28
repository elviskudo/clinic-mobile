import 'package:get/get.dart';

import '../controllers/drug_admin_controller.dart';

class DrugAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DrugAdminController>(
      () => DrugAdminController(),
    );
  }
}
