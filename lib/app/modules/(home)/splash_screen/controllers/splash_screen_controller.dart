import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController {
  static const String ONBOARDING_SHOWN_KEY = 'isOnboardingSeen';

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isOnboardingSeen = prefs.getBool(ONBOARDING_SHOWN_KEY) ?? false;

    // Wait for 2 seconds before navigation
    await Future.delayed(const Duration(seconds: 2));

    if (!isOnboardingSeen) {
      Get.offAllNamed(Routes.ONBOARDING_PAGE);
    } else {
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        String? userRole = prefs.getString('userRole');

        if (isLoggedIn) {
          // If user is logged in, check their role and redirect accordingly
          if (userRole == 'admin') {
            Get.offAllNamed(Routes.ADMIN_PANEL);
          } else {
            Get.offAllNamed(Routes.HOME);
          }
        } else {
          Get.offAllNamed('/login');
        }

        
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    }
  }
}
