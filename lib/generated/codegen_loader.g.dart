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
  "signin": "Sign in",
  "signin_error": "Failed to sign in. Make sure your credentials is valid before trying again.",
  "page_signin_title": "Hi, Welcome!",
  "page_signin_desc": "Hello, how are you? not feeling great? Don't worry we got you covered, check your health easily!",
  "page_signin_no_account": "Don't have an account yet?",
  "signup": "Create an account",
  "verification": "Verification",
  "email_field": {
    "placeholder": "Alamat email kamu.",
    "empty": "Please enter your email address.",
    "invalid": "Please enter a valid email address (e.g., user@example.com).",
    "other": ""
  },
  "password_field": {
    "empty": "Please enter your password.",
    "invalid": "Password must be at least 8 characters or more & make sure to match the criteria.",
    "placeholder": "Enter your password (min 8 characters).",
    "criteria": "• Should contain at least one upper case\n• Should contain at least one lower case\n• Should contain at least one digit\n• Should contain at least one special character",
    "other": ""
  },
  "onboarding_title": "Welcome to Clinic!",
  "onboarding_desc": "Experience the ease of scheduling medical checkup anytime, anywhere with our app.",
  "home_greet_title": "Greetings {name}!",
  "home_greet_desc": "How's Your health?"
};
static const Map<String,dynamic> id = {
  "offline": "Sepertinya kamu sedang offline, nyalakan mobile data atau wi-fi untuk tersambung kembali.",
  "or": "Atau",
  "signin": "Masuk",
  "signin_error": "Gagal masuk. Pastikan kredensial kamu valid sebelum mengulangi pembuatan akun.",
  "page_signin_title": "Hi, Selamat Datang!",
  "page_signin_desc": "Halo, apakabar? kurang enak badan? Jangan khawatir, cek kesehatanmu dengan mudah!",
  "page_signin_no_account": "Sudah punya akun?",
  "signup": "Buat akun",
  "verification": "Verifikasi",
  "email_field": {
    "placeholder": "Alamat email kamu.",
    "empty": "Silahkan masukkan alamat email kamu.",
    "invalid": "Silahkan masukkan alamat email yang valid (contoh, user@example.com).",
    "other": ""
  },
  "password_field": {
    "empty": "Silahkan masukkan password kamu.",
    "invalid": "Password harus sedikitnya 8 karakter atau lebih & pastikan sesuai dengan kriteria.",
    "placeholder": "Masukkan password kamu (minimal 8 karakter).",
    "criteria": "• Perlu setidaknya satu huruf besar\n• Perlu setidaknya satu huruf kecil\n• Perlu setidaknya satu angka\n• Perlu setidaknya satu karakter khusus",
    "other": ""
  },
  "page_onboarding_title": "Selamat Datang di Clinic!",
  "page_onboarding_desc": "Rasakan kemudahan membuat jadwal pemeriksaan medis kapan saja, dimana saja dengan aplikasi kami.",
  "home_greet_title": "Selamat datang {name}!",
  "home_greet_desc": "Bagaimana kondisi kesehatanmu?"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "id": id};
}
