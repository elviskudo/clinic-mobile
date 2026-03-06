import 'package:get/get.dart';

import '../controllers/grab_medicine_controller.dart';

class GrabMedicineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GrabMedicineController>(
      () => GrabMedicineController(),
    );
  }
}
