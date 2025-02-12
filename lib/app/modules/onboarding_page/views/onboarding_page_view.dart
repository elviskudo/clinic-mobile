import 'package:clinic_ai/app/modules/login/views/login_view.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/components/button.dart';
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
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.language, size: 16, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Text(
                          'EN',
                          style: GoogleFonts.poppins(color: Colors.grey[600]),
                        ),
                        Icon(Icons.arrow_drop_down,
                            size: 16, color: Colors.grey[600]),
                      ],
                    ),
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
                    Text(
                      'Enjoy the convenience of scheduling\n'
                      'medical appointments anytime, anywhere\n'
                      'with our AI-generated app...',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Color(0xFF727970),
                      ),
                    ),
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
              Gap(16),
              ButtonOutline(
                  text: 'Create an Account',
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool(
                        OnboardingPageController.ONBOARDING_SHOWN_KEY, true);
                    Get.offAllNamed(Routes.REGISTER);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
