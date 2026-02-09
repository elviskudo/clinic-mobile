import 'dart:convert';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        '997166988553-dqvtq3utmlsur1rsfhj33v7mmk0u55lc.apps.googleusercontent.com',
  );

  Future<void> signInWithEmail() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Email dan password harus diisi Cuk!',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      // Bersihkan email & password dari spasi, newline, dan tab
      final email = emailController.text.replaceAll(RegExp(r'\s+'), '');
      final password = passwordController.text.replaceAll(RegExp(r'\s+'), '');

      print('DEBUG: Mencoba login ke BE...');
      print('Payload Clean: {"email": "$email", "password": "$password"}');

      final response = await http.post(
        Uri.parse('https://be-clinic-rx7y.vercel.app/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('Status Login Email: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final backendData = responseData['data'];

        if (backendData != null) {
          final prefs = await SharedPreferences.getInstance();

          // Simpan data login
          String token = (backendData['access_token'] ?? '').toString();
          final userData = backendData['user'] ?? {};

          await prefs.setString('accessToken', token);
          await prefs.setString('userId', (userData['id'] ?? '').toString());
          await prefs.setString(
              'name', (userData['name'] ?? 'User').toString());
          await prefs.setBool('isLoggedIn', true);

          print("LOGIN EMAIL SUKSES: ${userData['name']}");
          Get.offAllNamed(Routes.HOME);
        }
      } else {
        final errorData = json.decode(response.body);
        throw errorData['message'] ??
            'Gagal login (Error ${response.statusCode})';
      }
    } catch (e) {
      print('Login Email Error: $e');
      Get.snackbar('Login Failed', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      // 1. Trigger Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 2. Kredensial Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 3. Login Firebase & Ambil ID Token Terbaru (Force Refresh agar tidak kadaluarsa)
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final String? idToken = await userCredential.user?.getIdToken(true);

      if (idToken == null) throw 'Gagal mendapatkan ID Token dari Firebase';

      // 4. Kirim ID Token ke Backend NestJS (Production/Vercel)
      final response = await http.post(
        Uri.parse('https://be-clinic-rx7y.vercel.app/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idToken': idToken}),
      );

      print('Status Backend: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(
            "DEBUG RESPONSE: $responseData"); // LIHAT INI DI TERMINAL LOKAT LU!

        final backendData = responseData['data'];
        if (backendData != null) {
          final userData = backendData['user'] ?? {};
          final prefs = await SharedPreferences.getInstance();

          // Gunakan null-aware operator yang lebih longgar
          String token = (backendData['access_token'] ?? '').toString();
          String uid = (userData['id'] ?? '').toString();
          String name = (userData['name'] ?? 'User').toString();

          print("TOKEN NYAMPE: $token");
          print("UID NYAMPE: $uid");

          await prefs.setString('accessToken', token);
          await prefs.setString('userId', uid);
          await prefs.setString('name', name);
          await prefs.setBool('isLoggedIn', true);

          Get.offAllNamed(Routes.HOME);
        } else {
          throw 'Objek data di respon kosong Cuk!';
        }
      }
    } catch (e) {
      print('Login Error: $e');
      Get.snackbar(
        'Error',
        'Gagal login: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
