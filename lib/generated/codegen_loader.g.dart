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
  "patient": "Patient",
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
    "label": "Full name",
    "placeholder": "Your full name.",
    "empty": "Please enter your full name."
  },
  "email_field": {
    "placeholder": "Your email address.",
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
    "invalid": "Password must contains at least 1 lowercase, uppercase, number, and special character",
    "placeholder": "Enter your password (min 8 characters).",
    "criteria": "• Should contain at least one upper case\n• Should contain at least one lower case\n• Should contain at least one digit\n• Should contain at least one special character"
  },
  "new_password_field": {
    "label": "Password Baru",
    "empty": "@:empty",
    "invalid": "@:invalid",
    "placeholder": "@:placeholder",
    "criteria": "@:password_field.criteria"
  },
  "new_password_error": "Cannot change password, please try again later.",
  "new_password_succeed": "Password changed successfully!",
  "confirmation_password_field": {
    "label": "Confirmation Password",
    "invalid": "Confirmation password must be same as password."
  },
  "verification": "Verification",
  "verification_success": {
    "title": "Verification Successful",
    "microcopy": "Currently redirecting to the main page, you can check your health after this!"
  },
  "verification_error": "Account verification failed. Try to resend otp code.",
  "verification_invalid": "Please enter a valid verification code.",
  "verify": "Verify",
  "resend": "Resend",
  "resend_sending": "Resending otp code...",
  "resend_notice": "We've resend the otp, don't forget to check your email!",
  "resend_error_notice": "Cannot resend the otp, please retry in a moment.",
  "page_verification_title": "@:verification",
  "page_verification_desc": "Enter the verification code (OTP) that we have sent to your email.",
  "page_verification_resend_notice": "Did'nt recieve the verification code yet?",
  "home": "Home",
  "home_greet_title": "Welcome to {clinic} {name}!",
  "home_greet_desc": "How's Your health?",
  "histories": "Histories",
  "account": "Account",
  "account_settings": "Account Settings",
  "account_settings_link": "View your account settings",
  "page_account_settings": {
    "change_profile_photo": "Change photo profile",
    "change_profile_photo_error": "Cannot change photo profile, please try again later.",
    "change_profile_photo_succeed": "Photo profile changed!"
  },
  "media_picker_list_tile": {
    "gallery": "Pick image from gallery",
    "camera": "Capture image with camera"
  },
  "change_password_error": "Cannot change password. Please try again.",
  "pick_media_error": "Cannot update photo profile, there is problem with your file.\nPlease pick the right image file!",
  "dark_mode": "Dark Mode",
  "language": "Language",
  "histories_tile_title": "@:histories",
  "histories_tile_subtitle": "Doctor's appointments and purchases",
  "lang_tile_title": "@:language",
  "help_tile_title": "Help Center",
  "help_tile_subtitle": "General help, FAQs, Contact us",
  "feedback_tile_title": "Send Feedback",
  "feedback_tile_subtitle": "Give some feedback",
  "term_tile_title": "Term and Conditions",
  "policy_tile_title": "Privacy Policy",
  "profile_tile_title": "Personal Data",
  "profile_tile_subtitle": "Biodata, Addresses, Diagnose",
  "account_tile_title": "@:account",
  "account_tile_subtitle": "Change password",
  "notifications_tile_title": "Notifications",
  "signout_tile_title": "Sign out",
  "place_of_birth_field": {
    "label": "Place of birth",
    "placeholder": "Your place of birth"
  },
  "date_of_birth_field": {
    "label": "Date of birth",
    "placeholder": "Your date of birth"
  },
  "gender_field": {
    "label": "Gender",
    "placeholder": "Select gender"
  },
  "nik_field": {
    "label": "ID Card Number (NIK)",
    "placeholder": "Your id card number (NIK)"
  },
  "address_field": {
    "label": "Address",
    "placeholder": "Your address..."
  },
  "postal_code_field": {
    "label": "Postal Code",
    "placeholder": "Your postal code"
  },
  "responsible_costs_field": {
    "label": "Responsible for Costs",
    "placeholder": "Choose responsible cost"
  },
  "blood_type_field": {
    "label": "Blood Type",
    "placeholder": "Select blood type"
  },
  "city_field": {
    "label": "City",
    "placeholder": "Select city"
  }
};
static const Map<String,dynamic> id = {
  "offline": "Sepertinya kamu sedang offline, nyalakan mobile data atau wi-fi untuk tersambung kembali.",
  "or": "Atau",
  "patient": "Pasien",
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
    "invalid": "Password harus memiliki sedikitnya 1 huruf kecil, huruf besar, angka, dan karakter khusus.",
    "placeholder": "Masukkan password kamu (minimal 8 karakter).",
    "criteria": "• Perlu setidaknya satu huruf besar\n• Perlu setidaknya satu huruf kecil\n• Perlu setidaknya satu angka\n• Perlu setidaknya satu karakter khusus"
  },
  "new_password_field": {
    "label": "Password Baru",
    "empty": "@:empty",
    "invalid": "@:invalid",
    "placeholder": "@:placeholder",
    "criteria": "@:password_field.criteria"
  },
  "new_password_error": "Gagal mengganti kata sandi, coba lagi setelah ini.",
  "new_password_succeed": "Berhasil mengganti kata sandi!",
  "confirmation_password_field": {
    "label": "Konfirmasi Password",
    "invalid": "Konfirmasi password harus sama dengan password."
  },
  "verification": "Verifikasi",
  "verification_success": {
    "title": "Verifikasi Berhasil",
    "microcopy": "Sedang mengarahkan ke halaman utama, kamu bisa mulai cek kesehatan setelah ini!"
  },
  "verification_error": "Verifikasi akun gagal. Coba untuk kirim ulang kode otp.",
  "verification_invalid": "Masukkan kode verifikasi yang valid.",
  "verify": "Verifikasi",
  "resend": "Kirim ulang",
  "resend_sending": "Sedang mengirim ulang kode otp...",
  "resend_notice": "Kami sudah mengirim ulang otp, jangan lupa untuk check email kamu!",
  "resend_error_notice": "Tidak bisa mengirim ulang otp, coba lagi sesaat.",
  "page_verification_title": "@:verification",
  "page_verification_desc": "Masukkan kode verifikasi (OTP) yang sudah kami kirimkan ke email kamu.",
  "page_verification_resend_notice": "Belum menerima kode verifikasi?",
  "home": "Beranda",
  "home_greet_title": "Selamat datang di {clinic} {name}!",
  "home_greet_desc": "Bagaimana kondisi kesehatanmu?",
  "histories": "Riwayat",
  "account": "Akun",
  "account_settings": "Pengaturan Akun",
  "account_settings_link": "Cek pengaturan akun kamu",
  "page_account_settings": {
    "change_profile_photo": "Ubah foto profile",
    "change_profile_photo_error": "Tidak bisa mengubah foto profile, coba kembali setelah ini.",
    "change_profile_photo_succeed": "Foto profile berhasil diganti!"
  },
  "change_password_error": "Gagal mengubah password. Silahkan untuk mencoba lagi.",
  "media_picker_list_tile": {
    "gallery": "Pilih gambar dari galeri",
    "camera": "Tangkap gambar dengan kamera"
  },
  "pick_media_error": "Gagal update photo profile, terdapat masalah dengan file kamu.\nPastikan kamu memilih file gambar yang sesuai!",
  "language": "Bahasa",
  "dark_mode": "Mode Malam",
  "histories_tile_title": "@:histories",
  "histories_tile_subtitle": "Appointment doktor dan pembelian",
  "lang_tile_title": "@:language",
  "help_tile_title": "Pusat Bantuan",
  "help_tile_subtitle": "Bantuan umum, FAQs, Kontak kami",
  "feedback_tile_title": "Kirim Masukan",
  "feedback_tile_subtitle": "Beri beberapa masukan",
  "term_tile_title": "Syarat dan Ketentian",
  "policy_tile_title": "Kebijakan Privasi",
  "profile_tile_title": "Data Pribadi",
  "profile_tile_subtitle": "Biodata, Alamat, Diagnosa",
  "account_tile_title": "@:account",
  "account_tile_subtitle": "Ubah password",
  "notifications_tile_title": "Notifikasi",
  "signout_tile_title": "Keluar",
  "place_of_birth_field": {
    "label": "Tempat lahir",
    "placeholder": "Tempat lahir kamu"
  },
  "date_of_birth_field": {
    "label": "Tanggal Lahir",
    "placeholder": "Tanggal lahir kamu"
  },
  "gender_field": {
    "label": "Jenis Kelamin",
    "placeholder": "Pilih jenis kelamin"
  },
  "nik_field": {
    "label": "No. KTP (NIK)",
    "placeholder": "No. KTP (NIK) kamu"
  },
  "address_field": {
    "label": "Alamat",
    "placeholder": "Masukkan alamat kamu..."
  },
  "postal_code_field": {
    "label": "Kode Pos",
    "placeholder": "Kode pos kamu"
  },
  "responsible_costs_field": {
    "label": "Biaya Penanganan",
    "placeholder": "Pilih biaya penanganan"
  },
  "blood_type_field": {
    "label": "Golongan Darah",
    "placeholder": "Pilih golongan darah"
  },
  "city_field": {
    "label": "Kota",
    "placeholder": "Pilih kota"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "id": id};
}
