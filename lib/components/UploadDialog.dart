import 'dart:io';
import 'package:clinic_ai/app/modules/(admin)/list_user/controllers/list_user_controller.dart';
import 'package:clinic_ai/app/modules/(admin)/upload/controllers/upload_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadDialog extends StatelessWidget {
  final ListUserController listUserController = Get.put(ListUserController());
  final UploadController uploadController = Get.find<UploadController>();

  UploadDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              uploadController.existingFileId.value.isEmpty
                  ? 'Upload File'
                  : 'Edit File',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 1. Module Class Dropdown
            Obx(() {
              // --- FIX NYA DI SINI ---
              // Jika value-nya 'all' atau kosong, kita jadikan null agar Dropdown tidak crash
              String? currentValue = uploadController.selectedModuleClass.value;
              if (currentValue.isEmpty || currentValue == 'all') {
                currentValue = null;
              }

              return DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Module Type',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                value: currentValue,
                items: uploadController.moduleClasses
                    .where((item) => item != 'all')
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  uploadController.selectedModuleClass.value = value ?? '';
                },
              );
            }),

            const SizedBox(height: 20),

            // 2. Image Preview & Status
            Obx(() {
              return Column(
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: uploadController.selectedImage.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(uploadController.selectedImage.value!.path),
                              fit: BoxFit.cover,
                            ),
                          )
                        : (uploadController.imageUrl.value.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  uploadController.imageUrl.value,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey),
                                ),
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cloud_upload_outlined,
                                      size: 40, color: Colors.blue),
                                  SizedBox(height: 8),
                                  Text("No Image Selected",
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              )),
                  ),
                  if (uploadController.selectedImage.value != null &&
                      uploadController.imageUrl.value.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(strokeWidth: 2)),
                          SizedBox(width: 8),
                          Text("Uploading to cloud...",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.orange)),
                        ],
                      ),
                    )
                ],
              );
            }),

            const SizedBox(height: 20),

            // 3. Choose File Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Choose Image'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Colors.blue),
                ),
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (image != null) {
                    uploadController.selectedImage.value = image;
                    uploadController.imageUrl.value =
                        ''; // Reset URL buat trigger loading
                    await uploadController.uploadFileToCloudinary(image);
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            // 4. Submit Button
            SizedBox(
              width: double.infinity,
              child: Obx(() => uploadController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        // Validasi sblm save
                        if (uploadController
                                .selectedModuleClass.value.isEmpty ||
                            uploadController.selectedModuleClass.value ==
                                'all') {
                          Get.snackbar("Error", "Please select Module Type",
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                          return;
                        }
                        if (uploadController.imageUrl.value.isEmpty) {
                          Get.snackbar("Error", "Image is not ready yet",
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                          return;
                        }
                        await uploadController.saveFileInfo();
                      },
                      child:
                          const Text('Submit', style: TextStyle(fontSize: 16)),
                    )),
            ),
          ],
        ),
      ),
    );
  }
}
