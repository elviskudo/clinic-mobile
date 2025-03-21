import 'package:clinic_ai/app/modules/(home)/home/controllers/home_controller.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/components/button.dart';
import 'package:clinic_ai/components/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/onboarding_page_controller.dart';

class OnboardingPageView extends GetView<OnboardingPageController> {
  const OnboardingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final onBoardCtrl = Get.put(OnboardingPageController());
    final translations = {
      'welcome': 'Welcome to Clinic'.obs,
      'description': 'Enjoy the convenience of scheduling\n'
              'medical appointments anytime, anywhere\n'
              'with our AI-generated app...'
          .obs,
      'buttonText': 'Sign in with Google'.obs,
      'footer': 'Dibuat dengan Flutter'.obs,
    };
    return Scaffold(
      backgroundColor: Color(0xffF7FBF2),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row with Logo and Language Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Logo',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  LanguageSelector(
                    controller: controller,
                    translationData: translations,
                  ),
                ],
              ),
              Gap(40),

              // Illustration
              Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Image.asset(
                    'assets/images/logoOnboarding.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Gap(40),

              // Welcome Text
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Clinic',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF35693E),
                      ),
                    ),
                    Gap(8),
                    Obx(() => Text(
                          translations['description']!.value,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF727970),
                          ),
                        )),
                  ],
                ),
              ),
              Gap(40),
              // Sign in with Google Button
              PrimaryButton(
                  text: 'Login',
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool(
                        OnboardingPageController.ONBOARDING_SHOWN_KEY, true);
                    Get.offAllNamed(Routes.LOGIN);
                  }),
              
              
            ],
          ),
        ),
      ),
    );
  }
}
