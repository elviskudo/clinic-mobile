import 'dart:convert';

import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
  RxBool isLoadingMedicalRecords = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMedicalRecords();
  }

  Future<void> fetchMedicalRecords() async {
    isLoadingMedicalRecords.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('accessToken');

      if (token == null) {
        print('Error: Token tidak ditemukan');
        return;
      }

      // Pastikan URL ini sesuai controller NestJS Anda.
      // Jika error 404, ganti jadi: .../appointments/my-appointments
      final String url = 'https://be-clinic-rx7y.vercel.app/appointments';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Handle format interceptor { data: [...] }
        final List<dynamic> rawData = responseData['data'] ?? [];

        final List<Appointment> safeList = [];

        // LOOPING AMAN (ANTI CRASH)
        for (var item in rawData) {
          try {
            safeList.add(Appointment.fromJson(item));
          } catch (e) {
            // Jika ada data busuk, kita skip dan log error-nya saja, jangan bikin app mati
            print("⚠️ Skip data error ID ${item['id']}: $e");
          }
        }

        medicalRecords.assignAll(safeList);
        print('✅ Berhasil fetch ${medicalRecords.length} medical records');
      } else {
        print('❌ Gagal fetch: ${response.body}');
      }
    } catch (e) {
      print('❌ Error fetching medical records global: $e');
    } finally {
      isLoadingMedicalRecords.value = false;
    }
  }

  void navigateToDetail(Appointment appointment) {
    print('Navigating for Appointment ID: ${appointment.id} with status: ${appointment.status}');

    switch (appointment.status) {
      case 1: // Waiting
      case 2: // Approved
      case 4: // Diagnose
      case 5: // Unpaid
      case 7: // Completed
        Get.toNamed(Routes.SUMMARY_APPOINTMENT, arguments: appointment.id);
        break;

      case 6: // Waiting for Drugs
        Get.toNamed(Routes.REDEEM_MEDICINE, arguments: appointment.id);
        break;

      case 3: // Rejected
        Get.snackbar(
          'Info',
          'This appointment was rejected: ${appointment.rejectedNote ?? ""}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        break;

      default:
        Get.toNamed(Routes.APPOINTMENT, parameters: {'appointmentId': appointment.id});
        break;
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
        existingDoctor.value =
            null; // Ensure existingDoctor is null if doctor not found
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
