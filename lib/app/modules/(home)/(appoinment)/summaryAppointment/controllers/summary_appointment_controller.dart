import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:clinic_ai/models/appointment_model.dart';
import 'package:clinic_ai/models/doctor_model.dart';
import 'package:clinic_ai/models/poly_model.dart';
import 'package:clinic_ai/models/scheduleDate_model.dart';
import 'package:clinic_ai/models/scheduleTime_model.dart';
import 'package:clinic_ai/models/file_model.dart'; // Import FileModel
import 'package:clinic_ai/models/symptom_model.dart';// Import Symptom Model

class SummaryAppointmentController extends GetxController {
final supabase = Supabase.instance.client;
Rxn<Appointment> appointment = Rxn<Appointment>();
Rxn<Doctor> doctor = Rxn<Doctor>();
Rxn<Poly> poly = Rxn<Poly>();
Rxn<ScheduleDate> scheduleDate = Rxn<ScheduleDate>();
Rxn<ScheduleTime> scheduleTime = Rxn<ScheduleTime>();
RxBool isLoading = false.obs;
RxString errorMessage = ''.obs;
final RxString userName = ''.obs;
RxString imageUrl = ''.obs;
RxList<Symptom> symptoms = <Symptom>[].obs; // List untuk menyimpan gejala

@override
void onInit() {
 super.onInit();
 getUserName();
 // fetchAppointmentAndDoctor(appointmentId); // Fetch data saat controller diinisialisasi
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

Future<void> fetchAppointmentAndDoctor(String appointmentId) async {
 isLoading.value = true;
 errorMessage.value = '';

 try {
   // Ambil data appointment dari Supabase
   final appointmentResponse = await supabase
       .from('appointments')
       .select()
       .eq('id', appointmentId)
       .single();

   if (appointmentResponse == null) {
     errorMessage.value = 'Gagal mengambil data appointment.';
     return;
   }

   appointment.value = Appointment.fromJson(appointmentResponse);

     // Ambil Daftar Gejala
   final symptomsString = appointment.value?.symptoms;
   if (symptomsString != null && symptomsString.isNotEmpty) {
     final symptomIds = symptomsString.split(',');
     final symptomsResponse = await supabase
         .from('symptoms')
         .select()
         .inFilter('id', symptomIds); // Gunakan inFilter untuk daftar ID

     if (symptomsResponse != null && symptomsResponse is List) {
       symptoms.assignAll(symptomsResponse.map((json) => Symptom.fromJson(json)).toList());
     } else {
       print('Gagal mengambil daftar gejala.');
     }
   }

   // Ambil ScheduleDate
   final scheduleDateResponse = await supabase
       .from('schedule_dates')
       .select()
       .eq('id', appointment.value!.dateId)
       .single();
   scheduleDate.value = ScheduleDate.fromJson(scheduleDateResponse);

   // Ambil ScheduleTime
   final scheduleTimeResponse = await supabase
       .from('schedule_times')
       .select()
       .eq('id', appointment.value!.timeId)
       .single();
   scheduleTime.value = ScheduleTime.fromJson(scheduleTimeResponse);

   final polyResponse = await supabase
       .from('polies')
       .select()
       .eq('id', appointment.value!.polyId)
       .single();
   poly.value = Poly.fromJson(polyResponse);
   // Ambil data dokter dari Supabase
   final doctorResponse = await supabase
       .from('doctors')
       .select()
       .eq('id', appointment.value!.doctorId)
       .single();

   if (doctorResponse == null) {
     errorMessage.value = 'Gagal mengambil data dokter.';
     return;
   }

   doctor.value = Doctor.fromJson(doctorResponse);

    final fileResponse = await supabase
       .from('files')
       .select('file_name')
       .eq('module_class', 'appointments')
       .eq('module_id', appointmentId)
       .single();

    if (fileResponse != null) {
     imageUrl.value = fileResponse['file_name'] as String? ?? '';
   } else {
     imageUrl.value = ''; // Set default value jika tidak ada gambar
   }
 } catch (e) {
   errorMessage.value = 'Error: ${e.toString()}';
 } finally {
   isLoading.value = false;
 }
}
}