import 'dart:convert';
import 'package:clinic_ai/app/modules/(admin)/upload/controllers/upload_controller.dart';
import 'package:clinic_ai/app/modules/(home)/profile/controllers/profile_controller.dart';
import 'package:clinic_ai/app/modules/(doctor)/profile_doctor/controllers/profile_doctor_controller.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; 

class AccountSettingsController extends GetxController {
  RxBool isLoading = false.obs;
  RxString currentUserId = ''.obs;
  final uploadController = Get.put(UploadController());
  RxString uploadedFileUrl = ''.obs;
  
  // Variabel untuk menyimpan URL gambar dan Role agar UI bisa langsung baca
  RxString currentImageUrl = ''.obs;
  RxString currentUserRole = 'member'.obs;

  final String baseUrl = 'https://be-clinic-rx7y.vercel.app';

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  // Helper untuk menentukan kita pakai data dari mana
  void _initData() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserRole.value = prefs.getString('userRole') ?? 'member';

    _syncImageUrl();
  }

  void _syncImageUrl() {
    // Ambil URL gambar berdasarkan role
    if (currentUserRole.value == 'doctor') {
      if (Get.isRegistered<ProfileDoctorController>()) {
        currentImageUrl.value = Get.find<ProfileDoctorController>().profileImageUrl.value;
      }
    } else {
      if (Get.isRegistered<ProfileController>()) {
        currentImageUrl.value = Get.find<ProfileController>().profileImageUrl.value;
      }
    }
  }

  Future<void> updateProfileImage() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        Get.offAllNamed(Routes.LOGIN);
        throw Exception('Sesi tidak valid, silakan login ulang.');
      }

      if (uploadController.selectedImage.value == null) {
        throw Exception('Tidak ada gambar yang dipilih');
      }

      // 1. Upload ke Cloudinary
      await uploadController.uploadFileToCloudinary(uploadController.selectedImage.value!);
      final uploadedFileUrl = uploadController.imageUrl.value;

      if (uploadedFileUrl.isEmpty) {
        throw Exception('Gagal mendapatkan URL gambar dari Cloudinary');
      }

      // 2. Kirim URL ke NestJS
      final response = await http.patch(
        Uri.parse('$baseUrl/profile/image'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'imageUrl': uploadedFileUrl}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Profile image updated successfully',
          backgroundColor: const Color(0xFF35693E),
          colorText: const Color(0xFFFFFFFF),
          snackPosition: SnackPosition.BOTTOM,
        );

        // 3. Refresh data di Controller yang sesuai
        if (currentUserRole.value == 'doctor') {
          if (Get.isRegistered<ProfileDoctorController>()) {
             await Get.find<ProfileDoctorController>().loadUserData();
          }
        } else {
          if (Get.isRegistered<ProfileController>()) {
             await Get.find<ProfileController>().loadUserData();
          }
        }
        
        _syncImageUrl(); // Update variabel lokal agar UI berubah
      } else {
        throw Exception('Gagal menyimpan foto profil di server (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        '$e'.replaceAll('Exception: ', ''),
        backgroundColor: const Color(0xFFFF0000),
        colorText: const Color(0xFFFFFFFF),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}