import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:clinic_ai/models/file_model.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';

class CaptureAppointmentController extends GetxController {
  final cloudName = 'dcthljxbl';
  final uploadPreset = 'dompet-mal';
  final imageUrl = ''.obs;
  final fileType = ''.obs;
  final isLoading = false.obs;
  // Tambahkan variabel Rx untuk File gambar yang dipilih
  final selectedImage = Rx<File?>(null);

  final supabase = Supabase.instance.client;

  // Function untuk update gambar
  void updateSelectedImage(File? image) {
    selectedImage.value = image;
  }

  // Function to upload file to Cloudinary
  Future<void> uploadFileToCloudinary(XFile file, String appointmentId) async {
    try {
      isLoading.value = true;

      final bytes = await file.readAsBytes();
      fileType.value = file.name.split('.').last;

      final formData = dio.FormData.fromMap({
        'file': dio.MultipartFile.fromBytes(
          bytes,
          filename: file.name,
        ),
        'upload_preset': uploadPreset,
      });

      final response = await dio.Dio().post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        imageUrl.value = response.data['secure_url'];
        // After successful upload, save file info to Supabase
        await saveFileInfo(appointmentId);
      } else {
        Get.snackbar('Error', 'Failed to upload image to Cloudinary');
      }
    } catch (e) {
      print('Upload error: $e');
      Get.snackbar('Error', 'Failed to upload file: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Function to save file info to Supabase
  Future<void> saveFileInfo(String appointmentId) async {
    try {
      isLoading.value = true;
      final fileData = FileModel(
        moduleClass: 'appointments',
        moduleId: appointmentId,
        fileName: imageUrl.value,
        fileType: fileType.value,
      ).toJson();

      await supabase.from('files').insert(fileData);

      Get.snackbar('Success', 'File information saved successfully');
    } catch (e) {
      print('Error saving file info: $e');
      Get.snackbar('Error', 'Failed to save file information: $e');
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
}