import 'package:get/get.dart';

import '../controllers/notification_user_controller.dart';

class NotificationUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationUserController>(
      () => NotificationUserController(),
    );
  }
}
