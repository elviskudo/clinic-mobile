// login_controller.dart
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/helper/PasswordHasher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final agreeToTerms = false.obs;
  final isLoading = false.obs;
  final supabase = Supabase.instance.client;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Email dan password harus diisi',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('Error', 'Email tidak valid',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      final response = await supabase
          .from('users')
          .select('password')
          .eq('email', emailController.text.toLowerCase())
          .single();

      if (response == null || response['password'] == null) {
        Get.snackbar(
          'Error',
          'Email tidak terdaftar',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final String storedHashedPassword = response['password'];

      // Hash the entered password and compare it with the stored hashed password
      final bool passwordMatch = await PasswordHasher.verifyPassword(
        passwordController.text,
        storedHashedPassword,
      );

      if (!passwordMatch) {
        Get.snackbar(
          'Error',
          'Password salah',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      isLoading.value = true;

      final user = await supabase
          .from('users')
          .select()
          .eq('email', emailController.text)
          .single();

      final userRole = await supabase
          .from('user_roles')
          .select()
          .eq('user_id', user['id'])
          .single();

      final roles = await supabase
          .from('roles')
          .select()
          .eq('id', userRole['role_id'])
          .single();

      final roleUsers = roles['name'] ?? 'member';

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', emailController.text);
      await prefs.setString('userId', user['id']);
      await prefs.setString('name', user['name']);
      await prefs.setString('phone', user['phone_number']);
      await prefs.setString('userRole', roleUsers);

      print('user role : $roleUsers');

      Get.snackbar(
        'Sukses',
        'Berhasil login',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        snackStyle: SnackStyle.FLOATING,
        forwardAnimationCurve: Curves.easeOut,
        reverseAnimationCurve: Curves.easeIn,
      );

      Get.offAllNamed(Routes.HOME); // Halaman untuk admin
    } on AuthException catch (e) {
      print('eeee ${e}');
      Get.snackbar('Error', e.message,
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      // Trigger Google Sign In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw '';
      }

      // Get Google Sign In authentication
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Check if user already exists in Supabase
      final existingUser = await supabase
          .from('users')
          .select()
          .eq('email', googleUser.email)
          .maybeSingle();

      String userId;

      if (existingUser == null) {
        // Create new user if doesn't exist
        final newUser = {
          'id': Uuid().v4(),
          'email': googleUser.email,
          'name': googleUser.displayName ?? 'Google User',
          'access_token': '',
          'password': '12345678', // Empty password for Google users
          'phone_number': '+62', // Default phone number as requested
        };

        final response =
            await supabase.from('users').insert(newUser).select().single();

        userId = response['id'];

        // Create user role (assuming member role)
        await supabase.from('user_roles').insert({
          'user_id': userId,
          'role_id': '0d809fc2-9fee-427e-a10c-04a177dec6b7', // Member role ID
        });
      } else {
        userId = existingUser['id'];
      }

      // Get user role
      

      // final roleUsers = roles['name'] ?? 'member';
      final defaultProfileImage =
          'https://res.cloudinary.com/dcthljxbl/image/upload/v1738161418/bycisnwjaqzyxddx7ome.webp';
      // final fileData = {
      //   'module_class': 'users',
      //   'module_id': userId,
      //   'file_name': googleUser.photoUrl ?? defaultProfileImage,
      //   'file_type': 'webp',
      //   'created_at': DateTime.now().toIso8601String(),
      //   'updated_at': DateTime.now().toIso8601String(),
      // };

      // await supabase.from('files').insert(fileData);

      // Save user data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', googleUser.email);
      await prefs.setString('userId', userId);
      await prefs.setString(
          'userName', googleUser.displayName ?? 'Google User');
      await prefs.setString('userPhone', '+62');
      await prefs.setString(
          'userProfileImage', googleUser.photoUrl ?? defaultProfileImage);
      Get.snackbar(
        'Sukses',
        'Berhasil login dengan Google',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        snackStyle: SnackStyle.FLOATING,
        forwardAnimationCurve: Curves.easeOut,
        reverseAnimationCurve: Curves.easeIn,
      );

      // Navigate based on role
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      print('eror: $e');
      // Get.snackbar(
      //   'Error',
      //   'Terjadi kesalahan: $e',
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    } finally {
      isLoading.value = false;
    }
  }
}
