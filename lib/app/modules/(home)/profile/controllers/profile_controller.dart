import 'package:clinic_ai/app/modules/(admin)/upload/controllers/upload_controller.dart';
import 'package:clinic_ai/app/modules/Theme/controllers/theme_controller.dart';
import 'package:clinic_ai/models/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  final user = Users().obs;
  final isLoading = true.obs;
  final errorMessage = RxString('');

  RxString roleUser = ''.obs;
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;
  RxString currentUserId = ''.obs;
  RxString profileImageUrl = ''.obs;

  late final TextEditingController namaController;
  late final TextEditingController emailController;
  SharedPreferences? _prefs;

  final UploadController uploadController = Get.put(UploadController());
  final themeController = Get.find<ThemeController>();
  RxBool get isDarkMode => RxBool(themeController.isDarkMode);

  // Ganti dengan URL backend kamu (Production/Local)
  final String baseUrl = 'https://be-clinic-rx7y.vercel.app';

  @override
  void onInit() {
    super.onInit();
    namaController = TextEditingController();
    emailController = TextEditingController();
    // Cukup panggil fungsi ini, tidak perlu lagi .then(() => loadProfileImage())
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
      print('Loaded userId from SharedPreferences: $savedUserId');
      // Langsung panggil backend
      await loadUserData();
    } else {
      print('Error: userId not found in SharedPreferences.');
      errorMessage.value = 'Sesi tidak valid, silakan login ulang.';
      isLoading.value = false;
    }
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      errorMessage.value = ''; // Reset error message saat mencoba load ulang

      _prefs = await SharedPreferences.getInstance();
      final token = _prefs?.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedBody = json.decode(response.body);

        // Menyesuaikan dengan response: {"success": true, "data": {...}}
        final data = decodedBody['data'] ?? decodedBody;

        if (data == null) {
          throw Exception("Data pengguna kosong dari server");
        }

        user.value = Users(
          id: data['id']?.toString() ?? '',
          name: data['name']?.toString() ?? 'Pasien',
          email: data['email']?.toString() ?? '',
          role: data['role']?.toString() ?? 'member',
          phoneNumber: data['phone_number']?.toString() ?? '',
          accessToken: data['access_token']?.toString() ?? '',
          imageUrl: (data['imageUrl'] != null &&
                  data['imageUrl'].toString().isNotEmpty)
              ? data['imageUrl'].toString()
              : null,
          createdAt: data['created_at'] != null
              ? (DateTime.tryParse(data['created_at'].toString()) ??
                  DateTime.now())
              : DateTime.now(),
          updatedAt: data['updated_at'] != null
              ? (DateTime.tryParse(data['updated_at'].toString()) ??
                  DateTime.now())
              : DateTime.now(),
        );

        // Jika controller ini keburu dihapus (user pindah page cepat), hentikan eksekusi
        if (!Get.isRegistered<ProfileController>()) return;

        // Update UI Variables
        userName.value = user.value.name;
        userEmail.value = user.value.email;
        roleUser.value = user.value.role;
        profileImageUrl.value = user.value.imageUrl ?? '';

        namaController.text = user.value.name;
        emailController.text = user.value.email;
      } else {
        errorMessage.value =
            'Gagal mengambil data profil (${response.statusCode})';
      }
    } catch (e) {
      print('Error fetching user: $e');
      errorMessage.value = 'Terjadi kesalahan jaringan atau data tidak valid.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProfile() async {
    if (Get.isRegistered<ProfileController>()) {
      await loadUserData();
    }
  }

  void toggleDarkMode(bool value) {
    themeController.toggleTheme();
  }
}
