import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:clinic_ai/models/file_model.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';

class CaptureAppointmentController extends GetxController {
  final cloudName = 'dulun20eo';
  final uploadPreset = 'clinic_app';
  final imageUrl = ''.obs;
  final fileType = ''.obs;
  final isLoading = false.obs;
  // Tambahkan variabel Rx untuk File gambar yang dipilih
  final selectedImage = Rx<File?>(null);

  final supabase = Supabase.instance.client;

  // Function untuk update gambar
  void updateSelectedImage(File? image) {
    selectedImage.value = image;
    // Reset URL gambar jika gambar baru dipilih
    if (image != null) {
      imageUrl.value = '';
    }
  }

  // Function to upload file to Cloudinary
  Future<void> uploadFileToCloudinary(XFile file, String appointmentId) async {
    try {
      isLoading.value = true;

      print("--- DEBUG UPLOAD CLOUDINARY ---");
      print("Cloud Name: $cloudName");
      print("Upload Preset: $uploadPreset");
      print("File Name: ${file.name}");

      final bytes = await file.readAsBytes();
      fileType.value = file.name.split('.').last;

      final formData = dio.FormData.fromMap({
        'file': dio.MultipartFile.fromBytes(
          bytes,
          filename: file.name,
        ),
        'upload_preset': uploadPreset,
      });

      

      print("Sending request to Cloudinary...");
      final response = await dio.Dio().post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
      );

      print("Cloudinary Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        imageUrl.value = response.data['secure_url'];
        print("Upload SUCCESS! Secure URL: ${imageUrl.value}");

        // Lanjut simpan metadata ke NestJS
        print("Saving file info to Backend for Appointment: $appointmentId");
        await saveFileInfo(appointmentId);
      } else {
        print("Cloudinary ERROR Response: ${response.data}");
        Get.snackbar('Error', 'Failed to upload image to Cloudinary');
      }
    } catch (e) {
      print('CATCH ERROR (Upload): $e');
      if (e is dio.DioException) {
        print('Dio Error Data: ${e.response?.data}');
      }
      Get.snackbar('Error', 'Failed to upload file: $e');
    } finally {
      isLoading.value = false;
      print("--- END DEBUG UPLOAD ---");
    }
  }

  // Function to delete file from Cloudinary
  Future<void> cancelImage(String appointmentId) async {
    try {
      isLoading.value = true;

      // Find the file info in Supabase based on module_class and module_id
      final response = await supabase
          .from('files')
          .select()
          .eq('module_class', 'appointments')
          .eq('module_id', appointmentId)
          .single();

      if (response != null) {
        final fileId = response['id'];

        // Delete the file info from Supabase
        await supabase.from('files').delete().eq('id', fileId);
        print("fileId: $fileId");
      } else {
        print('File information not found in Supabase.');
      }
      selectedImage.value = null; // Hapus gambar yang dipilih
      imageUrl.value = ''; // Reset imageUrl
      fileType.value = ''; // Reset fileType
    } catch (e) {
      print('Error deleting file info: $e');
      Get.snackbar('Error', 'Failed to delete file information: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Function to save file info to Supabase
  Future<void> saveFileInfo(String appointmentId) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      final response = await dio.Dio().post(
        'https://be-clinic-rx7y.vercel.app/files/save',
        options: dio.Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          'moduleClass': 'appointments',
          'moduleId': appointmentId,
          'fileName': imageUrl.value, // URL dari Cloudinary
          'fileType': fileType.value,
        },
      );

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'File information saved to backend');
      }
    } catch (e) {
      print('Error saving to BE: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    imageUrl.value = '';
    fileType.value = '';
    selectedImage.value = null; // Clear gambar saat controller ditutup
    super.onClose();
  }

  void reset() {
    imageUrl.value = '';
    fileType.value = '';
    selectedImage.value = null;
    print("CaptureAppointmentController data reset!");
  }
}
