import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:clinic_ai/models/doctor_model.dart';
import 'package:clinic_ai/models/poly_model.dart';
import 'package:clinic_ai/models/scheduleDate_model.dart';
import 'package:clinic_ai/models/scheduleTime_model.dart';
import 'package:clinic_ai/models/clinic_model.dart';
import 'package:clinic_ai/models/appointment_model.dart';

class MedicalHistoryController extends GetxController {
  final isLoading = false.obs;
  final medicalRecords = <Appointment>[].obs;
  final supabase = Supabase.instance.client;

  // Rx untuk menyimpan data detail (gunakan Rxn agar bisa null)
  final existingDoctor = Rxn<Doctor>();
  final existingPoly = Rxn<Poly>();
  final existingScheduleDate = Rxn<ScheduleDate>();
  final existingScheduleTime = Rxn<ScheduleTime>();
  final existingClinic = Rxn<Clinic>();
  RxString doctorProfilePictureUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMedicalRecords();
  }

  Future<void> fetchMedicalRecords() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId != null) {
        final response = await supabase
            .from('appointments')
            .select('*')
            .eq('user_id', userId)
            .order('created_at', ascending: false);

        if (response != null && response is List) {
          medicalRecords.assignAll(
              response.map((data) => Appointment.fromJson(data)).toList());

          // Fetch related data for each appointment
          for (final record in medicalRecords) {
            await fetchRelatedData(record);
          }
        } else {
          print('Failed to fetch medical records: ${response}');
        }
      }
    } catch (e) {
      print('Error fetching medical records: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRelatedData(Appointment appointment) async {
    try {
      // Fetch Doctor
      final doctorResponse = await supabase
          .from('doctors')
          .select()
          .eq('id', appointment.doctorId)
          .maybeSingle();

      if (doctorResponse != null) {
        existingDoctor.value = Doctor.fromJson(doctorResponse);
        await fetchDoctorProfilePicture(existingDoctor.value!.id!);
      } else {
        existingDoctor.value = null; // Ensure existingDoctor is null if doctor not found
        doctorProfilePictureUrl.value = ''; // Reset profile picture URL
      }

      // Fetch Poly
      final polyResponse = await supabase
          .from('polies')
          .select()
          .eq('id', appointment.polyId)
          .maybeSingle();
      existingPoly.value =
          polyResponse != null ? Poly.fromJson(polyResponse) : null;

      // Fetch ScheduleDate
      final scheduleDateResponse = await supabase
          .from('schedule_dates')
          .select()
          .eq('id', appointment.dateId)
          .maybeSingle();
      existingScheduleDate.value = scheduleDateResponse != null
          ? ScheduleDate.fromJson(scheduleDateResponse)
          : null;

      // Fetch ScheduleTime
      final scheduleTimeResponse = await supabase
          .from('schedule_times')
          .select()
          .eq('id', appointment.timeId)
          .maybeSingle();
      existingScheduleTime.value = scheduleTimeResponse != null
          ? ScheduleTime.fromJson(scheduleTimeResponse)
          : null;

      // Fetch Clinic
      final clinicResponse = await supabase
          .from('clinics')
          .select()
          .eq('id', appointment.clinicId)
          .maybeSingle();
      existingClinic.value =
          clinicResponse != null ? Clinic.fromJson(clinicResponse) : null;
    } catch (e) {
      print('Error fetching related data: $e');
    }
  }

  Future<void> fetchDoctorProfilePicture(String userId) async {
    try {
      final fileResponse = await supabase
          .from('files')
          .select('file_name')
          .eq('module_class', 'doctors')
          .eq('module_id', userId)
          .maybeSingle();

      if (fileResponse != null) {
        doctorProfilePictureUrl.value =
            fileResponse['file_name'] as String? ?? '';
      } else {
        doctorProfilePictureUrl.value = '';
      }
    } catch (e) {
      print('Error fetching doctor profile picture: $e');
      doctorProfilePictureUrl.value = '';
    }
  }

  String getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Waiting';
      case 2:
        return 'Approved';
      case 3:
        return 'Rejected';
      case 4:
        return 'Diagnose';
      case 5:
        return 'Unpaid';
      case 6:
        return 'Waiting for Drugs';
      case 7:
        return 'Completed';
      default:
        return 'Unknown Status';
    }
  }
}