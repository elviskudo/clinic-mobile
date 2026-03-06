import 'package:clinic_ai/app/modules/(admin)/poly/controllers/poly_controller.dart'; // Sesuaikan path
import 'package:clinic_ai/models/clinic_model.dart';
import 'package:clinic_ai/models/poly_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class PolyView extends GetView<PolyController> {
  const PolyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPolyDialog(context),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Polies'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: controller.polies.length,
                itemBuilder: (context, index) {
                  final poly = controller.polies[index];
                  return ListTile(
                    title: Text(poly.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(poly.description),
                        Text(
                            'Status: ${poly.status == 1 ? 'Active' : 'Inactive'}'),
                        // Menampilkan nama klinik jika sudah di-join dari backend (Optional)
                        // Text('Clinic ID: ${poly.clinicId}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit',
                          onPressed: () => _showPolyDialog(context, poly: poly),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'Delete',
                          onPressed: () => _showDeleteConfirmation(poly.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showPolyDialog(BuildContext context, {Poly? poly}) {
    final nameController = TextEditingController(text: poly?.name);
    final descriptionController =
        TextEditingController(text: poly?.description);
    final statusController = RxInt(poly?.status ?? 1);

    // Set selected clinic
    if (poly != null) {
      controller.selectedClinicId.value = poly.clinicId;
    } else {
      controller.selectedClinicId.value = '';
    }

    final isFormValid = RxBool(false);

    void validateForm() {
      isFormValid.value = nameController.text.trim().isNotEmpty &&
          descriptionController.text.trim().isNotEmpty &&
          controller.selectedClinicId.value.isNotEmpty;
    }

    nameController.addListener(validateForm);
    descriptionController.addListener(validateForm);

    Get.dialog(
      AlertDialog(
        title: Text(poly == null ? 'Add Poly' : 'Edit Poly'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Poly Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedClinicId.value.isEmpty
                      ? null
                      : controller.selectedClinicId.value,
                  onChanged: (value) {
                    controller.selectedClinicId.value = value ?? '';
                    validateForm();
                  },
                  decoration:
                      const InputDecoration(labelText: 'Category (Clinic)'),
                  items: controller.clinics
                      .map((Clinic clinic) => DropdownMenuItem(
                            value: clinic.id,
                            child: Text(clinic.name ?? 'No Name'),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Status: '),
                  Obx(() => Switch(
                        value: statusController.value == 1,
                        onChanged: (value) {
                          statusController.value = value ? 1 : 0;
                        },
                      )),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => TextButton(
                onPressed: isFormValid.value
                    ? () {
                        if (poly == null) {
                          // Create
                          final newPoly = Poly(
                            id: const Uuid().v4(),
                            name: nameController.text.trim(),
                            description: descriptionController.text.trim(),
                            status: statusController.value,
                            clinicId: controller.selectedClinicId.value,
                            createdAt: DateTime.now()
                                .toIso8601String(), // Optional, BE usually handles this
                            updatedAt: DateTime.now().toIso8601String(),
                          );
                          Get.find<PolyController>().addPoly(newPoly);
                        } else {
                          // Update
                          poly.name = nameController.text.trim();
                          poly.description = descriptionController.text.trim();
                          poly.status = statusController.value;
                          poly.clinicId = controller.selectedClinicId.value;
                          Get.find<PolyController>().updatePoly(poly);
                        }
                        Get.back();
                      }
                    : null,
                child: const Text('Save'),
              )),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String id) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Poly'),
        content: const Text('Are you sure you want to delete this poly?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deletePoly(id);
              Get.back();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
