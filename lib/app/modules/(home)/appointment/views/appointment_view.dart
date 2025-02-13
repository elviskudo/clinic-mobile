import 'package:clinic_ai/app/modules/(home)/appointment/controllers/appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/barcodeAppointment/controllers/barcode_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/barcodeAppointment/views/barcode_appointment_view.dart';
import 'package:clinic_ai/app/modules/(home)/captureAppointment/controllers/capture_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/captureAppointment/views/capture_appointment_view.dart';
import 'package:clinic_ai/app/modules/(home)/scheduleAppointment/controllers/schedule_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/scheduleAppointment/views/schedule_appointment_view.dart';
import 'package:clinic_ai/app/modules/(home)/symptomAppointment/controllers/symptom_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/symptomAppointment/views/symptom_appointment_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentView extends GetView<AppointmentController> {
  AppointmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controller sudah diinisialisasi di tempat lain (misalnya, binding atau main.dart)
    final scheduleController = Get.find<ScheduleAppointmentController>();
    final barcodeController = Get.find<BarcodeAppointmentController>();
    final symptomController = Get.find<SymptomAppointmentController>();
    final captureController = Get.find<CaptureAppointmentController>();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FBF2),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'Appointment',
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Obx(
                      () => Text(
                    'Schedule',
                    style: TextStyle(
                      color: scheduleController.isFormValid.value
                          ? Colors.green
                          : const Color(0xFF35693E),
                    ),
                  ),
                ),
              ),
              Tab(
                child: Obx(() => Text(
                  'QRCode',
                  style: TextStyle(
                    color: barcodeController.isAccessible.value ? const Color(0xFF35693E) : Colors.grey,
                  ),
                )),
              ),
              Tab(
                child: Obx(() => Text(
                  'Symptom',
                  style: TextStyle(
                    color: symptomController.isAccessible.value ? const Color(0xFF35693E) : Colors.grey,
                  ),
                )),
              ),
              Tab(
                child: Obx(() => Text(
                  'Capture',
                  style: TextStyle(
                    color: captureController.isAccessible.value ? const Color(0xFF35693E) : Colors.grey,
                  ),
                )),
              ),
            ],
            labelColor: const Color(0xFF35693E),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF35693E),
            onTap: (index) {
              // Menggunakan Builder untuk mendapatkan konteks yang benar
              Builder(
                builder: (BuildContext context) {
                  if (index > 0 && !scheduleController.isFormValid.value) {
                    Get.snackbar(
                      'Warning',
                      'Please complete the Schedule form first.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    DefaultTabController.of(context)?.animateTo(0);
                    return const SizedBox.shrink(); // Tambahkan return value
                  }

                  if (index == 1 && !barcodeController.isAccessible.value) {
                    Get.snackbar(
                      'Information',
                      'QRCode is not accessible. Please complete the previous steps.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    DefaultTabController.of(context)?.animateTo(0);
                    return const SizedBox.shrink(); // Tambahkan return value
                  }

                  if (index == 2 && !symptomController.isAccessible.value) {
                    Get.snackbar(
                      'Information',
                      'Symptom is not accessible. Please complete the previous steps.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    DefaultTabController.of(context)?.animateTo(1);
                    return const SizedBox.shrink(); // Tambahkan return value
                  }
                  if (index == 3 && !captureController.isAccessible.value) {
                    Get.snackbar(
                      'Information',
                      'Capture is not accessible. Please complete the previous steps.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    DefaultTabController.of(context)?.animateTo(2);
                    return const SizedBox.shrink(); // Tambahkan return value
                  }
                  return const SizedBox.shrink(); // Tambahkan return value
                },
              );
            },
          ),
        ),
        body: TabBarView( // Ganti PageView dengan TabBarView
          physics: NeverScrollableScrollPhysics(),
          children: [
            ScheduleAppointmentView(),
            BarcodeAppointmentView(),
            SymptomAppointmentView(),
            CaptureAppointmentView(),
          ],
        ),
      ),
    );
  }
}