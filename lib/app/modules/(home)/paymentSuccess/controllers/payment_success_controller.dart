import 'package:get/get.dart';

class PaymentSuccessController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Auto-navigate back to home after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      // Uncomment this to auto-navigate
      // Get.offNamed('/home');
    });
  }
}