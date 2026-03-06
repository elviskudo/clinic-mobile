import 'dart:convert';
import 'package:clinic_ai/app/modules/(admin)/upload/controllers/upload_controller.dart';
import 'package:clinic_ai/app/modules/Theme/controllers/theme_controller.dart';
import 'package:clinic_ai/models/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileDoctorController extends GetxController {
  final user = Users().obs;
  final isLoading = true.obs;
  final errorMessage = RxString('');

  RxString roleUser = ''.obs;
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;
  RxString currentUserId = ''.obs;
  RxString profileImageUrl = ''.obs;

  // Data Khusus Dokter
  RxString doctorDegree = ''.obs;
  RxString doctorSpecialize = ''.obs;
  RxString doctorDescription = ''.obs; // Tambahan untuk deskripsi

  late final TextEditingController namaController;
  late final TextEditingController emailController;
  SharedPreferences? _prefs;

  final UploadController uploadController = Get.put(UploadController());
  final themeController = Get.find<ThemeController>();
  RxBool get isDarkMode => RxBool(themeController.isDarkMode);

  final String baseUrl = 'https://be-clinic-rx7y.vercel.app';

  @override
  void onInit() {
    super.onInit();
    namaController = TextEditingController();
    emailController = TextEditingController();
    _loadUserIdFromPrefs();
  }

  @override
  void onClose() {
    namaController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> _loadUserIdFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final savedUserId = _prefs?.getString('userId') ?? '';

    if (savedUserId.isNotEmpty) {
      currentUserId.value = savedUserId;
      await loadUserData();
    } else {
      errorMessage.value = 'Sesi tidak valid, silakan login ulang.';
      isLoading.value = false;
    }
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      _prefs = await SharedPreferences.getInstance();
      final token = _prefs?.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedBody = json.decode(response.body);
        final data = decodedBody['data'] ?? decodedBody;

        if (data == null) throw Exception("Data kosong");

        user.value = Users(
          id: data['id']?.toString() ?? '',
          name: data['name']?.toString() ?? 'Doctor',
          email: data['email']?.toString() ?? '',
          role: data['role']?.toString() ?? 'doctor',
          phoneNumber: data['phone_number']?.toString() ?? '',
          accessToken: data['access_token']?.toString() ?? '',
          imageUrl: (data['imageUrl'] != null &&
                  data['imageUrl'].toString().isNotEmpty)
              ? data['imageUrl'].toString()
              : null,
          createdAt: data['created_at'] != null
              ? DateTime.parse(data['created_at'])
              : DateTime.now(),
          updatedAt: data['updated_at'] != null
              ? DateTime.parse(data['updated_at'])
              : DateTime.now(),
        );

        if (!Get.isRegistered<ProfileDoctorController>()) return;

        userName.value = user.value.name;
        userEmail.value = user.value.email;
        roleUser.value = user.value.role;
        profileImageUrl.value = user.value.imageUrl ?? '';

        // Ambil data spesifik dokter dari JSON response
        if (data['doctorData'] != null) {
          doctorDegree.value = data['doctorData']['degree'] ?? '';
          doctorSpecialize.value =
              data['doctorData']['specialize'] ?? 'General';
          // Ambil deskripsi
          doctorDescription.value = data['doctorData']['description'] ??
              'Membantu melayani dan memberikan diagnosis terbaik untuk pasien.';
        }

        namaController.text = user.value.name;
        emailController.text = user.value.email;
      } else {
        errorMessage.value =
            'Gagal mengambil data profil (${response.statusCode})';
      }
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan jaringan.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProfile() async {
    await loadUserData();
  }

  void toggleDarkMode(bool value) {
    themeController.toggleTheme();
  }
}