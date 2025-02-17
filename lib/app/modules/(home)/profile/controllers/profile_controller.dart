import 'package:clinic_ai/models/user_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController
  final user = Users().obs;

  final count = 0.obs;
  final isDarkMode = false.obs;
  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('userId');

    if (userId == null) {
      Get.snackbar('Error', 'User ID not found. Please login again.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    String? storedImageUrl = prefs.getString('imageUrl');
    if (storedImageUrl == null || storedImageUrl.isEmpty) {
      print('imageUrl is empty or not set');
    } else {
      print('imageUrl found: $storedImageUrl');
    }
    user.value = Users(
      name: prefs.getString('name') ?? 'Guest User',
      email: prefs.getString('email') ?? 'guest@example.com',
      imageUrl: prefs.getString('imageUrl') ?? '',
      role: prefs.getString('role') ?? 'member',
    );
    print('user.name: ${user.value.name}');
    print('user.email: ${user.value.email}');
    print('user.imgUrl: ${user.value.imageUrl}');
    print('user.role: ${user.value.role}');
    print('user.id: ${user.value}');
    print('userId: $userId');
  }

  @override
  void onReady() {
    super.onReady();
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
