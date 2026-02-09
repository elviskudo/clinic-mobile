import 'package:clinic_ai/app/modules/(home)/home/controllers/home_controller.dart';
import 'package:clinic_ai/app/modules/(auth)/login/controllers/login_controller.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/components/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

    return Scaffold(
      backgroundColor: const Color(0xffF7FBF2), // Pakai warna onboarding lu
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row (Logo & Language)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Clinic AI', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: const Color(0xFF35693E))),
                  LanguageSelector(controller: homeController, translationData: <String, RxString>{}),
                ],
              ),
              const Gap(30),

              // Illustration (Gaya Onboarding)
              Center(
                child: Image.asset('assets/images/logoOnboarding.png', height: 180, fit: BoxFit.contain),
              ),
              const Gap(30),

              Text('Welcome Back', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF35693E))),
              Text('Enter your details to continue', style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF727970))),
              const Gap(24),

              // Email Field
              _buildTextField(
                controller: controller.emailController,
                hint: 'Email Address',
                icon: Icons.email_outlined,
              ),
              const Gap(16),

              // Password Field
              Obx(() => _buildTextField(
                controller: controller.passwordController,
                hint: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
                obscureText: !controller.isPasswordVisible.value,
                onIconPressed: () => controller.isPasswordVisible.toggle(),
              )),
              
              const Gap(24),

              // Login Button
              Obx(() => SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () => controller.signInWithEmail(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF35693E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: controller.isLoading.value 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              )),

              const Gap(16),
              const Center(child: Text('OR', style: TextStyle(color: Colors.grey))),
              const Gap(16),

              // Google Button
              _LoginButton(
                onPressed: () => controller.signInWithGoogle(),
                iconUrl: 'assets/icons/google.png',
                text: 'Continue with Google',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onIconPressed,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF35693E)),
        suffixIcon: isPassword 
            ? IconButton(icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility), onPressed: onIconPressed)
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
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
