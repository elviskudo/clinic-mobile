import 'package:clinic_ai/components/UploadDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../controllers/upload_controller.dart';

class UploadView extends GetView<UploadController> {
  const UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        toolbarHeight: 110,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 16,
        title: Container(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- ROW 1: TITLE & FILTER ---
              Row(
                children: [
                  const Text(
                    'UploadView',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Spacer(),
                  // Filter Dropdown
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Obx(() {
                      var dropdownValue =
                          controller.selectedModuleClass.value.isNotEmpty
                              ? controller.selectedModuleClass.value
                              : 'all';

                      if (!controller.moduleClasses.contains(dropdownValue)) {
                        dropdownValue = 'all';
                      }

                      return DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 13),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              controller.selectedModuleClass.value = newValue;
                              controller.filterFiles();
                            }
                          },
                          items: controller.moduleClasses.map((moduleClass) {
                            return DropdownMenuItem(
                              value: moduleClass,
                              child: Text(moduleClass.toUpperCase()),
                            );
                          }).toList(),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const Gap(16),

              // --- ROW 2: ACTION BUTTONS ---
              Obx(() => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildActionButton(
                          icon: Icons.upload_file,
                          label: "Upload",
                          onTap: () => controller.showUploadDialog(context),
                          isActive: true,
                          activeColor: Colors.blue,
                          contentColor: Colors.white,
                        ),
                        const Gap(10),
                        _buildActionButton(
                          icon: Icons.edit,
                          label: "Edit",
                          onTap: () => controller.toggleEditMode(),
                          isActive: controller.isEditMode.value,
                          activeColor: Colors.orange,
                          contentColor: Colors.white,
                        ),
                        const Gap(10),
                        _buildActionButton(
                          icon: Icons.delete,
                          label: "Delete",
                          onTap: () => controller.toggleDeleteMode(),
                          isActive: controller.isDeleteMode.value,
                          activeColor: Colors.red,
                          contentColor: Colors.white,
                        ),
                        // Confirm Delete Button
                        if (controller.isDeleteMode.value &&
                            controller.selectedFilesForDeletion.isNotEmpty) ...[
                          const Gap(10),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.check, size: 16),
                            label: Text(
                                "Confirm (${controller.selectedFilesForDeletion.length})"),
                            onPressed: () => controller.deleteSelectedFiles(),
                          ),
                        ]
                      ],
                    ),
                  )),
              const Gap(8),
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
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open,
                          size: 60, color: Colors.grey.shade300),
                      const Gap(10),
                      Text(
                        'No files found for "${controller.selectedModuleClass.value}"',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemCount: controller.filteredFileList.length,
                itemBuilder: (context, index) {
                  final file = controller.filteredFileList[index];
                  return Obx(() => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: controller.isDeleteMode.value
                            ? Checkbox(
                                activeColor: Colors.red,
                                value: controller.selectedFilesForDeletion
                                    .contains(file.id),
                                onChanged: (_) => controller
                                    .toggleFileSelection(file.id ?? ''),
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                  image: (file.fileName != null &&
                                          file.fileName!.startsWith('http'))
                                      ? DecorationImage(
                                          image: NetworkImage(file.fileName!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: (file.fileName == null ||
                                        !file.fileName!.startsWith('http'))
                                    ? const Icon(Icons.description,
                                        color: Colors.grey)
                                    : null,
                              ),
                        title: Text(
                          file.moduleName ?? 'Unknown',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${file.moduleClass} • ${file.fileType}',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                        ),
                        trailing: controller.isEditMode.value
                            ? IconButton(
                                icon: const Icon(Icons.edit_outlined,
                                    color: Colors.orange),
                                onPressed: () {
                                  controller.editFile(file);
                                },
                              )
                            : null,
                      ));
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
    Color activeColor = Colors.blue,
    Color contentColor = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? activeColor : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? contentColor : Colors.grey.shade700,
            ),
            const Gap(8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? contentColor : Colors.grey.shade700,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}