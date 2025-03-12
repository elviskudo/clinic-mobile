import 'package:get/get.dart';

import '../controllers/medicine_record_view.dart';

class MedicineRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicineRecordController>(
      () => MedicineRecordController(),
    );
  }
}
