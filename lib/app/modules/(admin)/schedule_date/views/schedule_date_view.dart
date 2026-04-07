import 'package:clinic_ai/models/doctor_model.dart';
import 'package:clinic_ai/models/poly_model.dart';
import 'package:clinic_ai/models/scheduleDate_model.dart';
import 'package:clinic_ai/models/scheduleTime_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../controllers/schedule_date_controller.dart';
// Import controller time
import '../../schedule_time/controllers/schedule_time_controller.dart';

class ScheduleDateView extends GetView<ScheduleDateController> {
  const ScheduleDateView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil controller Time
    final ScheduleTimeController timeController =
        Get.find<ScheduleTimeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showScheduleDateDialog(context),
        label: const Text("New Schedule"),
        icon: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Doctor Schedules'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.loadAllData();
              timeController.getScheduleTimes();
            },
          )
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value || timeController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.scheduleDates.isEmpty) {
            return const Center(child: Text("No schedules found"));
          }

          return ListView.builder(
            itemCount: controller.scheduleDates.length,
            padding: const EdgeInsets.only(bottom: 80), // Space for FAB
            itemBuilder: (context, index) {
              final scheduleDate = controller.scheduleDates[index];

              // --- Cari Data Relasi ---
              final Doctor doctor = controller.doctors.firstWhere(
                (d) => d.id == scheduleDate.doctorId,
                orElse: () => Doctor(
                    id: '',
                    name: 'Unknown',
                    degree: '',
                    specialize: '',
                    clinicId: '',
                    polyId: '',
                    description: '',
                    status: 0,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now()),
              );

              final Poly poly = controller.polies.firstWhere(
                (p) => p.id == scheduleDate.polyId,
                orElse: () => Poly(
                    id: '',
                    name: 'Unknown',
                    clinicId: '',
                    description: '',
                    status: 0,
                    createdAt: '',
                    updatedAt: ''),
              );

              // --- Filter Waktu ---
              final myTimes = timeController.scheduleTimes
                  .where((t) => t.dateId == scheduleDate.id)
                  .toList();

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.white,
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: const Icon(Icons.calendar_month, color: Colors.blue),
                  ),
                  title: Text(
                    '${doctor.name} (${poly.name})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1, // FIX OVERFLOW: Batasi 1 baris
                    overflow: TextOverflow
                        .ellipsis, // FIX OVERFLOW: Tambahkan titik-titik
                  ),
                  subtitle: Text(
                    'Date: ${scheduleDate.scheduleDate.toString().split(' ')[0]}\n${myTimes.length} Time Slots',
                  ),
                  children: [
                    // --- List Waktu ---
                    if (myTimes.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("No time slots yet. Add one!",
                            style: TextStyle(color: Colors.grey)),
                      )
                    else
                      ...myTimes.map((time) => ListTile(
                            dense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 24),
                            leading: const Icon(Icons.access_time,
                                size: 20, color: Colors.teal),
                            title: Text(time.scheduleTime,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  size: 20, color: Colors.red),
                              onPressed: () => _showDeleteTimeConfirmation(
                                  time.id, timeController),
                            ),
                          )),

                    const Divider(),

                    // --- Action Buttons (FIX OVERFLOW) ---
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      // GANTI ROW DENGAN WRAP
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 8.0, // Jarak horizontal
                        runSpacing: 8.0, // Jarak vertikal jika turun baris
                        children: [
                          // Tombol Delete
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            icon: const Icon(Icons.delete, size: 18),
                            label: const Text("Delete"),
                            onPressed: () =>
                                _showDeleteConfirmation(scheduleDate.id),
                          ),
                          // Tombol Edit
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange,
                              side: const BorderSide(color: Colors.orange),
                            ),
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text("Edit"),
                            onPressed: () => _showScheduleDateDialog(context,
                                scheduleDate: scheduleDate),
                          ),
                          // Tombol Add Time
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.add_alarm, size: 18),
                            label: const Text("Add Time"),
                            onPressed: () => _showScheduleTimeDialog(
                                context, scheduleDate.id, timeController),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // --- DIALOG DATE ---
  void _showScheduleDateDialog(BuildContext context,
      {ScheduleDate? scheduleDate}) {
    final selectedDate =
        Rx<DateTime>(scheduleDate?.scheduleDate ?? DateTime.now());

    // Set initial values
    if (scheduleDate != null) {
      if (controller.polies.any((p) => p.id == scheduleDate.polyId)) {
        controller.selectedPolyId.value = scheduleDate.polyId;
      }
      if (controller.doctors.any((d) => d.id == scheduleDate.doctorId)) {
        controller.selectedDoctorId.value = scheduleDate.doctorId;
      }
    } else {
      controller.selectedPolyId.value = '';
      controller.selectedDoctorId.value = '';
    }

    final isFormValid = RxBool(false);
    void validateForm() {
      isFormValid.value = controller.selectedPolyId.value.isNotEmpty &&
          controller.selectedDoctorId.value.isNotEmpty;
    }

    if (scheduleDate != null) validateForm();

    Get.dialog(
      AlertDialog(
        title: Text(scheduleDate == null
            ? '1. Create Schedule Date'
            : 'Edit Schedule Date'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Date Picker
              Obx(() => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                        "Date: ${selectedDate.value.toString().split(' ')[0]}"),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate.value,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) selectedDate.value = picked;
                    },
                  )),
              const SizedBox(height: 10),

              // Dropdown Poly
              Obx(() => DropdownButtonFormField<String>(
                    isExpanded: true, // Agar tidak overflow horizontal
                    initialValue: controller.selectedPolyId.value.isEmpty
                        ? null
                        : controller.selectedPolyId.value,
                    onChanged: (value) {
                      controller.selectedPolyId.value = value ?? '';
                      validateForm();
                    },
                    decoration: const InputDecoration(
                        labelText: 'Poly', border: OutlineInputBorder()),
                    items: controller.polies
                        .map((poly) => DropdownMenuItem(
                            value: poly.id,
                            child: Text(poly.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1 // FIX OVERFLOW
                                )))
                        .toList(),
                  )),
              const SizedBox(height: 10),

              // Dropdown Doctor (FIX OVERFLOW)
              Obx(() => DropdownButtonFormField<String>(
                    isExpanded: true, // Wajib true agar teks bisa dipotong
                    initialValue: controller.selectedDoctorId.value.isEmpty
                        ? null
                        : controller.selectedDoctorId.value,
                    onChanged: (value) {
                      controller.selectedDoctorId.value = value ?? '';
                      validateForm();
                    },
                    decoration: const InputDecoration(
                        labelText: 'Doctor', border: OutlineInputBorder()),
                    items: controller.doctors
                        .map((doctor) => DropdownMenuItem(
                              value: doctor.id,
                              child: Text(
                                '${doctor.name} - ${doctor.specialize}',
                                overflow: TextOverflow
                                    .ellipsis, // Potong teks panjang
                                maxLines: 1, // Pastikan cuma 1 baris
                              ),
                            ))
                        .toList(),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          Obx(() => ElevatedButton(
                onPressed: isFormValid.value
                    ? () async {
                        final String newId =
                            scheduleDate?.id ?? const Uuid().v4();

                        if (scheduleDate == null) {
                          // CREATE
                          final newSchedule = ScheduleDate(
                            id: newId,
                            polyId: controller.selectedPolyId.value,
                            doctorId: controller.selectedDoctorId.value,
                            scheduleDate: selectedDate.value,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          );
                          await controller.addScheduleDate(newSchedule);
                          Get.back(); // Tutup dialog date

                          // Auto open Time Dialog
                          final timeCtrl = Get.find<ScheduleTimeController>();
                          _showScheduleTimeDialog(context, newId, timeCtrl,
                              isAutoOpen: true);
                        } else {
                          // UPDATE
                          scheduleDate.polyId = controller.selectedPolyId.value;
                          scheduleDate.doctorId =
                              controller.selectedDoctorId.value;
                          scheduleDate.scheduleDate = selectedDate.value;
                          scheduleDate.updatedAt = DateTime.now();
                          await controller.updateScheduleDate(scheduleDate);
                          Get.back();
                        }
                      }
                    : null,
                child: Text(scheduleDate == null ? 'Next: Add Time' : 'Save'),
              )),
        ],
      ),
    );
  }

  // --- DIALOG TIME ---
  void _showScheduleTimeDialog(
      BuildContext context, String dateId, ScheduleTimeController timeCtrl,
      {bool isAutoOpen = false}) {
    final startTime = Rx<TimeOfDay>(const TimeOfDay(hour: 8, minute: 0));
    final endTime = Rx<TimeOfDay>(const TimeOfDay(hour: 9, minute: 0));

    Get.dialog(
      AlertDialog(
        title: Text(isAutoOpen ? '2. Add Time Slot' : 'Add Schedule Time'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isAutoOpen)
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text("Date saved! Now add the time.",
                    style: TextStyle(color: Colors.green, fontSize: 13)),
              ),

            // Start Time
            Obx(() => ListTile(
                  title: Text("Start: ${startTime.value.format(context)}"),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final t = await showTimePicker(
                        context: context, initialTime: startTime.value);
                    if (t != null) startTime.value = t;
                  },
                )),

            // End Time
            Obx(() => ListTile(
                  title: Text("End: ${endTime.value.format(context)}"),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final t = await showTimePicker(
                        context: context, initialTime: endTime.value);
                    if (t != null) endTime.value = t;
                  },
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(isAutoOpen ? 'Skip' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final startStr =
                  '${startTime.value.hour.toString().padLeft(2, '0')}:${startTime.value.minute.toString().padLeft(2, '0')}';
              final endStr =
                  '${endTime.value.hour.toString().padLeft(2, '0')}:${endTime.value.minute.toString().padLeft(2, '0')}';
              final timeRange = '$startStr - $endStr';

              final newTime = ScheduleTime(
                id: const Uuid().v4(),
                dateId: dateId,
                scheduleTime: timeRange,
                createdAt: DateTime.now().toIso8601String(),
                updatedAt: DateTime.now().toIso8601String(),
              );

              await timeCtrl.addScheduleTime(newTime);
              Get.back();
              Get.snackbar("Success", "Time added successfully");
            },
            child: const Text('Add Time'),
          )
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String id) {
    Get.dialog(AlertDialog(
      title: const Text('Delete Date'),
      content: const Text('Delete this schedule date and all its times?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            controller.deleteScheduleDate(id);
            Get.back();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ));
  }

  void _showDeleteTimeConfirmation(String id, ScheduleTimeController timeCtrl) {
    Get.dialog(AlertDialog(
      title: const Text('Delete Time'),
      content: const Text('Remove this time slot?'),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            timeCtrl.deleteScheduleTime(id);
            Get.back();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ));
  }
}
