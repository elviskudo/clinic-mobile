import 'package:get/get.dart';

import '../controllers/poly_controller.dart';

class PolyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PolyController>(
      () => PolyController(),
    );
  }
}
