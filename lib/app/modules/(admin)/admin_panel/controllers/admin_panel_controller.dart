import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminPanelController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxBool isSidebarVisible = false.obs;
  final supabase = Supabase.instance.client;
  RxBool isLoading = false.obs;
  RxString username = ''.obs;

  void toggleSidebar() {
    isSidebarVisible.value = !isSidebarVisible.value;
  }

  void closeSidebar() {
    isSidebarVisible.value = false;
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
    // Optionally close sidebar after selection on mobile
    if (Get.width < 600) {
      closeSidebar();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('name') ?? '';
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      await GoogleSignIn().signOut();

      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('email');
      await prefs.remove('name');
      await prefs.remove('phone');
      await prefs.remove('userId');
      // await prefs.remove('accessToken');

      Get.snackbar(
        'Success',
        'Successfully logged out',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to login page
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
