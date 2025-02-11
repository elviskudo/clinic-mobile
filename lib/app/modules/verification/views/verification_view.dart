import 'package:clinic_ai/app/modules/home/controllers/home_controller.dart';
import 'package:clinic_ai/components/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/verification_controller.dart';

class VerificationView extends GetView<VerificationController> {
  const VerificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

    final translations = {
      'verif': 'Verification code'.obs,
      'enterVerif': 'Enter the verification code that we have sent\nto the email:'.obs,
      'recieveOtp': "Didn't recieve the OTP?".obs,
      'verif2': 'Verification'.obs,
    };
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Logo',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  LanguageSelector(
                    controller: homeController,
                    translationData: translations,
                  )
                ],
              ),
              const Spacer(flex: 1),
              Obx(
                () => Center(
                  child: Column(
                    children: [
                      Text(
                        translations["verif"]!.value,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        translations["enterVerif"]!.value
                            .tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF727970),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      OTPFields(),
                      const SizedBox(height: 8),
                      Obx(() => controller.isError.value
                          ? Text(
                              controller.errorMessage.value,
                              style: GoogleFonts.inter(
                                color: const Color(0xFFBA1A1A),
                                fontSize: 12,
                              ),
                            )
                          : const SizedBox.shrink()),
                      const SizedBox(height: 24),
                      _buildResendSection(translations["recieveOtp"]!.value),
                      const SizedBox(height: 32),
                      _buildVerificationButton(translations["verif2"]!.value),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

 
  Widget _buildResendSection(String? recieveOtp) {
    return Column(
      children: [
        Text(
          recieveOtp!,
          style: GoogleFonts.inter(
            color: const Color(0xFF727970),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        TextButton(
          onPressed: () => controller.resendOTP(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Resending'.tr,
            style: GoogleFonts.inter(
              color: const Color(0xFF35693E),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationButton(String? verif) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => controller.verifyOTP(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF35693E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          verif!,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class OTPFields extends GetView<VerificationController> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        6,
        (index) => Container(
          width: 48,
          height: 56,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Obx(
            () => TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                counterText: '',
                errorStyle: const TextStyle(height: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: controller.isError.value
                        ? const Color(0xFFBA1A1A)
                        : const Color(0xFF727970),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: controller.isError.value
                        ? const Color(0xFFBA1A1A)
                        : const Color(0xFF727970),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF35693E),
                    width: 1.5,
                  ),
                ),
                filled: true,
                fillColor: controller.isError.value
                    ? const Color(0xFFBA1A1A).withOpacity(0.08)
                    : Colors.white,
              ),
              onChanged: (value) {
                if (value.length == 1) {
                  controller.setDigit(index, value);
                  if (index < 5) {
                    FocusScope.of(context).nextFocus();
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
