import 'package:clinic_ai/app/modules/(home)/scheduleAppointment/controllers/schedule_appointment_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/barcode_appointment_controller.dart';

class BarcodeAppointmentView extends GetView<BarcodeAppointmentController> {
  const BarcodeAppointmentView({super.key});
  @override
  Widget build(BuildContext context) {
      Get.put(ScheduleAppointmentController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('BarcodeAppointmentView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BarcodeAppointmentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
