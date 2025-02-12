import 'package:get/get.dart';

import '../controllers/account_settings_controller.dart';

class AccountSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountSettingsController>(
      () => AccountSettingsController(),
    );
  }
}
