import 'package:clinic_ai/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailDiagnoseController extends GetxController {
  //TODO: Implement DetailDiagnoseController

  final TextEditingController doctorAnalystController = TextEditingController();
  final Rx<Appointment?> appointment = Rx<Appointment?>(null);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Appointment) {
      appointment.value = Get.arguments as Appointment;
    }
  }

  // Misalnya fungsi untuk submit data
  void submitAI() {
    // Lakukan sesuatu, misal panggil API, dsb.
    // String analystText = doctorAnalystController.text;
    // print("Submitted: $analystText");
  }
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
