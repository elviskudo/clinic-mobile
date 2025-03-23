import 'package:get/get.dart';

import '../controllers/payment_denied_controller.dart';

class PaymentDeniedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentDeniedController>(
      () => PaymentDeniedController(),
    );
  }
}
