import 'package:clinic_ai/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../controllers/doctor_controller.dart';

class DoctorView extends GetView<DoctorController> {
  const DoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDoctorDialog(context),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Doctors'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: controller.doctors.length,
                itemBuilder: (context, index) {
                  final doctor = controller.doctors[index];
                  return ListTile(
                    title: Text(doctor.degree),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doctor.description),
                        Text(
                            'Status: ${doctor.status == 1 ? 'Active' : 'Inactive'}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'edit',
                          onPressed: () =>
                              _showDoctorDialog(context, doctor: doctor),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'delete',
                          onPressed: () => _showDeleteConfirmation(doctor.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showDoctorDialog(BuildContext context, {Doctor? doctor}) {
    final nameController = TextEditingController(text: doctor?.degree);
    final descriptionController =
        TextEditingController(text: doctor?.description);
    final statusController = RxInt(doctor?.status ?? 1);

    // Set initial values for clinic and poly if editing
    if (doctor != null) {
      controller.selectedClinicId.value = doctor.clinicId;
      controller.selectedPolyId.value = doctor.polyId;
    } else {
      controller.selectedClinicId.value = '';
      controller.selectedPolyId.value = '';
    }

    final isFormValid = RxBool(false);

    void validateForm() {
      isFormValid.value = nameController.text.trim().isNotEmpty &&
          descriptionController.text.trim().isNotEmpty &&
          controller.selectedClinicId.value.isNotEmpty &&
          controller.selectedPolyId.value.isNotEmpty;
    }

    nameController.addListener(validateForm);
    descriptionController.addListener(validateForm);

    Get.dialog(
      AlertDialog(
        title: Text(doctor == null ? 'Add Doctor' : 'Edit Doctor'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Doctor Name'),
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
                  onChanged: (value) {
                    controller.selectedClinicId.value = value ?? '';
                    validateForm();
                  },
                  decoration: const InputDecoration(labelText: 'Clinic'),
                  items: controller.clinics
                      .map((clinic) => DropdownMenuItem(
                            value: clinic.id,
                            child: Text(clinic.name),
                          ))
                      .toList(),
                ),
              ),
              SizedBox(height: 10),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedUserId.value.isEmpty
                      ? null
                      : controller.selectedUserId.value,
                  onChanged: (value) {
                    controller.selectedUserId.value = value ?? '';
                    validateForm();
                  },
                  decoration: const InputDecoration(labelText: 'Users'),
                  items: controller.users
                      .map((poly) => DropdownMenuItem(
                            value: poly.id,
                            child: Text(poly.name),
                          ))
                      .toList(),
                ),
              ),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedPolyId.value.isEmpty
                      ? null
                      : controller.selectedPolyId.value,
                  onChanged: (value) {
                    controller.selectedPolyId.value = value ?? '';
                    validateForm();
                  },
                  decoration: const InputDecoration(labelText: 'Poly'),
                  items: controller.polies
                      .map((poly) => DropdownMenuItem(
                            value: poly.id,
                            child: Text(poly.name),
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
                        if (doctor == null) {
                          final newDoctor = Doctor(
                            id: controller.selectedUserId.value,
                            degree: nameController.text.trim(),
                            description: descriptionController.text.trim(),
                            status: statusController.value,
                            clinicId: controller.selectedClinicId.value,
                            polyId: controller.selectedPolyId.value,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          );
                          Get.find<DoctorController>().addDoctor(newDoctor);
                        } else {
                          doctor.id = controller.selectedUserId.value;
                          doctor.degree = nameController.text.trim();
                          doctor.description =
                              descriptionController.text.trim();
                          doctor.status = statusController.value;
                          doctor.clinicId = controller.selectedClinicId.value;
                          doctor.polyId = controller.selectedPolyId.value;
                          Get.find<DoctorController>().updateDoctor(doctor);
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
        title: Text('Delete Doctor'),
        content: Text('Are you sure you want to delete this doctor?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteDoctor(id);
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
