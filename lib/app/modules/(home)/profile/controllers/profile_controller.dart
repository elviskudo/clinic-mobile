import 'package:clinic_ai/app/modules/(admin)/upload/controllers/upload_controller.dart';
import 'package:clinic_ai/app/modules/Theme/controllers/theme_controller.dart';
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
  // final isDarkMode = false.obs;
  RxString roleUser = ''.obs;
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;
  RxString currentUserId = ''.obs;
  late final TextEditingController namaController;
  late final TextEditingController emailController;
  SharedPreferences? _prefs;
  final UploadController uploadController = Get.put(UploadController());
  RxString profileImageUrl = ''.obs;
  final themeController = Get.find<ThemeController>();
  RxBool get isDarkMode => RxBool(themeController.isDarkMode);
  @override
  void onInit() {
    super.onInit();
    // Initialize controllers in onInit
    namaController = TextEditingController();
    emailController = TextEditingController();
    _loadUserIdFromPrefs();
    loadUserData().then((_) => loadProfileImage());
  }

  @override
  void onClose() {
    // Properly dispose controllers in onClose
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

        // Only update controllers if they haven't been disposed
        if (!Get.isRegistered<ProfileController>()) return;

        userName.value = user.value.name;
        userEmail.value = user.value.email;
        roleUser.value = user.value.role;
        namaController.text = user.value.name;
        emailController.text = user.value.email;
      }
    } catch (e) {
      print('Error fetching user: $e');
      // if (Get.isRegistered<ProfileController>()) {
      //   Get.snackbar(
      //     'Error',
      //     'Failed to fetch user: $e',
      //     backgroundColor: Color(0xFF35693E),
      //     colorText: Color(0xffffffff),
      //   );
      // }
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

      if (response != null && Get.isRegistered<ProfileController>()) {
        profileImageUrl.value = response['file_name'];
      }
    } catch (e) {
      print('Error loading profile image: $e');
      if (Get.isRegistered<ProfileController>()) {
        profileImageUrl.value = '';
      }
    }
  }
}
