import 'package:clinic_ai/models/scheduleDate_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../controllers/schedule_date_controller.dart';

class ScheduleDateView extends GetView<ScheduleDateController> {
  const ScheduleDateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showScheduleDateDialog(context),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Schedule Dates'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: controller.scheduleDates.length,
                itemBuilder: (context, index) {
                  final scheduleDate = controller.scheduleDates[index];
                  final doctor = controller.doctors
                      .firstWhere((d) => d.id == scheduleDate.doctorId);
                  final poly = controller.polies
                      .firstWhere((p) => p.id == scheduleDate.polyId);

                  return ListTile(
                    title: Text('${doctor.degree} - ${poly.name}'),
                    subtitle: Text(
                        'Date: ${scheduleDate.scheduleDate.toString().split(' ')[0]}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'edit',
                          onPressed: () => _showScheduleDateDialog(context,
                              scheduleDate: scheduleDate),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'delete',
                          onPressed: () =>
                              _showDeleteConfirmation(scheduleDate.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showScheduleDateDialog(BuildContext context,
      {ScheduleDate? scheduleDate}) {
    // Menggunakan RxString untuk menyimpan tanggal yang dipilih
    final selectedDate =
        Rx<DateTime>(scheduleDate?.scheduleDate ?? DateTime.now());

    // Set initial values for poly and doctor if editing
    if (scheduleDate != null) {
      controller.selectedPolyId.value = scheduleDate.polyId;
      controller.selectedDoctorId.value = scheduleDate.doctorId;
    } else {
      controller.selectedPolyId.value = '';
      controller.selectedDoctorId.value = '';
    }

    final isFormValid = RxBool(false);

    void validateForm() {
      isFormValid.value = controller.selectedPolyId.value.isNotEmpty &&
          controller.selectedDoctorId.value.isNotEmpty;
    }

    Get.dialog(
      AlertDialog(
        title: Text(
            scheduleDate == null ? 'Add Schedule Date' : 'Edit Schedule Date'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Menggunakan Obx untuk memperbarui tampilan tanggal
              Obx(() => ListTile(
                    title: Text(
                        "Date: ${selectedDate.value.toString().split(' ')[0]}"),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate.value,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (picked != null) {
                        selectedDate.value = picked;
                        print('New date selected: ${selectedDate.value}');
                      }
                    },
                  )),
              SizedBox(height: 10),
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
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedDoctorId.value.isEmpty
                      ? null
                      : controller.selectedDoctorId.value,
                  onChanged: (value) {
                    controller.selectedDoctorId.value = value ?? '';
                    validateForm();
                  },
                  decoration: const InputDecoration(labelText: 'Doctor'),
                  items: controller.doctors
                      .map((doctor) => DropdownMenuItem(
                            value: doctor.id,
                            child: Text(doctor.degree),
                          ))
                      .toList(),
                ),
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
                        if (scheduleDate == null) {
                          final newScheduleDate = ScheduleDate(
                            id: Uuid().v4(),
                            polyId: controller.selectedPolyId.value,
                            doctorId: controller.selectedDoctorId.value,
                            scheduleDate: selectedDate
                                .value, // Menggunakan .value dari Rx
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          );
                          controller.addScheduleDate(newScheduleDate);
                        } else {
                          scheduleDate.polyId = controller.selectedPolyId.value;
                          scheduleDate.doctorId =
                              controller.selectedDoctorId.value;
                          scheduleDate.scheduleDate =
                              selectedDate.value; // Menggunakan .value dari Rx
                          scheduleDate.updatedAt = DateTime.now();
                          controller.updateScheduleDate(scheduleDate);
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
        title: Text('Delete Schedule Date'),
        content: Text('Are you sure you want to delete this schedule date?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteScheduleDate(id);
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
