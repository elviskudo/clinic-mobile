import 'package:clinic_ai/models/clinic_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../controllers/clinic_controller.dart';

class ClinicView extends GetView<ClinicController> {
  const ClinicView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showClinicDialog(context),
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Clinics'),
          centerTitle: true,
          actions: [],
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: controller.clinics.length,
                  itemBuilder: (context, index) {
                    final clinics = controller.clinics[index];
                    return ListTile(
                      title: Text(clinics.name ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(clinics.address),
                          Text(
                              'Contact: ${clinics.contactName} - ${clinics.contactPhone}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: 'edit',
                            onPressed: () =>
                                _showClinicDialog(context, category: clinics),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: 'delete',
                            onPressed: () =>
                                _showDeleteConfirmation(clinics.id!),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ));
  }

  void _showClinicDialog(BuildContext context, {Clinic? category}) {
    final nameController = TextEditingController(text: category?.name);
    final addressController = TextEditingController(text: category?.address);
    final accreditationController =
        TextEditingController(text: category?.accreditation);
    final contactNameController =
        TextEditingController(text: category?.contactName);
    final contactPhoneController =
        TextEditingController(text: category?.contactPhone);
    final contactEmailController =
        TextEditingController(text: category?.contactEmail);

    final isFormValid = RxBool(false);

    void validateForm() {
      isFormValid.value = nameController.text.trim().isNotEmpty &&
          addressController.text.trim().isNotEmpty &&
          accreditationController.text.trim().isNotEmpty &&
          contactNameController.text.trim().isNotEmpty &&
          contactPhoneController.text.trim().isNotEmpty &&
          contactEmailController.text.trim().isNotEmpty;
    }

    // Add listeners to all controllers
    nameController.addListener(validateForm);
    addressController.addListener(validateForm);
    accreditationController.addListener(validateForm);
    contactNameController.addListener(validateForm);
    contactPhoneController.addListener(validateForm);
    contactEmailController.addListener(validateForm);

    Get.dialog(
      AlertDialog(
        title: Text(category == null ? 'Add Clinic' : 'Edit Clinic'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Clinic Name'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
                maxLines: 2,
              ),
              TextField(
                controller: accreditationController,
                decoration: InputDecoration(labelText: 'Accreditation'),
              ),
              TextField(
                controller: contactNameController,
                decoration: InputDecoration(labelText: 'Contact Person'),
              ),
              TextField(
                controller: contactPhoneController,
                decoration: InputDecoration(labelText: 'Contact Phone'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: contactEmailController,
                decoration: InputDecoration(labelText: 'Contact Email'),
                keyboardType: TextInputType.emailAddress,
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
                        if (category == null) {
                          // Add new clinic
                          final newClinic = Clinic(
                            id: Uuid().v4(),
                            name: nameController.text.trim(),
                            address: addressController.text.trim(),
                            accreditation: accreditationController.text.trim(),
                            contactName: contactNameController.text.trim(),
                            contactPhone: contactPhoneController.text.trim(),
                            contactEmail: contactEmailController.text.trim(),
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now()
                          );
                          Get.find<ClinicController>().addClinics(newClinic);
                        } else {
                          // Update existing clinic
                          category.name = nameController.text.trim();
                          category.address = addressController.text.trim();
                          category.accreditation =
                              accreditationController.text.trim();
                          category.contactName =
                              contactNameController.text.trim();
                          category.contactPhone =
                              contactPhoneController.text.trim();
                          category.contactEmail =
                              contactEmailController.text.trim();
                          Get.find<ClinicController>().updateClinics(category);
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
        title: Text('Delete Category'),
        content: Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteClinics(id);
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
