import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationSuccessView extends StatelessWidget {
  const VerificationSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Redirect ke halaman home setelah 2 detik
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/home'); // Pastikan '/home' sesuai dengan nama rute home di aplikasi kamu
    });

    return WillPopScope(
      onWillPop: () async {
        Get.offAllNamed('/home'); // Mencegah kembali ke halaman sebelumnya, langsung ke home
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FBF2),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 64,
                  color: const Color(0xFF35693E),
                ),
                const SizedBox(height: 24),
                Text(
                  'Verification Successful!'.tr,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Currently redirecting to the main page, check your health immediately after this!'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF727970),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
