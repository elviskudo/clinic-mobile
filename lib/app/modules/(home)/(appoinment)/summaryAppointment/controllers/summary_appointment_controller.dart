import 'dart:async';

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
import 'package:clinic_ai/models/symptom_model.dart'; // Import Symptom Model
import 'package:clinic_ai/models/profile_model.dart'; // Import Profile Model

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
  Rxn<Profile> profile = Rxn<Profile>(); // Rxn untuk menyimpan data profil
  RxString doctorProfilePictureUrl = ''.obs; // URL gambar profil dokter

  RxBool isAppointmentCompleted = false.obs;
  RxString buttonText = 'Waiting for the result ...'.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    getUserName();
    fetchAppointmentAndDoctor(Get.arguments as String? ?? '');
    startAppointmentStatusCheck(); // Memulai pemeriksaan status
  }

  @override
  void onClose() {
    _timer?.cancel(); // Memastikan timer dibatalkan saat controller ditutup
    super.onClose();
  }

  // Fungsi untuk memeriksa status appointment secara periodik
  void startAppointmentStatusCheck() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      checkAppointmentStatus();
    });
  }

  // Fungsi untuk memeriksa status appointment
  Future<void> checkAppointmentStatus() async {
    print('Memeriksa status appointment...');
    if (appointment.value == null || appointment.value!.id == null) {
      print('Appointment atau ID Appointment NULL');
      return;
    }

    try {
      final response = await supabase
          .from('appointments')
          .select('status')
          .eq('id', appointment.value!.id)
          .maybeSingle();

      if (response != null) {
        final status = response['status'] as int?;
        print('Status appointment: $status');
        if (status == 5) {
          isAppointmentCompleted.value = true;
          buttonText.value = 'Next'; // Ubah teks tombol
        } else {
          isAppointmentCompleted.value = false;
          buttonText.value = 'Waiting for the result ...'; // Ubah teks tombol
        }
      } else {
        print('Failed to fetch appointment status.');
      }
    } catch (e) {
      print('Error checking appointment status: ${e.toString()}');
    }
  }

  Future<void> getUserName() async {
    try {
       print("Memulai fungsi getUserName");
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('name');
       print("Name value: $name");
      print('User name from SharedPreferences: $name'); // Debugging
      userName.value = name ?? 'Unknown User';
         print("Berhasil menjalankan fungsi getUserName");
    } catch (e) {
      print('Error getting user name from SharedPreferences: $e');
      userName.value = 'Unknown User';
    }
  }

  // Fungsi untuk mendapatkan URL gambar profil dokter
  Future<void> fetchDoctorProfilePicture(String userId) async {
    print("Fungsi fetchDoctorProfilePicture dijalankan dengan userID: $userId");
    try {
      final fileResponse = await supabase
          .from('files')
          .select('file_name')
          .eq('module_class', 'users')
          .eq('module_id', userId)
          .maybeSingle();
      print('Response file Dokter $fileResponse');
      if (fileResponse != null) {
        final fileName = fileResponse['file_name'] as String?;
        print('Doctor profile picture file name: $fileName'); // Debugging
        doctorProfilePictureUrl.value = fileName ?? '';
      } else {
        doctorProfilePictureUrl.value =
            ''; // Set ke string kosong jika tidak ada gambar
      }
        print("Berhasil menjalankan fungsi fetchDoctorProfilePicture");
    } catch (e) {
      print('Gagal mengambil URL gambar profil dokter: $e');
      doctorProfilePictureUrl.value =
          ''; // Set ke string kosong jika terjadi kesalahan
    }
  }

  Future<void> fetchAppointmentImage(String appointmentId) async {
    print(
        "Fungsi fetchAppointmentImage dijalankan dengan appointmentId: $appointmentId");
    try {
      final fileResponse = await supabase
          .from('files')
          .select('file_name')
          .eq('module_class', 'appointments')
          .eq('module_id', appointmentId)
          .maybeSingle();
    print('Response file appoinment $fileResponse');
      if (fileResponse != null) {
        final fileName = fileResponse['file_name'] as String?;
        print('Appointment image file name: $fileName'); // Debugging
        imageUrl.value = fileName ?? '';
      } else {
        imageUrl.value = ''; // Set default value jika tidak ada gambar
      }
        print("Berhasil menjalankan fungsi fetchAppointmentImage");
    } catch (e) {
      print('Gagal mengambil URL gambar appointment: $e');
      imageUrl.value = ''; // Set ke string kosong jika terjadi kesalahan
    }
  }

  Future<void> fetchAppointmentAndDoctor(String appointmentId) async {
    print("Fungsi fetchAppointmentAndDoctor dijalankan dengan ID: $appointmentId");
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Ambil data appointment dari Supabase
      final appointmentResponse = await supabase
          .from('appointments')
          .select()
          .eq('id', appointmentId)
          .single();
       print('1. Response Appointment $appointmentResponse');
      if (appointmentResponse == null) {
        errorMessage.value = 'Gagal mengambil data appointment.';
        return;
      }

      appointment.value = Appointment.fromJson(appointmentResponse);
      print('Appointment data: ${appointment.value}'); // Debugging

      // Ambil Daftar Gejala
      final symptomsString = appointment.value?.symptoms;
      print('2. Daftar gejala $symptomsString');
      if (symptomsString != null && symptomsString.isNotEmpty) {
        final symptomIds = symptomsString.split(',');
        final symptomsResponse = await supabase
            .from('symptoms')
            .select()
            .inFilter('id', symptomIds); // Gunakan inFilter untuk daftar ID
 print('3. Response symptom $symptomsResponse');
        if (symptomsResponse != null && symptomsResponse is List) {
          symptoms.assignAll(
              symptomsResponse.map((json) => Symptom.fromJson(json)).toList());
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
      print('4. Response ScheduleDate $scheduleDateResponse');
      scheduleDate.value = ScheduleDate.fromJson(scheduleDateResponse);
      print('ScheduleDate data: ${scheduleDate.value}'); // Debugging

      // Ambil ScheduleTime
      final scheduleTimeResponse = await supabase
          .from('schedule_times')
          .select()
          .eq('id', appointment.value!.timeId)
          .single();
      print('5. Response ScheduleTime $scheduleTimeResponse');
      scheduleTime.value = ScheduleTime.fromJson(scheduleTimeResponse);
      print('ScheduleTime data: ${scheduleTime.value}'); // Debugging

      final polyResponse = await supabase
          .from('polies')
          .select()
          .eq('id', appointment.value!.polyId)
          .single();
          print('6. Response Poly $polyResponse');
      poly.value = Poly.fromJson(polyResponse);
      print('Poly data: ${poly.value}'); // Debugging

      // Ambil data dokter dari Supabase
      if (appointment.value != null) {
        print('Appointment value tidak null');
        if (appointment.value!.doctorId != null) {
          print('iniiiiiiiiiiiiiiiiii ${appointment.value!.doctorId}');
          final doctorResponse = await supabase
              .from('doctors')
              .select()
              .eq('id', appointment.value!.doctorId)
              .maybeSingle(); // Use maybeSingle()
           print('7. Response doctor $doctorResponse');
          print('konciiiiiiii ${doctorResponse}');

          if (doctorResponse == null) {
            errorMessage.value = 'Gagal mengambil data dokter.';
            return;
          }

          doctor.value = Doctor.fromJson(doctorResponse);
          print('Doctor data: ${doctor.value}'); // Debugging
          print('kocaccccccccckkkkkk: ${doctor.value}'); // Debugging
        } else {
          print('Dokter ID null');
          errorMessage.value = 'Dokter ID null.';
          return;
        }
      } else {
        print('Appointment Null');
        errorMessage.value = 'Appointment Null';
        return;
      }

      // Dapatkan userId dokter dari tabel users
      if (doctor.value != null && doctor.value!.id != null) {
        final userResponse = await supabase
            .from('users')
            .select('id')
            .eq('id', doctor.value!.id)
            .maybeSingle(); // Use maybeSingle()
            print('8. Response User $userResponse');
        print('User response raw data: $userResponse'); // Tambahkan ini

        if (userResponse != null) {
          String userId = userResponse['id'];

          // Ambil URL gambar profil dokter
          final fileResponse = await supabase
              .from('files')
              .select('file_name')
              .eq('module_class', 'users')
              .eq('module_id', userId)
              .maybeSingle(); // Use maybeSingle()
           print('9. Respons file user $fileResponse');
          if (fileResponse != null) {
            doctorProfilePictureUrl.value =
                fileResponse['file_name'] as String? ?? '';
          } else {
            doctorProfilePictureUrl.value =
                ''; // Set default value jika tidak ada gambar
          }
          // await fetchDoctorProfile(userId);
        } else {
          errorMessage.value = 'Gagal mengambil userId dokter.';
          return;
        }
      } else {
        errorMessage.value = 'Data dokter tidak lengkap.';
        return;
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
    print("Memanggil fetchAppointmentImage dengan appointmentId: $appointmentId");
    await fetchAppointmentImage(appointmentId);
  }
}