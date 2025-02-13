import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/symptom_appointment_controller.dart';

class SymptomAppointmentView extends GetView<SymptomAppointmentController> {
  const SymptomAppointmentView({super.key});
  @override
  Widget build(BuildContext context) {
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
