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
    _loadUserIdFromPrefs();
    loadUserData().then((_) => loadProfileImage());
  }

  Future<void> _loadUserIdFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final savedUserId = _prefs?.getString('userId') ?? '';

    if (savedUserId.isNotEmpty) {
      currentUserId.value = savedUserId;
      print('Loaded userId from SharedPreferences: $savedUserId');
      await loadUserData();
      await loadProfileImage();
    } else {
      print('Error: userId not found in SharedPreferences.');
    }
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;

      if (currentUserId.value.isEmpty) {
        print('Error: userId is empty.');
        return;
      }

      final response = await supabase
          .from('users')
          .select('*')
          .eq('id', currentUserId.value)
          .maybeSingle();

      if (response != null) {
        final userRole = await supabase
            .from('user_roles')
            .select()
            .eq('user_id', response['id'])
            .limit(1)
            .single();

        final roles = await supabase
            .from('roles')
            .select()
            .eq('id', userRole['role_id'])
            .single();

        final roleName = roles['name'] ?? 'member';

        // Fetch user image from files
        String? imageUrl;
        final fileResponse = await supabase
            .from('files')
            .select('file_name')
            .eq('module_class', 'users')
            .eq('module_id', response['id'])
            .limit(1)
            .maybeSingle();

        if (fileResponse != null) {
          imageUrl = fileResponse['file_name'];
        }

        user.value = Users(
          id: response['id'] as String,
          name: response['name'] as String,
          email: response['email'] as String,
          role: roleName,
          phoneNumber: response['phone_number'] as String,
          accessToken: response['access_token'] as String,
          imageUrl: imageUrl,
          createdAt: DateTime.parse(response['created_at'] as String),
          updatedAt: DateTime.parse(response['updated_at'] as String),
        );

        // Update UI elements
        userName.value = user.value.name;
        userEmail.value = user.value.email;
        roleUser.value = user.value.role;
        namaController.text = user.value.name;
        emailController.text = user.value.email;
        print('User data: ${user.value.toString()}');
        print('fileName: $imageUrl');
      }
    } catch (e) {
      print('Error fetching user: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch user: $e',
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
          .limit(1)
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
