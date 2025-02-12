import 'package:clinic_ai/app/modules/home/controllers/home_controller.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/color/color.dart';
import 'package:clinic_ai/components/button.dart';
import 'package:clinic_ai/components/input.dart';
import 'package:clinic_ai/components/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

    final translations = {
      'createAccount': 'Hi, Welcome!👋'.obs,
      'startDescription':
          'Hello, how are you? not feeling great? Dont worry we got you covered, check your health easily!'
              .obs,
      'google': 'Google'.obs,
      'orByEmail': 'Or by email'.obs,
      'name': 'Name'.obs,
      'fullName': 'Your full name'.obs,
      'email': 'E-mail'.obs,
      'enterEmail': 'Enter your email'.obs,
      'phone': 'No. Telp'.obs,
      'enterPhone': 'Enter a phone number'.obs,
      'password': 'Password'.obs,
      'confirmPassword': 'Confirm Password'.obs,
      'agreeToTerms': 'I agree to the '.obs,
      'termsAndConditions': ' terms and conditions'.obs,
      'register': 'Register'.obs,
      'haveAccount': 'Dont have an account yet?'.obs,
      // 'login': 'Login'.obs,
    };

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: LanguageSelector(
                  controller: homeController,
                  translationData: translations,
                ),
              ),

              const SizedBox(height: 24),

              // Title and Subtitle dengan Obx
              Obx(() => Text(
                    translations['createAccount']!.value ?? "",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              const SizedBox(height: 8),
              Obx(() => Text(
                    translations['startDescription']!.value ?? "",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  )),

              const SizedBox(height: 24),

              // Social Login Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.apple),
                      label: Text('Apple'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async =>
                          await controller.signInWithGoogle(),
                      icon: const Icon(Icons.book),
                      label:
                          Obx(() => Text(translations['google']!.value ?? "")),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Obx(() => Text(
                        translations['orByEmail']!.value ?? "",
                        style: TextStyle(color: Colors.grey[600]))),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),

              const SizedBox(height: 24),

              CustomInput(
                controller: controller.emailController,
                labelText: translations['email']!.value,
                hintText: translations['enterEmail']!.value,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              CustomInput(
                controller: controller.passwordController,
                labelText: translations['password']!.value,
                hintText: 'Enter your password',
                isPassword: true,
                passwordVisible: controller.isPasswordHidden.value,
                onToggleVisibility: controller.togglePasswordVisibility,
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 24),

              PrimaryButton(
                  text: 'Login',
                  onPressed: () async => await controller.login()),

              Gap(48),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Text(
                          translations['haveAccount']!.value ?? "",
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        )),
                    InkWell(
                      onTap: () => Get.toNamed(Routes.REGISTER),
                      child: Text(
                        ' Register here',
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
