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
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final agreeToTerms = false.obs;
  final isLoading = false.obs;
  final supabase = Supabase.instance.client;

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
      final userRoleResponse = await supabase
          .from('user_roles')
          .select('roles:role_id(name), users:user_id(*)')
          .eq('user_id', userId)
          .single();

      final roleUsers = userRoleResponse['roles']['name'];
      final idUser = userRoleResponse['users']['id'];
      final userName = userRoleResponse['users']['name'];
      final userPhone = userRoleResponse['users']['phone_number'];

      // final roleUsers = roles['name'] ?? 'member';
      final defaultProfileImage =
          'https://res.cloudinary.com/dcthljxbl/image/upload/v1738161418/bycisnwjaqzyxddx7ome.webp';
      final fileData = {
        'module_class': 'users',
        'module_id': userId,
        'file_name': googleUser.photoUrl ?? defaultProfileImage,
        'file_type': 'webp',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await supabase.from('files').insert(fileData);
      print('roleUsers: $roleUsers');
      print('idusers: $idUser');

      // Save user data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userRole', roleUsers);
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', googleUser.email);
      await prefs.setString('userId', idUser);
      await prefs.setString('name', userName);
      await prefs.setString('phone', userPhone);
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
      if (roleUsers == 'admin') {
        Get.offAllNamed(Routes.ADMIN_PANEL);
      } else {
        Get.offAllNamed(Routes.HOME);
      }
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
