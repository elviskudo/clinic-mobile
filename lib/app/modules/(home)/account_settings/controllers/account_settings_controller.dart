import 'package:clinic_ai/models/user_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingsController extends GetxController {
  //TODO: Implement AccountSettingsController
  final user = Users().obs;

  final count = 0.obs;
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

    void increment() => count.value++;
  }
