import 'package:clinic_ai/app/modules/appointment/controllers/appointment_controller.dart';
import 'package:clinic_ai/app/modules/barcodeAppointment/views/barcode_appointment_view.dart';
import 'package:clinic_ai/app/modules/captureAppointment/views/capture_appointment_view.dart';
import 'package:clinic_ai/app/modules/scheduleAppointment/controllers/schedule_appointment_controller.dart';
import 'package:clinic_ai/app/modules/scheduleAppointment/views/schedule_appointment_view.dart';
import 'package:clinic_ai/app/modules/symptomAppointment/views/symptom_appointment_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentView extends GetView<AppointmentController> {
  AppointmentView({super.key});

  final scheduleController = Get.put(ScheduleAppointmentController());

  @override
  Widget build(BuildContext context) {
    return GetX<ScheduleAppointmentController>(
      init: scheduleController,
      builder: (controller) {
        return DefaultTabController(
          length: 4, // Jumlah tab
          child: Scaffold(
            backgroundColor: const Color(0xFFF7FBF2),
            body: const TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                 ScheduleAppointmentView(),// Halaman Schedule Appointment
                 BarcodeAppointmentView(), // Halaman QRCode
                 SymptomAppointmentView(), // Halaman Symptom
                 CaptureAppointmentView(), // Halaman Capture
              ],
            ),
          ),
        );
      },
    );
  }
}