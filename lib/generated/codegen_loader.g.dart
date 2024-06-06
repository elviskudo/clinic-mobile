// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "offline": "Looks like you are offline, enable mobile data or wi-fi to reconnect.",
  "or": "Or",
  "page_onboarding_title": "Welcome to Clinic!",
  "page_onboarding_desc": "Experience the ease of scheduling medical checkup anytime, anywhere with our app.",
  "signin": "Sign in",
  "signin_error": "Failed to sign in. Make sure you have an account before!",
  "page_signin_title": "Hi, Welcome!",
  "page_signin_desc": "Hello, how are you? not feeling great? Don't worry we got you covered, check your health easily!",
  "page_signin_no_account": "Don't have an account yet?",
  "signup": "Create an account",
  "signup_error": "Failed to create an account. Re-check your data & make sure it is valid! Or try to sign in.",
  "page_signup_title": "@:signup",
  "page_signup_desc": "Start with make an account and then you can check your health anytime, anywhere!",
  "page_signup_had_account": "Already have an account yet?",
  "name_field": {
    "label": "Nama lengkap",
    "placeholder": "Nama lengkap kamu.",
    "empty": "Silahkan masukkan nama lengkap kamu."
  },
  "email_field": {
    "placeholder": "Alamat email kamu.",
    "empty": "Please enter your email address.",
    "invalid": "Please enter a valid email address (e.g., user@example.com)."
  },
  "phone_field": {
    "label": "Phone Number",
    "placeholder": "Your phone number.",
    "empty": "Please enter your phone number.",
    "invalid": "Please enter a valid phone number."
  },
  "password_field": {
    "empty": "Please enter your password.",
    "invalid": "Password must be at least 8 characters or more & make sure to match the criteria.",
    "placeholder": "Enter your password (min 8 characters).",
    "criteria": "• Should contain at least one upper case\n• Should contain at least one lower case\n• Should contain at least one digit\n• Should contain at least one special character"
  },
  "confirmation_password_field": {
    "label": "Confirmation Password",
    "invalid": "Confirmation password must be same as password."
  },
  "verification": "Verification",
  "verification_error": "Account verification failed. Try to resend otp code.",
  "verification_empty": "Please enter a valid verification code.",
  "verify": "Verify",
  "resend": "Resend",
  "resend_notice": "We've resend the otp, don't forget to check your email!",
  "resend_error_notice": "Cannot resend the otp, please retry in a moment.",
  "page_verification_title": "@:verification",
  "page_verification_desc": "Enter the verification code (OTP) that we have sent to your email.",
  "page_verification_resend_notice": "Did'nt recieve the verification code yet?",
  "home_greet_title": "Greetings {name}!",
  "home_greet_desc": "How's Your health?"
};
static const Map<String,dynamic> id = {
  "offline": "Sepertinya kamu sedang offline, nyalakan mobile data atau wi-fi untuk tersambung kembali.",
  "or": "Atau",
  "page_onboarding_title": "Selamat Datang di Clinic!",
  "page_onboarding_desc": "Rasakan kemudahan membuat jadwal pemeriksaan medis kapan saja, dimana saja dengan aplikasi kami.",
  "signin": "Masuk",
  "signin_error": "Gagal masuk. Pastikan kamu sudah punya akun sebelumnya!",
  "page_signin_title": "Hi, Selamat Datang!",
  "page_signin_desc": "Halo, apakabar? kurang enak badan? Jangan khawatir, cek kesehatanmu dengan mudah!",
  "page_signin_no_account": "Sudah punya akun?",
  "signup": "Buat akun",
  "signup_error": "Gagal membuat akun. Check lagi data kamu & pastikan sudah valid! Atau coba untuk masuk.",
  "page_signup_title": "@:signup",
  "page_signup_desc": "Mulai dengan membuat akun dan kamu bisa cek kesehatan kapanpun, dimanapun!",
  "page_signup_had_account": "Sudah punya akun?",
  "name_field": {
    "label": "Nama lengkap",
    "placeholder": "Nama lengkap kamu.",
    "empty": "Silahkan masukkan nama lengkap kamu."
  },
  "email_field": {
    "placeholder": "Alamat email kamu.",
    "empty": "Silahkan masukkan alamat email kamu.",
    "invalid": "Silahkan masukkan alamat email yang valid (contoh, user@example.com)."
  },
  "phone_field": {
    "label": "No. Handphone",
    "placeholder": "No. handphone kamu.",
    "empty": "Silahkan masukkan no. hp kamu.",
    "invalid": "Silahkan masukkan no. hp yang valid."
  },
  "password_field": {
    "empty": "Silahkan masukkan password kamu.",
    "invalid": "Password harus sedikitnya 8 karakter atau lebih & pastikan sesuai dengan kriteria.",
    "placeholder": "Masukkan password kamu (minimal 8 karakter).",
    "criteria": "• Perlu setidaknya satu huruf besar\n• Perlu setidaknya satu huruf kecil\n• Perlu setidaknya satu angka\n• Perlu setidaknya satu karakter khusus"
  },
  "confirmation_password_field": {
    "label": "Konfirmasi Password",
    "invalid": "Konfirmasi password harus sama dengan password."
  },
  "verification": "Verifikasi",
  "verification_error": "Verifikasi akun gagal. Coba untuk kirim ulang kode otp.",
  "verification_empty": "Masukkan kode verifikasi yang valid.",
  "verify": "Verifikasi",
  "resend": "Kirim ulang",
  "resend_notice": "Kami sudah mengirim ulang otp, jangan lupa untuk check email kamu!",
  "resend_error_notice": "Tidak bisa mengirim ulang otp, coba lagi sesaat.",
  "page_verification_title": "@:verification",
  "page_verification_desc": "Masukkan kode verifikasi (OTP) yang sudah kami kirimkan ke email kamu.",
  "page_verification_resend_notice": "Belum menerima kode verifikasi?",
  "home_greet_title": "Selamat datang {name}!",
  "home_greet_desc": "Bagaimana kondisi kesehatanmu?"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "id": id};
}
