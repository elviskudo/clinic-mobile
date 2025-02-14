import 'package:clinic_ai/models/scheduleTime_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../controllers/schedule_time_controller.dart';

class ScheduleTimeView extends GetView<ScheduleTimeController> {
  const ScheduleTimeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showScheduleTimeDialog(context),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Schedule Times'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: controller.scheduleTimes.length,
                itemBuilder: (context, index) {
                  final scheduleTime = controller.scheduleTimes[index];
                  final scheduleDate = controller.scheduleDates
                      .firstWhere((d) => d.id == scheduleTime.dateId);
                  
                  return ListTile(
                    title: Text('Time: ${scheduleTime.scheduleTime}'),
                    subtitle: Text(
                        'Date: ${scheduleDate.scheduleDate.toString().split(' ')[0]}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'edit',
                          onPressed: () =>
                              _showScheduleTimeDialog(context, scheduleTime: scheduleTime),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'delete',
                          onPressed: () => _showDeleteConfirmation(scheduleTime.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showScheduleTimeDialog(BuildContext context, {ScheduleTime? scheduleTime}) {
    TimeOfDay selectedTime = scheduleTime != null
        ? TimeOfDay(
            hour: int.parse(scheduleTime.scheduleTime.split(':')[0]),
            minute: int.parse(scheduleTime.scheduleTime.split(':')[1]))
        : TimeOfDay.now();

    // Set initial values if editing
    if (scheduleTime != null) {
      controller.selectedDateId.value = scheduleTime.dateId;
    } else {
      controller.selectedDateId.value = '';
    }

    final isFormValid = RxBool(false);

    void validateForm() {
      isFormValid.value = controller.selectedDateId.value.isNotEmpty;
    }

    Get.dialog(
      AlertDialog(
        title: Text(scheduleTime == null ? 'Add Schedule Time' : 'Edit Schedule Time'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Time: ${selectedTime.format(context)}"),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null) {
                    selectedTime = picked;
                  }
                },
              ),
              SizedBox(height: 10),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedDateId.value.isEmpty
                      ? null
                      : controller.selectedDateId.value,
                  onChanged: (value) {
                    controller.selectedDateId.value = value ?? '';
                    validateForm();
                  },
                  decoration: const InputDecoration(labelText: 'Schedule Date'),
                  items: controller.scheduleDates
                      .map((date) => DropdownMenuItem(
                            value: date.id,
                            child: Text(date.scheduleDate.toString().split(' ')[0]),
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
                        final timeString = 
                            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                        
                        if (scheduleTime == null) {
                          final newScheduleTime = ScheduleTime(
                            id: Uuid().v4(),
                            dateId: controller.selectedDateId.value,
                            scheduleTime: timeString,
                            createdAt: DateTime.now().toIso8601String(),
                            updatedAt: DateTime.now().toIso8601String(),
                          );
                          controller.addScheduleTime(newScheduleTime);
                        } else {
                          scheduleTime.dateId = controller.selectedDateId.value;
                          scheduleTime.scheduleTime = timeString;
                          scheduleTime.updatedAt = DateTime.now().toIso8601String();
                          controller.updateScheduleTime(scheduleTime);
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
        title: Text('Delete Schedule Time'),
        content: Text('Are you sure you want to delete this schedule time?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteScheduleTime(id);
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