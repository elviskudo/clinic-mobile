import 'package:clinic_ai/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BarcodeAppointmentController extends GetxController {
  final supabase = Supabase.instance.client;
  RxBool isAccessible = false.obs;

  final Rxn<Appointment> currentAppointment = Rxn<Appointment>();
  final RxString userName = ''.obs;
  RxInt previousStatus = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    getUserName();
  }

  void setAppointmentData(Appointment appointment) {
    currentAppointment.value = appointment;
  }

 Stream<List<Appointment>> getAppointmentsStream() {
    if (currentAppointment.value == null) return Stream.value([]);
    
    return supabase
        .from('appointments')
        .stream(primaryKey: ['id'])
        .eq('id', currentAppointment.value!.id)
        .map((list) {
          final appointments = list.map((item) => Appointment.fromJson(item)).toList();
          
          // Check if status changed to 1
          if (appointments.isNotEmpty) {
            final appointment = appointments.first;
            if (previousStatus.value == 0 && appointment.status == 1) {
              Get.snackbar(
                'Success',
                'Barcode has been successfully scanned',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
            }
            previousStatus.value = appointment.status;
          }
          
          return appointments;
        });
  }

  Future<void> getUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      userName.value = prefs.getString('name') ?? 'Unknown User';
    } catch (e) {
      print('Error getting user name from SharedPreferences: $e');
      userName.value = 'Unknown User';
    }
  }
}
