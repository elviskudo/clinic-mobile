// import 'package:clinic_ai/model/clinicsModel.dart';
import 'package:clinic_ai/model/poliesModel.dart';
import 'package:clinic_ai/models/clinic_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../controllers/poly_controller.dart';

class PolyView extends GetView<PolyController> {
  const PolyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPolyDialog(context),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Polies'),
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
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'edit',
                          onPressed: () => _showPolyDialog(context, poly: poly),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'delete',
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

  void _showPolyDialog(BuildContext context, {Polies? poly}) {
    final nameController = TextEditingController(text: poly?.name);
    final descriptionController =
        TextEditingController(text: poly?.description);
    final statusController = RxInt(poly?.status ?? 1);

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
                decoration: InputDecoration(labelText: 'Poly Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedClinicId.value.isEmpty
                      ? null
                      : controller.selectedClinicId.value,
                  onChanged: (value) =>
                      controller.selectedClinicId.value = value ?? '',
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: controller.clinics
                      .map((Clinic category) => DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name.toString()),
                          ))
                      .toList(),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Status: '),
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
            child: Text('Cancel'),
          ),
          Obx(() => TextButton(
                onPressed: isFormValid.value
                    ? () {
                        if (poly == null) {
                          final newPoly = Polies(
                            id: Uuid().v4(),
                            name: nameController.text.trim(),
                            description: descriptionController.text.trim(),
                            status: statusController.value,
                            clinicId: controller.selectedClinicId.value,
                          );
                          Get.find<PolyController>().addPoly(newPoly);
                        } else {
                          poly.name = nameController.text.trim();
                          poly.description = descriptionController.text.trim();
                          poly.status = statusController.value;
                          poly.clinicId = controller.selectedClinicId.value;
                          Get.find<PolyController>().updatePoly(poly);
                        }
                        Get.back();
                      }
                    : null,
                child: Text('Save'),
              )),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String id) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Poly'),
        content: Text('Are you sure you want to delete this poly?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deletePoly(id);
              Get.back();
            },
            child: Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
