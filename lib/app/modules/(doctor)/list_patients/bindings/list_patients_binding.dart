import 'package:get/get.dart';

import '../controllers/list_patients_controller.dart';

class ListPatientsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListPatientsController>(
      () => ListPatientsController(),
    );
  }
}
