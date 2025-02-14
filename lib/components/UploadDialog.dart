
import 'package:clinic_ai/app/modules/(admin)/list_user/controllers/list_user_controller.dart';
import 'package:clinic_ai/app/modules/(admin)/upload/controllers/upload_controller.dart';
import 'package:clinic_ai/models/user_model.dart';

// import 'package:clinic_ai/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadDialog extends StatelessWidget {
  final ListUserController listUserController = Get.find();
  final UploadController uploadController = Get.put(UploadController());

  UploadDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Upload File',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // Module Class Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Module Type',
                border: OutlineInputBorder(),
              ),
              items: ['categories', 'users', 'companies', 'charities', 'banks']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.capitalizeFirst!),
                );
              }).toList(),
              onChanged: (value) {
                uploadController.selectedModuleClass.value = value ?? '';
                uploadController.selectedModuleId.value = '';
              },
            ),

            const SizedBox(height: 16),

            // Module ID Dropdown (Categories)
            Obx(() {
            
              if (uploadController.selectedModuleClass.value == 'users') {
                return Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Users',
                        border: OutlineInputBorder(),
                      ),
                      value: uploadController.selectedModuleId.value.isEmpty
                          ? null
                          : uploadController.selectedModuleId.value,
                      items: [
                        const DropdownMenuItem<String>(
                          value: 'all',
                          child: Text('All Users'),
                        ),
                        ...listUserController.usersList.map((Users data) {
                          // Check if a file exists for this user
                          bool hasFile = uploadController.fileList.any((file) =>
                              file.moduleClass == 'users' &&
                              file.moduleId == data.id);

                          return DropdownMenuItem<String>(
                            value: data.id,
                            child: Text(
                                '${data.name ?? ''} ${hasFile ? '(Sudah)' : ''}'),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        uploadController.selectedModuleId.value = value ?? '';
                        if (value != 'all') {
                          uploadController.checkExistingFile();
                        }
                      },
                    ),
                  ],
                );
              }
           

              return const SizedBox.shrink();
            }),

            const SizedBox(height: 20),

            // Image Preview
            Obx(() => uploadController.imageUrl.isNotEmpty
                ? Column(
                    children: [
                      Image.network(
                        uploadController.imageUrl.value,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      Text('File type: ${uploadController.fileType.value}'),
                    ],
                  )
                : const SizedBox.shrink()),

            const SizedBox(height: 20),

            // Choose File Button
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: Text('Choose Image'),
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );

                if (image != null) {
                  uploadController.selectedImage.value = image;
                  await uploadController.uploadFileToCloudinary(image);
                }
              },
            ),

            const SizedBox(height: 16),

            // Submit Button
            Obx(() => uploadController.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: uploadController.imageUrl.isEmpty ||
                            uploadController.selectedModuleId.isEmpty
                        ? null
                        : () async {
                            await uploadController.saveFileInfo();
                            await uploadController.fetchFiles();
                          },
                    child: Text('Submit'),
                  )),
          ],
        ),
      ),
    );
  }
}

class UploadDialogImage extends StatelessWidget {
  final UploadController uploadController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Image',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // Image Preview
            Obx(() => uploadController.imageUrl.isNotEmpty
                ? Column(
                    children: [
                      Image.network(
                        uploadController.imageUrl.value,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      Text('File type: ${uploadController.fileType.value}'),
                    ],
                  )
                : const SizedBox.shrink()),

            const SizedBox(height: 20),

            // Choose File Button
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              label: Text('Choose Image'),
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );

                if (image != null) {
                  uploadController.selectedImage.value = image;
                  await uploadController.uploadFileToCloudinary(image);
                }
              },
            ),

            const SizedBox(height: 16),

            // Submit Button
            Obx(() => uploadController.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: uploadController.imageUrl.isEmpty
                        ? null
                        : () async {
                            await uploadController.saveFileInfo();
                            // Optionally, you can add an explicit refresh
                            await uploadController.fetchFiles();
                          },
                    child: Text('Submit'),
                  )),
          ],
        ),
      ),
    );
  }
}
