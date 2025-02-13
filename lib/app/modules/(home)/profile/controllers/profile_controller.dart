import 'package:get/get.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController

  final count = 0.obs;
  final isDarkMode = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
