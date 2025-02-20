import 'package:clinic_ai/app/modules/(admin)/upload/controllers/upload_controller.dart';
import 'package:clinic_ai/app/modules/(home)/profile/controllers/profile_controller.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/models/user_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountSettingsController extends GetxController {
  final supabase = Supabase.instance.client;
  RxBool isLoading = false.obs;
  RxString currentUserId = ''.obs;
  final uploadController = Get.put(UploadController());
  Rx<Users> user = Users().obs;
  RxString uploadedFileUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> updateProfileImage() async {
    try {
      isLoading.value = true;
      
      // Ambil user ID dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString('userId');
      
      if (savedUserId == null || savedUserId.isEmpty) {
        print('User ID not found in SharedPreferences');
        Get.offAllNamed(Routes.LOGIN);
        return;
      }
      currentUserId.value = savedUserId;

      // Validasi user ID
      if (currentUserId.value.isEmpty) {
        print('Current user ID: ${currentUserId.value}');
        throw Exception('User ID is not available');
      }

      // Cek apakah ada gambar yang dipilih
      if (uploadController.selectedImage.value == null) {
        throw Exception('No image selected');
      }

      // Set module class dan ID untuk upload
      uploadController.selectedModuleClass.value = 'users';
      uploadController.selectedModuleId.value = currentUserId.value;

      // Hapus semua file lama untuk user ini
      try {
        await supabase
            .from('files')
            .delete()
            .eq('module_class', 'users')
            .eq('module_id', currentUserId.value);
        
        print('Berhasil menghapus file lama');
      } catch (e) {
        print('Error saat menghapus file lama: $e');
        // Lanjutkan proses meskipun gagal menghapus file lama
      }

      // Upload gambar baru ke Cloudinary
      await uploadController.uploadFileToCloudinary(
        uploadController.selectedImage.value!
      );

      // Ambil URL file yang sudah diupload
      final uploadedFileUrl = uploadController.imageUrl.value;

      if (uploadedFileUrl.isEmpty) {
        throw Exception('Failed to get uploaded file URL');
      }

      // Siapkan data file baru
      final fileData = {
        'module_class': 'users',
        'module_id': currentUserId.value,
        'file_name': uploadedFileUrl,
        'file_type': 'image',
      };

      // Simpan data file baru ke database
      await supabase.from('files').insert(fileData);

      // Tampilkan notifikasi sukses
      Get.snackbar(
        'Success',
        'Profile image updated successfully',
        backgroundColor: Color(0xFF35693E),
        colorText: Color(0xFFFFFFFF),
      );

      // Opsional: Refresh data profil di ProfileController
      // final profileController = Get.find<ProfileController>();
      // await profileController.loadProfileImage();
      
    } catch (e) {
      print('Error updating profile image: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile image: $e',
        backgroundColor: Color(0xFFFF0000),
        colorText: Color(0xFFFFFFFF),
      );
    } finally {
      isLoading.value = false;
    }
  }
}