// File: app/controllers/upload_controller.dart
import 'dart:io';

import 'package:clinic_ai/app/modules/(admin)/list_user/controllers/list_user_controller.dart';
import 'package:clinic_ai/components/UploadDialog.dart';
import 'package:clinic_ai/models/file_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:supabase_flutter/supabase_flutter.dart'; // Menambahkan prefix 'dio'

// Modifikasi UploadController
class UploadController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final isLoading = false.obs;
  final selectedModuleClass = ''.obs;
  final selectedModuleId = ''.obs;
  final existingFileId = ''.obs;
  final imageUrl = ''.obs;
  final selectedImage = Rxn<XFile>();
  final fileType = ''.obs;
  final isEditMode = false.obs;
  final isDeleteMode = false.obs;
  final selectedFilesForDeletion = <String>{}.obs;

  final cloudName = 'dcthljxbl';
  final uploadPreset = 'dompet-mal';
  final RxList<FileModel> fileList = <FileModel>[].obs;
  final RxList<String> moduleClasses = <String>[
    'users',
    'categories',
    'companies',
    'charities',
    'banks',
    'all'
  ].obs; // Contoh data module class
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

  // Method to toggle delete mode
  void toggleDeleteMode() {
    isDeleteMode.value = !isDeleteMode.value;
    isEditMode.value = false;
    selectedFilesForDeletion.clear();
  }

  // Method to select/deselect file for deletion
  void toggleFileSelection(String fileId) {
    if (selectedFilesForDeletion.contains(fileId)) {
      selectedFilesForDeletion.remove(fileId);
    } else {
      selectedFilesForDeletion.add(fileId);
    }
  }

  Future<void> deleteSelectedFiles() async {
    try {
      if (selectedFilesForDeletion.isEmpty) return;

      // Delete files one by one
      for (var fileId in selectedFilesForDeletion) {
        await supabase.from('files').delete().eq('id', fileId);
      }

      // Refresh file list
      await fetchFiles();

      // Reset delete mode
      toggleDeleteMode();

      Get.snackbar('Success', 'Selected files deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete files: $e');
      print('Failed to delete files: $e');
    }
  }

  // Method to edit file (will reuse existing upload logic)
  Future<void> editFile(FileModel file) async {
    existingFileId.value = file.id ?? '';
    imageUrl.value = file.fileName ?? '';
    fileType.value = file.fileType;
    selectedModuleClass.value = file.moduleClass;
    selectedModuleId.value = file.moduleId;

    // Show upload dialog to replace file
    Get.dialog(UploadDialogImage());
  }

  void filterFiles() {
    if (selectedModuleClass.value.isEmpty ||
        selectedModuleClass.value == 'all') {
      filteredFileList.value =
          fileList; // Show all files when no filter is selected
    } else {
      filteredFileList.value = fileList
          .where((file) => file.moduleClass == selectedModuleClass.value)
          .toList();
    }
  }

  void showUploadDialog(BuildContext context) {
    // Ensure all controllers are initialized before showing dialog
    Get.put(ListUserController());
    Get.put(UploadController());

    // Then show the dialog
    Get.dialog(UploadDialog());
  }

  Future<String?> pickAndUploadImage({required String moduleClass}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      isLoading.value = true;
      try {
        // Upload ke server menggunakan Supabase
        final uploadResult = await supabase.storage.from(moduleClass).upload(
              'images/${DateTime.now().toIso8601String()}-${image.name}',
              File(image.path),
            );
        // if (uploadResult.error == null) {
        //   final publicUrl = supabase.storage
        //       .from(moduleClass)
        //       .getPublicUrl(uploadResult.path);
        //   return publicUrl;
        // } else {
        //   Get.snackbar('Error', 'Gagal mengupload gambar');
        // }
      } catch (e) {
        Get.snackbar('Error', 'Terjadi kesalahan: $e');
      } finally {
        isLoading.value = false;
      }
    }
    return null;
  }

  Future<List<FileModel>> fetchFiles() async {
    try {
      final response = await supabase.from('files').select('*');
      ;
      final data = response as List<dynamic>;

      List<FileModel> files = [];

      // Create a set of existing module IDs for quick lookup
      final existingFileModuleIds =
          data.map((file) => file['module_id'] as String).toSet();

      for (final file in data) {
        final moduleClass = file['module_class'] as String;
        final moduleId = file['module_id'] as String;
        String? moduleName;

        final userResponse = await supabase
            .from(moduleClass)
            .select(moduleClass == 'charities' ? 'title' : 'name')
            .eq('id', moduleId)
            .single();
        moduleName =
            userResponse['${moduleClass == 'charities' ? 'title' : 'name'}']
                as String;

        // Add data to files list with hasFile flag
        files.add(FileModel(
          id: file['id'] as String?,
          moduleClass: moduleClass,
          moduleId: moduleId,
          moduleName: moduleName ?? 'Unknown',
          fileName: file['file_name'] as String,
          fileType: file['file_type'] as String,
          hasFile: existingFileModuleIds.contains(moduleId), // New flag
          createdAt: file['created_at'] != null
              ? DateTime.parse(file['created_at'] as String)
              : null,
        ));
      }
      fileList.value = files;
      filteredFileList.value = files;
      filterFiles();
      return files;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch files: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('error: $e');
      return [];
    }
  }

  Future<void> checkExistingFile() async {
    try {
      final response = await supabase
          .from('files')
          .select()
          .eq('module_class', selectedModuleClass.value)
          .eq('module_id', selectedModuleId.value)
          .single(); // Get single record if exists

      if (response != null) {
        existingFileId.value = response['id'];
        imageUrl.value = response['file_name'];
        fileType.value = response['file_type'];
      } else {
        existingFileId.value = '';
        imageUrl.value = '';
        fileType.value = '';
      }
    } catch (e) {
      existingFileId.value = '';
      print('No existing file found: $e');
    }
  }

  Future<void> uploadFileToCloudinary(XFile file) async {
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
      }
      fetchFiles();
      filterFiles();
    } catch (e) {
      print('Upload error: $e');
      Get.snackbar('Error', 'Failed to upload file: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveFileInfo() async {
    try {
      isLoading.value = true;

      if (selectedModuleClass.value == 'users' &&
          selectedModuleId.value == 'all') {
        // Fetch all users and upload file for each
        final userResponse = await supabase.from('users').select('id');
        final userIds =
            (userResponse as List).map((user) => user['id'] as String).toList();

        for (final userId in userIds) {
          final fileData = FileModel(
            moduleClass: 'users',
            moduleId: userId,
            fileName: imageUrl.value,
            fileType: fileType.value,
          ).toJson();

          // Check if file exists for this user
          final existingFile = await supabase
              .from('files')
              .select()
              .eq('module_class', 'users')
              .eq('module_id', userId)
              .single();

          if (existingFile != null) {
            // Update existing file
            await supabase
                .from('files')
                .update(fileData)
                .eq('id', existingFile['id']);
          } else {
            // Insert new file
            await supabase.from('files').insert(fileData);
          }
        }

        await resetForm();

        await fetchFiles();
        filterFiles();
        Get.back();
        Get.snackbar('Success', 'Files uploaded for all users');
      } else {
        // Existing single file upload logic
        final fileData = FileModel(
          moduleClass: selectedModuleClass.value,
          moduleId: selectedModuleId.value,
          fileName: imageUrl.value,
          fileType: fileType.value,
        ).toJson();

        if (existingFileId.value.isNotEmpty) {
          // Update existing file
          await supabase
              .from('files')
              .update(fileData)
              .eq('id', existingFileId.value);
        } else {
          // Insert new file
          await supabase.from('files').insert(fileData);
        }

        await resetForm();
        Get.back();
        Get.snackbar('Success', 'File saved successfully');
      }
    } catch (e) {
      print('Error saving file info: $e');
      Get.snackbar('Error', 'Failed to save file information');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetForm() async {
    selectedModuleClass.value = '';
    selectedModuleId.value = '';
    existingFileId.value = '';
    imageUrl.value = '';
    fileType.value = '';
    selectedImage.value = null;
  }
}

// Modifikasi UploadDialog
