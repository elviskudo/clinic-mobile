import 'package:clinic_ai/app/modules/(home)/home/controllers/home_controller.dart';
import 'package:clinic_ai/app/modules/(auth)/login/controllers/login_controller.dart';
import 'package:clinic_ai/components/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

    final translations = {
      'welcome': 'Welcome Back 👋'.obs,
      'subtitle': 'Your health companion is here to help you feel better.'.obs,
      'google': 'Continue with Google'.obs,
      'apple': 'Continue with Apple'.obs,
      'email': 'Continue with Email'.obs,
      'noAccount': 'Don\'t have an account?'.obs,
      'signUp': 'Sign up'.obs,
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Language Selector with improved styling
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: LanguageSelector(
                      controller: homeController,
                      translationData: translations,
                    ),
                  ),
                ),

                const Gap(48),

                // Welcome Text
                Obx(() => Text(
                      translations['welcome']!.value,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    )),

                const Gap(16),

                // Subtitle
                Obx(() => Text(
                      translations['subtitle']!.value,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    )),

                const Gap(48),

                // Social Login Buttons
                _LoginButton(
                  onPressed: () => controller.signInWithGoogle(),
                  iconUrl: 'assets/icons/google.png',
                  text: translations['google']!.value,
                ),

                const Gap(16),

                _LoginButton(
                  onPressed: () {},
                  iconUrl: 'assets/icons/ic_baseline-apple.png',
                  text: translations['apple']!.value,
                ),

                const Gap(16),

                Gap(100),

                // Sign Up Link
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String iconUrl;
  final String text;
  final bool isPrimary;

  const _LoginButton({
    required this.onPressed,
    required this.iconUrl,
    required this.text,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Image.asset(
          iconUrl,
          width: 28,
          height: 28,
        ),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF2563EB) : Colors.white,
          foregroundColor: isPrimary ? Colors.white : Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isPrimary ? Colors.transparent : Colors.grey[300]!,
            ),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
