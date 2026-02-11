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

  // --- FUNGSI LOGIN EMAIL ---
  Future<void> signInWithEmail() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Email dan password harus diisi Cuk!',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      // Bersihkan input
      final email = emailController.text.replaceAll(RegExp(r'\s+'), '');
      final password = passwordController.text.replaceAll(RegExp(r'\s+'), '');

      print('DEBUG: Login Email ke BE...');

      final response = await http.post(
        Uri.parse('https://be-clinic-rx7y.vercel.app/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('Status Login: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Sesuaikan dengan struktur JSON backend lu (biasanya 'data' atau 'result')
        // Kalau pake interceptor NestJS biasanya kebungkus di 'data'
        final backendData = responseData['data'] ?? responseData['result'];

        if (backendData != null) {
          await _handlePostLogin(backendData); // Panggil fungsi handler pintar
        } else {
          throw 'Data backend kosong Cuk!';
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

  // --- FUNGSI LOGIN GOOGLE ---
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      // 1. Google Sign In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return; // User batal login
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 2. Firebase Auth
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final String? idToken = await userCredential.user?.getIdToken(true);

      if (idToken == null) throw 'Gagal dapet ID Token Firebase';

      // 3. Kirim ke Backend NestJS
      print("DEBUG: Kirim Token Google ke BE...");
      final response = await http.post(
        Uri.parse('https://be-clinic-rx7y.vercel.app/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idToken': idToken}),
      );

      print('Status Backend: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Cek struktur JSON (data/result)
        final backendData = responseData['data'] ?? responseData['result'];

        if (backendData != null) {
          await _handlePostLogin(backendData); // Panggil fungsi handler pintar
        } else {
          throw 'Objek data di respon kosong Cuk!';
        }
      } else {
        throw 'Backend nolak: ${response.body}';
      }
    } catch (e) {
      print('Login Google Error: $e');
      Get.snackbar(
        'Error',
        'Gagal login Google: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- LOGIC NAVIGASI PINTAR (UTAMA) ---
  Future<void> _handlePostLogin(Map<String, dynamic> backendData) async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil User Data
    final userData = backendData['user'] ?? {};
    final String accessToken = (backendData['access_token'] ?? '').toString();

    // 1. AMBIL ROLE DARI RESPONSE BACKEND (Kunci Utama!)
    // Pastikan backend lu ngirim field 'role' di dalam objek user
    String role = (userData['role'] ?? 'member').toString().toLowerCase();

    print("✅ LOGIN SUKSES!");
    print("👤 Nama: ${userData['name']}");
    print("🔑 Role Deteksi: $role");

    // 2. Simpan ke SharedPreferences
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('userId', (userData['id'] ?? '').toString());
    await prefs.setString('name', (userData['name'] ?? 'User').toString());
    await prefs.setString('userRole', role); // Simpan role buat sesi
    await prefs.setBool('isLoggedIn', true);

    // 3. NAVIGASI BERDASARKAN ROLE
    if (role == 'doctor') {
      print("🚀 Arahkan ke Dashboard Dokter");
      Get.offAllNamed(Routes.HOME_DOCTOR);
    } else {
      print("🏠 Arahkan ke Home Pasien");
      Get.offAllNamed(Routes.HOME);
    }
  }
}
