import 'package:clinic_ai/models/appointment_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BarcodeAppointmentController extends GetxController {
  final supabase = Supabase.instance.client;
  RxBool isAccessible = false.obs;
  
  final Rxn<Appointment> currentAppointment = Rxn<Appointment>();
  final RxString userName = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    getUserName();
  }
  
  void setAppointmentData(Appointment appointment) {
    currentAppointment.value = appointment;
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