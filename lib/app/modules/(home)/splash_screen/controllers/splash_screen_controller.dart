


import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Tunggu 2 detik buat branding (logo splash)
    await Future.delayed(const Duration(seconds: 2));

    // Ambil status login dan role
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? userRole = prefs.getString('userRole');

    if (isLoggedIn) {
      // JIKA SUDAH LOGIN: Arahkan sesuai Role
      if (userRole == 'admin') {
        Get.offAllNamed(Routes.ADMIN_PANEL);
      } else if (userRole == 'doctor') {
        Get.offAllNamed(Routes.HOME_DOCTOR);
      } else {
        // Default untuk member/pasien
        Get.offAllNamed(Routes.HOME);
      }
    } else {
      // JIKA BELUM LOGIN: Langsung ke LOGIN (Lewati Onboarding)
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}






// import 'package:clinic_ai/app/routes/app_pages.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreenController extends GetxController {
//   static const String ONBOARDING_SHOWN_KEY = 'isOnboardingSeen';

//   @override
//   void onInit() {
//     super.onInit();
//     checkLoginStatus();
//   }

//   Future<void> checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     bool isOnboardingSeen = prefs.getBool(ONBOARDING_SHOWN_KEY) ?? false;

//     // Wait for 2 seconds before navigation
//     await Future.delayed(const Duration(seconds: 2));

//     if (!isOnboardingSeen) {
//       Get.offAllNamed(Routes.ONBOARDING_PAGE);
//     } else {
//       bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//       if (isLoggedIn) {
//         String? userRole = prefs.getString('userRole');

//         if (isLoggedIn) {
//           // If user is logged in, check their role and redirect accordingly
//           if (userRole == 'admin') {
//             Get.offAllNamed(Routes.ADMIN_PANEL);
//           } else if (userRole == 'member') {
//             Get.offAllNamed(Routes.HOME);
//           } else if (userRole == 'doctor') {
//             Get.offAllNamed(Routes.HOME_DOCTOR);
//           }
//         } else {
//           Get.offAllNamed(Routes.LOGIN);
//         }
//       } else {
//         Get.offAllNamed(Routes.LOGIN);
//       }
//     }
//   }
// }
