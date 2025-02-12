import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPageController extends GetxController {
  static const String ONBOARDING_SHOWN_KEY = 'onboarding_shown';

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void loginWithGoogle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ONBOARDING_SHOWN_KEY, true); // Mark onboarding as shown
    // Implement Google login logic here
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
