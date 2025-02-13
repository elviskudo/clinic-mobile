import 'package:clinic_ai/app/modules/(home)/scheduleAppointment/controllers/schedule_appointment_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/symptom_appointment_controller.dart';

class SymptomAppointmentView extends GetView<SymptomAppointmentController> {
  const SymptomAppointmentView({super.key});
  @override
  Widget build(BuildContext context) {
     Get.put(ScheduleAppointmentController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('SymptomAppointmentView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SymptomAppointmentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
