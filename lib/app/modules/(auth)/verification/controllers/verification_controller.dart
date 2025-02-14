import 'dart:async';

import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:email_otp/email_otp.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerificationController extends GetxController {
  final otpDigits = List.generate(6, (index) => ''.obs);
  final isError = false.obs;
  final errorMessage = ''.obs;
  final supabase = Supabase.instance.client;
  RxInt countdown = 120.obs; // 2 menit
  Timer? timer;

  late Map<String, dynamic> userData;
  late String userEmail;

  @override
  void onInit() {
    super.onInit();
    startCountdown();
    // Get arguments passed from register page
    final args = Get.arguments;
    userData = args['userData'];
    userEmail = args['email'];
  }

  void startCountdown() {
    countdown.value = 120;
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        t.cancel();
      }
    });
  }

  void setDigit(int index, String value) {
    otpDigits[index].value = value;
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

  Future<void> verifyOTP() async {
    String otp = otpDigits.map((digit) => digit.value).join();

    try {
      if (EmailOTP.verifyOTP(otp: otp)) {
        // Insert user data into database after successful verification
        await supabase.from('users').insert(userData);

        // Get member role id
        final roleData = await supabase
            .from('roles')
            .select('id')
            .eq('name', 'member')
            .single();

        // Assign member role to user
        await supabase.from('user_roles').insert({
          'user_id': userData['id'],
          'role_id': roleData['id'],
        });
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', userData["id"]);
        await prefs.setString('name', userData["name"]);
        await prefs.setString('email', userData["email"]);
        await prefs.setString('phone', userData["phone_number"]);

        Get.offAllNamed(Routes.VERIVICATION_SUCCESS);
      } else {
        isError.value = true;
        errorMessage.value = 'Wrong OTP code entered!'.tr;
      }
    } catch (error) {
      isError.value = true;
      errorMessage.value = error.toString();
    }
  }

  Future<void> resendOTP() async {
    clearDigits();
    await EmailOTP.sendOTP(email: userEmail);
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
