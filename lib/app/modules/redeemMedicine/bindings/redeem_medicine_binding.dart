import 'package:get/get.dart';

import '../controllers/redeem_medicine_controller.dart';

class RedeemMedicineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RedeemMedicineController>(
      () => RedeemMedicineController(),
    );
  }
}
