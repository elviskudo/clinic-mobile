import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/upload_controller.dart';

class UploadView extends GetView<UploadController> {
  const UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Container(
          padding: EdgeInsets.only(top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('UploadView'),
                  Obx(() {
                    return DropdownButton(
                      // menuWidth: 50,
                      value: controller.selectedModuleClass.value.isNotEmpty
                          ? controller.selectedModuleClass.value
                          : 'all',
                      onChanged: (newValue) {
                        if (newValue != null) {
                          controller.selectedModuleClass.value = newValue;
                          controller.filterFiles(); // Apply filter
                        }
                      },
                      items: controller.moduleClasses
                          .map((moduleClass) => DropdownMenuItem(
                                value: moduleClass,
                                child: Text(moduleClass),
                              ))
                          .toList(),
                    );
                  }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => controller.showUploadDialog(context),
                    child: Container(
                      child: Icon(Icons.upload),
                    ),
                  ),
                  Gap(14),
                  InkWell(
                    onTap: () => controller.toggleEditMode(),
                    child: Container(
                      child: Icon(Icons.edit),
                    ),
                  ),
                  Gap(14),
                  InkWell(
                    onTap: () => controller.toggleDeleteMode(),
                    child: Container(
                      child: Icon(
                        Icons.delete,
                        color:
                            controller.isDeleteMode.value ? Colors.red : null,
                      ),
                    ),
                  ),
                  Gap(14),
                  Obx(() => controller.isDeleteMode.value &&
                          controller.selectedFilesForDeletion.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => controller.deleteSelectedFiles(),
                        )
                      : const SizedBox.shrink()),
                ],
              ),
              Gap(12)
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.filteredFileList.isEmpty) {
                return const Center(child: Text('No files available'));
              }
              return ListView.builder(
                itemCount: controller.filteredFileList.length,
                itemBuilder: (context, index) {
                  final file = controller.filteredFileList[index];
                  return Obx(
                    () => ListTile(
                      leading: controller.isDeleteMode.value
                          ? Checkbox(
                              value: controller.selectedFilesForDeletion
                                  .contains(file.id),
                              onChanged: (bool? value) {
                                controller.toggleFileSelection(file.id ?? '');
                              },
                            )
                          : (controller.isEditMode.value
                              ? IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => controller.editFile(file),
                                )
                              : null),
                      title: Text(
                          'Module Name: ${file.moduleName} (${file.moduleClass})'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Type: ${file.fileType}'),
                        ],
                      ),
                      trailing: controller.isDeleteMode.value
                          ? null // Remove trailing widget in delete mode
                          : Container(
                              width: 24,
                              height: 24,
                              child: Image.network(file.fileName ?? '')),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
