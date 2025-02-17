// home_doctor_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeDoctorController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxList<Map<String, dynamic>> appointments = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Simulate loading appointments
    appointments.addAll([
      {
        'patientName': 'John Doe',
        'time': '09:00 AM',
        'status': 'Pending',
        'description': 'Regular checkup'
      },
      {
        'patientName': 'Jane Smith',
        'time': '10:30 AM',
        'status': 'Confirmed',
        'description': 'Follow-up consultation'
      },
    ]);
  }
}

