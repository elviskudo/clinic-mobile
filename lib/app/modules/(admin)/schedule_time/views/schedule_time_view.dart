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
            : controller.scheduleTimes.isEmpty
                ? Center(child: Text('No schedule times available'))
                : ListView.builder(
                    itemCount: controller.scheduleTimes.length,
                    itemBuilder: (context, index) {
                      final scheduleTime = controller.scheduleTimes[index];
                      // Cek apakah dateId valid dan ada di scheduleDates
                      final scheduleDate = controller.scheduleDates
                          .firstWhereOrNull((d) => d.id == scheduleTime.dateId);

                      if (scheduleDate == null) {
                        return ListTile(
                          title: Text('Time: ${scheduleTime.scheduleTime}'),
                          subtitle: Text('Invalid schedule date reference'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: 'delete',
                            onPressed: () =>
                                _showDeleteConfirmation(scheduleTime.id),
                          ),
                        );
                      }

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
                              onPressed: () => _showScheduleTimeDialog(context,
                                  scheduleTime: scheduleTime),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'delete',
                              onPressed: () =>
                                  _showDeleteConfirmation(scheduleTime.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  void _showScheduleTimeDialog(BuildContext context,
      {ScheduleTime? scheduleTime}) {
    // Parse existing time range if editing
    TimeOfDay startTime;
    TimeOfDay endTime;

    if (scheduleTime != null) {
      // Parse the existing time range like "08:00 - 10:00"
      final parts = scheduleTime.scheduleTime.split(' - ');
      if (parts.length == 2) {
        startTime = TimeOfDay(
            hour: int.parse(parts[0].split(':')[0]),
            minute: int.parse(parts[0].split(':')[1]));
        endTime = TimeOfDay(
            hour: int.parse(parts[1].split(':')[0]),
            minute: int.parse(parts[1].split(':')[1]));
      } else {
        // Fallback if format is not as expected
        startTime = TimeOfDay.now();
        endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0);
      }
    } else {
      // Default values for new schedule time
      startTime = TimeOfDay.now();
      endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0);
    }

    // Use Rx to track changes
    final selectedStartTime = Rx<TimeOfDay>(startTime);
    final selectedEndTime = Rx<TimeOfDay>(endTime);

    // Set initial values if editing
    if (scheduleTime != null) {
      controller.selectedDateId.value = scheduleTime.dateId;
    } else {
      controller.selectedDateId.value = controller.scheduleDates.isNotEmpty
          ? controller.scheduleDates[0].id
          : '';
    }

    bool _isTimeRangeValid(TimeOfDay start, TimeOfDay end) {
      final startMinutes = start.hour * 60 + start.minute;
      final endMinutes = end.hour * 60 + end.minute;
      return endMinutes > startMinutes; // End time must be after start time
    }

    final isFormValid = RxBool(controller.selectedDateId.value.isNotEmpty &&
        _isTimeRangeValid(selectedStartTime.value, selectedEndTime.value));

    void validateForm() {
      isFormValid.value = controller.selectedDateId.value.isNotEmpty &&
          _isTimeRangeValid(selectedStartTime.value, selectedEndTime.value);
    }

    // Function to validate time range

    // Check if there are schedule dates
    if (controller.scheduleDates.isEmpty) {
      Get.snackbar(
        'Error',
        'No schedule dates available. Please add schedule dates first.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        title: Text(
            scheduleTime == null ? 'Add Schedule Time' : 'Edit Schedule Time'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Start Time Selection
              Obx(() => ListTile(
                    title: Text(
                        "Start Time: ${selectedStartTime.value.format(context)}"),
                    trailing: Icon(Icons.access_time),
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedStartTime.value,
                      );
                      if (picked != null) {
                        selectedStartTime.value = picked;
                        validateForm();
                      }
                    },
                  )),

              // End Time Selection
              Obx(() => ListTile(
                    title: Text(
                        "End Time: ${selectedEndTime.value.format(context)}"),
                    trailing: Icon(Icons.access_time),
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedEndTime.value,
                      );
                      if (picked != null) {
                        selectedEndTime.value = picked;
                        validateForm();
                      }
                    },
                  )),

              // Validation error message
              Obx(() => !_isTimeRangeValid(
                      selectedStartTime.value, selectedEndTime.value)
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'End time must be after start time',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    )
                  : SizedBox.shrink()),

              SizedBox(height: 10),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedDateId.value.isEmpty
                      ? null
                      : controller.selectedDateId.value,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedDateId.value = value;
                      validateForm();
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Schedule Date'),
                  items: controller.scheduleDates
                      .map((date) => DropdownMenuItem(
                            value: date.id,
                            child: Text(
                                '${date.scheduleDate.toString().split(' ')[0]}'),
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
                        // Verify that dateId is valid
                        final dateExists = controller.scheduleDates.any(
                            (date) =>
                                date.id == controller.selectedDateId.value);

                        if (!dateExists) {
                          Get.snackbar(
                            'Error',
                            'Selected schedule date is invalid',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        // Format start time with leading zeros for hour and minute
                        final startTimeString =
                            '${selectedStartTime.value.hour.toString().padLeft(2, '0')}:${selectedStartTime.value.minute.toString().padLeft(2, '0')}';

                        // Format end time with leading zeros for hour and minute
                        final endTimeString =
                            '${selectedEndTime.value.hour.toString().padLeft(2, '0')}:${selectedEndTime.value.minute.toString().padLeft(2, '0')}';

                        // Combined time range as a single string
                        final timeRangeString =
                            '$startTimeString - $endTimeString';

                        if (scheduleTime == null) {
                          final newScheduleTime = ScheduleTime(
                            id: Uuid().v4(),
                            dateId: controller.selectedDateId.value,
                            scheduleTime: timeRangeString, // Combine both times
                            createdAt: DateTime.now().toIso8601String(),
                            updatedAt: DateTime.now().toIso8601String(),
                          );
                          controller.addScheduleTime(newScheduleTime);
                        } else {
                          scheduleTime.dateId = controller.selectedDateId.value;
                          scheduleTime.scheduleTime =
                              timeRangeString; // Combine both times
                          scheduleTime.updatedAt =
                              DateTime.now().toIso8601String();
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
