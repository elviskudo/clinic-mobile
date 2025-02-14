import 'package:get/get.dart';

import '../controllers/schedule_time_controller.dart';

class ScheduleTimeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleTimeController>(
      () => ScheduleTimeController(),
    );
  }
}
