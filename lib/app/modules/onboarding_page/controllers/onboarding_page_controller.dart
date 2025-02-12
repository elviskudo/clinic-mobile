import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPageController extends GetxController {
  //TODO: Implement OnboardingPageController
  static const String ONBOARDING_SHOWN_KEY = 'isOnboardingSeen';


  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    checkOnboardingStatus();
  }

  void checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasSeenOnboarding = prefs.getBool(ONBOARDING_SHOWN_KEY) ?? false;

    if (hasSeenOnboarding) {
      Get.offAllNamed(Routes.LOGIN);
    }
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
