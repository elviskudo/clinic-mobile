import 'package:get/get.dart';

import '../controllers/personal_data_controller.dart';

class PersonalDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalDataController>(
      () => PersonalDataController(),
    );
  }
}
