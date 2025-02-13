import 'package:clinic_ai/app/modules/(home)/scheduleAppointment/controllers/schedule_appointment_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/capture_appointment_controller.dart';

class CaptureAppointmentView extends GetView<CaptureAppointmentController> {
  const CaptureAppointmentView({super.key});
  @override
  Widget build(BuildContext context) {
     Get.put(ScheduleAppointmentController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('CaptureAppointmentView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CaptureAppointmentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
