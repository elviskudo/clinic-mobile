import 'package:clinic_ai/app/modules/(admin)/upload/controllers/upload_controller.dart';
import 'package:clinic_ai/models/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;
  final user = Users().obs;
  final isLoading = true.obs;
  final errorMessage = RxString('');
  final isDarkMode = false.obs;
  RxString roleUser = ''.obs;
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;
  RxString currentUserId = ''.obs;
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  SharedPreferences? _prefs;
  final UploadController uploadController = Get.put(UploadController());
  RxString profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData().then((_) => loadProfileImage());
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();

      userEmail.value = prefs.getString('userEmail') ?? '';
      userName.value = prefs.getString('userName') ?? '';
      currentUserId.value = prefs.getString('userId') ?? '';

      print("Loaded userId from SharedPreferences: '${currentUserId.value}'");

      if (currentUserId.value.isEmpty) {
        print('Error: userId is empty. Make sure it is set during login.');
        return;
      }

      final response = await supabase
          .from('users')
          .select('*')
          .eq('id', currentUserId.value)
          .single();
        
      if (response != null) {
        userEmail.value = response['email'] ?? '';
        userName.value = response['name'] ?? '';
        roleUser.value = response['role'] ?? '';
        namaController.text = userName.value;
        roleUser.value = roleUser.value;
        emailController.text = userEmail.value;
      }

      print(
          "ID: ${currentUserId.value}, Name: ${userName.value}, Role: ${roleUser.value}, Email: ${userEmail.value}");
    } catch (e) {
      print('Error loading user data: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data profil: $e',
        backgroundColor: Color(0xFF35693E),
        colorText: Color(0xffffffff),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProfile() async {
    await loadUserData();
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
  }

  Future<void> loadProfileImage() async {
    try {
      if (currentUserId.value.isEmpty) {
        print('Error: currentUserId is empty, cannot fetch profile image.');
        return;
      }
      final response = await uploadController.supabase
          .from('files')
          .select()
          .eq('module_class', 'users')
          .eq('module_id', currentUserId.value)
          .single();

      print('Profile image response: $response');

      if (response != null) {
        profileImageUrl.value = response['file_name'];
        print('Profile image URL: ${profileImageUrl.value}');
      }
    } catch (e) {
      print('Error loading profile image: $e');
      profileImageUrl.value = '';
    }
  }

  @override
  void onClose() {
    user.close();
    isLoading.close();
    errorMessage.close();
    isDarkMode.close();
    _prefs = null;
    Get.delete<ProfileController>();
    super.onClose();
  }
}
