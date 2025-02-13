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
    // Inisialisasi ScheduleAppointmentController dan controller lainnya
    Get.put(ScheduleAppointmentController());
    Get.put(BarcodeAppointmentController());
    Get.put(SymptomAppointmentController());
    Get.put(CaptureAppointmentController());

    return GetBuilder<ScheduleAppointmentController>(
      init: Get.find<ScheduleAppointmentController>(),
      builder: (scheduleController) {
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
                tabs: const [
                  Tab(text: 'Schedule'),
                  Tab(text: 'QRCode'),
                  Tab(text: 'Symptom'),
                  Tab(text: 'Capture'),
                ],
                labelColor: const Color(0xFF35693E),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF35693E),
                onTap: (index) {
                  if (index != 0 && !scheduleController.isFormValid()) {
                    Get.snackbar(
                      'Warning',
                      'Please complete the Schedule form first.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    DefaultTabController.of(context)?.animateTo(0);
                  }
                },
              ),
            ),
            body: TabBarView(
              physics: scheduleController.isFormValid()
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              children: const [
                ScheduleAppointmentView(),
                BarcodeAppointmentView(),
                SymptomAppointmentView(),
                CaptureAppointmentView(),
              ],
            ),
          ),
        );
      },
    );
  }
}