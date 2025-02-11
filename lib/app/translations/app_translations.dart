// lib/app/translations/app_translations.dart

import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'Verification code': 'Verification code',
          'Enter the verification code that we have sent to the email:':
              'Enter the verification code that we have sent to the email:',
          'Wrong OTP code entered!': 'Wrong OTP code entered!',
          'Didn\'t receive the OTP?': 'Didn\'t receive the OTP?',
          'Resending': 'Resending',
          'Verification': 'Verification',
        },
        'id': {
          'Verification code': 'Kode Verifikasi',
          'Enter the verification code that we have sent to the email:':
              'Masukkan kode verifikasi yang telah kami kirim ke email:',
          'Wrong OTP code entered!': 'Kode OTP salah!',
          'Didn\'t receive the OTP?': 'Tidak menerima OTP?',
          'Resending': 'Mengirim ulang',
          'Verification': 'Verifikasi',
        },
      };
}