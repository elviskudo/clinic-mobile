import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:get/get.dart';

class VerificationController extends GetxController {
  final otpDigits = List.generate(6, (index) => ''.obs);
  final isError = false.obs;
  final errorMessage = ''.obs;
  
  void setDigit(int index, String value) {
    otpDigits[index].value = value;
    // Reset error state when user starts typing again
    if (isError.value) {
      isError.value = false;
      errorMessage.value = '';
    }
  }

  void clearDigits() {
    for (var digit in otpDigits) {
      digit.value = '';
    }
    isError.value = false;
    errorMessage.value = '';
  }

  void verifyOTP() {
    String otp = otpDigits.map((digit) => digit.value).join();
    // Mock verification - replace with actual verification logic
    if (otp == '666666') {
      Get.toNamed(Routes.VERIVICATION_SUCCESS);
    } else {
      isError.value = true;
      errorMessage.value = 'Wrong OTP code entered!'.tr;
    }
  }

  void resendOTP() {
    clearDigits();
    // Add your OTP resending logic here
  }
}