import 'package:get/get.dart';

class PersonalDataController extends GetxController {
  //TODO: Implement PersonalDataController

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

  @override
  void onClose() {
    super.onClose();
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
  }

  void increment() => count.value++;
}
