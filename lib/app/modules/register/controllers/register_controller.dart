import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/helper/PasswordHasher.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final agreeToTerms = false.obs;
  final isLoading = false.obs;

  final supabase = Supabase.instance.client;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  String formatPhoneNumber(String phone) {
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = cleanPhone.substring(1);
    }
    if (!cleanPhone.startsWith('62')) {
      cleanPhone = '62$cleanPhone';
    }
    return '+$cleanPhone';
  }

  Future<void> register() async {
    try {
      if (!agreeToTerms.value) {
        Get.snackbar(
          'Error',
          'Please agree to the terms and conditions',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        Get.snackbar(
          'Error',
          'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      isLoading.value = true;
      final hashedPassword = await PasswordHasher.hashPassword(passwordController.text);
      final formattedPhoneNumber = formatPhoneNumber(phoneController.text);
      String userId = Uuid().v4();
      
      // Store user data temporarily
      Map<String, dynamic> userData = {
        'id': userId,
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'password': hashedPassword,
        'phone_number': formattedPhoneNumber,
        'access_token': '',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Send OTP
      EmailOTP.sendOTP(email: emailController.text.trim());

      // Navigate to verification page with user data
      Get.toNamed(
        Routes.VERIVICATION,
        arguments: {
          'userData': userData,
          'email': emailController.text.trim(),
        },
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.toNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}