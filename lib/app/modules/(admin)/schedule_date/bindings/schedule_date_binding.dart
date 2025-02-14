import 'package:get/get.dart';

import '../controllers/schedule_date_controller.dart';

class ScheduleDateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleDateController>(
      () => ScheduleDateController(),
    );
  }
}
