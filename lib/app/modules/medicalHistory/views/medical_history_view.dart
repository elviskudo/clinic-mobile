import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/medical_history_controller.dart';

class MedicalHistoryView extends GetView<MedicalHistoryController> {
  const MedicalHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MedicalHistoryView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MedicalHistoryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
