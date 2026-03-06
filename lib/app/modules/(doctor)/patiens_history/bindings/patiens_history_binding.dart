import 'package:get/get.dart';

import '../controllers/patiens_history_controller.dart';

class PatiensHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatiensHistoryController>(
      () => PatiensHistoryController(),
    );
  }
}
