import 'dart:convert';
import 'package:clinic_ai/app/modules/(admin)/list_user/controllers/list_user_controller.dart';
import 'package:clinic_ai/components/UploadDialog.dart';
import 'package:clinic_ai/models/file_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;

class UploadController extends GetxController {
  final String baseUrl = "https://be-clinic-rx7y.vercel.app";

  final isLoading = false.obs;
  final selectedModuleClass = ''.obs;
  final existingFileId = ''.obs;
  final imageUrl = ''.obs;
  final selectedImage = Rxn<XFile>();
  final fileType = ''.obs;
  final isEditMode = false.obs;
  final isDeleteMode = false.obs;
  final selectedFilesForDeletion = <String>{}.obs;

  final cloudName = 'dulun20eo';
  final uploadPreset = 'clinic_app';

  final RxList<FileModel> fileList = <FileModel>[].obs;

  final RxList<String> moduleClasses = <String>[
    'all',
    'users',
    'appointments',
    'transactions',
    'companies',
    'clinics',
    'doctors',
    'drugs',
    'charities',
    'banks'
  ].obs;

  final RxList<FileModel> filteredFileList = <FileModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFiles();
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
    isDeleteMode.value = false;
  }

  void toggleDeleteMode() {
    isDeleteMode.value = !isDeleteMode.value;
    isEditMode.value = false;
    selectedFilesForDeletion.clear();
  }

  void toggleFileSelection(String fileId) {
    if (selectedFilesForDeletion.contains(fileId)) {
      selectedFilesForDeletion.remove(fileId);
    } else {
      selectedFilesForDeletion.add(fileId);
    }
  }

  Future<void> deleteSelectedFiles() async {
    if (selectedFilesForDeletion.isEmpty) return;
    try {
      isLoading.value = true;
      for (var fileId in selectedFilesForDeletion) {
        final url = Uri.parse('$baseUrl/files/$fileId');
        await http.delete(url);
      }
      await fetchFiles();
      toggleDeleteMode();
      Get.snackbar('Success', 'Selected files deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete files: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editFile(FileModel file) async {
    existingFileId.value = file.id ?? '';
    imageUrl.value = file.fileName ?? '';
    fileType.value = file.fileType;
    selectedModuleClass.value = file.moduleClass;

    Get.put(ListUserController());
    Get.dialog(UploadDialog());
  }

  void filterFiles() {
    if (selectedModuleClass.value.isEmpty ||
        selectedModuleClass.value == 'all') {
      filteredFileList.value = fileList;
    } else {
      filteredFileList.value = fileList
          .where((file) => file.moduleClass == selectedModuleClass.value)
          .toList();
    }
  }

  void showUploadDialog(BuildContext context) {
    resetForm();
    Get.put(ListUserController());
    Get.dialog(UploadDialog());
  }

  Future<List<FileModel>> fetchFiles() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/files'));

      if (response.statusCode == 200) {
        final dynamic decodedBody = json.decode(response.body);
        List<dynamic> data = [];

        if (decodedBody is List) {
          data = decodedBody;
        } else if (decodedBody is Map<String, dynamic>) {
          if (decodedBody['data'] is List) {
            data = decodedBody['data'];
          } else if (decodedBody['result'] is List) data = decodedBody['result'];
        }

        final List<FileModel> files = data.map((jsonItem) {
          return FileModel(
            id: jsonItem['id'],
            moduleClass: jsonItem['module_class'] ?? 'unknown',
            moduleId: jsonItem['module_id'],
            fileName: jsonItem['file_name'],
            fileType: jsonItem['file_type'],
            moduleName: (jsonItem['module_name'] != null &&
                    jsonItem['module_name'] != 'Unknown')
                ? jsonItem['module_name']
                : (jsonItem['module_class'] ?? 'Unknown File'),
            hasFile: true,
          );
        }).toList();

        fileList.value = files;
        if (selectedModuleClass.value.isEmpty) {
          selectedModuleClass.value = 'all';
        }

        filterFiles();
        return files;
      }
      return [];
    } catch (e) {
      print('Error fetch files: $e');
      return [];
    }
  }

  Future<void> uploadFileToCloudinary(XFile file) async {
    try {
      isLoading.value = true;
      final bytes = await file.readAsBytes();
      fileType.value = file.name.split('.').last;

      final formData = dio.FormData.fromMap({
        'file': dio.MultipartFile.fromBytes(bytes, filename: file.name),
        'upload_preset': uploadPreset,
      });

      final response = await dio.Dio().post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        imageUrl.value = response.data['secure_url'];
      }
    } catch (e) {
      print('Upload error: $e');
      Get.snackbar('Error', 'Failed to upload file: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveFileInfo() async {
    if (selectedModuleClass.value.isEmpty) {
      Get.snackbar('Error', 'Tipe Modul belum dipilih!',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (imageUrl.value.isEmpty) {
      Get.snackbar('Error', 'Gambar belum selesai diupload. Tunggu sebentar.',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      final listUserController = Get.find<ListUserController>();
      final idUserLogin = listUserController.currentUserId.value;

      if (idUserLogin.isEmpty) {
        Get.snackbar('Error', 'Gagal mendapatkan ID User. Silakan relogin.',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final body = {
        'fileId': existingFileId.value.isNotEmpty
            ? existingFileId.value
            : null, // FIX UTAMA DI SINI
        'moduleClass': selectedModuleClass.value,
        'moduleId': idUserLogin,
        'fileName': imageUrl.value,
        'fileType': fileType.value,
        'uploadAllUsers': false,
      };

      final url = Uri.parse('$baseUrl/files/save');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        await resetForm();
        await fetchFiles();
        if (Get.isDialogOpen ?? false) Get.back();

        Get.snackbar('Success', 'File berhasil disimpan!',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Gagal menyimpan file: ${response.statusCode}',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan koneksi',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetForm() async {
    selectedModuleClass.value = '';
    existingFileId.value = '';
    imageUrl.value = '';
    fileType.value = '';
    selectedImage.value = null;
  }
}
