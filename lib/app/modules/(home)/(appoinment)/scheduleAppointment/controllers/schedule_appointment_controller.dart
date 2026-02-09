import 'dart:convert';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';
import 'package:clinic_ai/models/appointment_model.dart';
import 'package:clinic_ai/models/clinic_model.dart';
import 'package:clinic_ai/models/doctor_model.dart';
import 'package:clinic_ai/models/poly_model.dart';
import 'package:clinic_ai/models/scheduleDate_model.dart';
import 'package:clinic_ai/models/scheduleTime_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'
    as http; // Pastikan package http sudah diinstall
import 'package:clinic_ai/app/modules/(home)/(appoinment)/appointment/controllers/appointment_controller.dart';

class ScheduleAppointmentController extends GetxController {
  // GANTI URL INI SESUAI BACKEND KAMU
  // Kalau di Emulator Android: 'http://10.0.2.2:3000'
  // Kalau di Device Fisik/Production: 'https://be-clinic-rx7y.vercel.app'
  final String baseUrl = 'https://be-clinic-rx7y.vercel.app';

  RxBool isFormReadOnly = false.obs;

  // --- VARIABLES (Reactive) ---
  final Rxn<Clinic> selectedClinic = Rxn<Clinic>();
  final Rxn<Poly> selectedPoly = Rxn<Poly>();
  final Rxn<Doctor> selectedDoctor = Rxn<Doctor>();
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rxn<String> selectedScheduleDateId = Rxn<String>();
  final selectedTime = ''.obs;
  final Rxn<ScheduleTime> selectedScheduleTime = Rxn<ScheduleTime>();

  // --- LIST DATA (Reactive) ---
  final RxList<Clinic> clinics = <Clinic>[].obs;
  final RxList<Poly> polies = <Poly>[].obs;
  final RxList<Doctor> doctors = <Doctor>[].obs;
  final RxList<ScheduleDate> scheduleDates = <ScheduleDate>[].obs;
  final RxList<ScheduleTime> scheduleTimes = <ScheduleTime>[].obs;

  // --- LOADING STATES ---
  final RxBool isLoadingClinics = false.obs;
  final RxBool isLoadingPolies = false.obs;
  final RxBool isLoadingDoctors = false.obs;
  final RxBool isLoadingScheduleDates = false.obs;
  final RxBool isLoadingScheduleTimes = false.obs;

  // --- AVAILABILITY FLAGS ---
  final RxBool isPolyAvailable = true.obs;
  final RxBool isDoctorAvailable = true.obs;
  final RxBool isScheduleDateAvailable = true.obs;
  final RxBool isScheduleTimeAvailable = true.obs;

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    // 1. Ambil data Klinik saat controller dibuat
    fetchClinics();

    // 2. Cek apakah ini mode edit atau view existing appointment
    final appointmentController = Get.find<AppointmentController>();
    isFormReadOnly.value = appointmentController.hasCreatedAppointment.value;

    if (isFormReadOnly.value) {
      loadSavedAppointmentData();
    }
  }

  void setTabController(TabController controller) {
    tabController = controller;
  }

  // --- HELPER: GET HEADER WITH JWT ---
  Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ===========================================================================
  // BAGIAN 1: FETCH DATA DARI BACKEND (NESTJS)
  // ===========================================================================

  Future<void> fetchClinics() async {
    try {
      isLoadingClinics.value = true;
      final headers = await getHeaders();

      print("--- MANGGIL API CLINIC ---"); // Debug
      final response = await http.get(Uri.parse('$baseUrl/masters/clinics'),
          headers: headers);

      print(
          "Status Code: ${response.statusCode}"); // Cek apakah 200, 401, atau 404
      print("Response Body: ${response.body}"); // LIHAT ISI ASLINYA DI SINI

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'] ?? jsonResponse;

        clinics.assignAll(data.map((e) => Clinic.fromJson(e)).toList());
        print("Jumlah Klinik Berhasil di-load: ${clinics.length}");
      } else {
        print("Gagal fetch clinics: ${response.body}");
        Get.snackbar('Auth Error', 'Sesi mungkin habis, silakan login ulang');
      }
    } catch (e) {
      print('ERROR NYATA: $e');
      Get.snackbar('Error', 'Gagal memuat klinik: $e');
    } finally {
      isLoadingClinics.value = false;
    }
  }

  Future<void> fetchPolies(String clinicId) async {
    try {
      isLoadingPolies.value = true;
      final headers = await getHeaders();
      final response = await http.get(
          Uri.parse('$baseUrl/masters/polies/$clinicId'),
          headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'] ?? jsonResponse;

        final list = data.map((e) => Poly.fromJson(e)).toList();
        polies.assignAll(list);
        isPolyAvailable.value = list.isNotEmpty;

        // Reset dropdown anak-anaknya
        resetDoctors();
      } else {
        isPolyAvailable.value = false;
      }
    } catch (e) {
      isPolyAvailable.value = false;
    } finally {
      isLoadingPolies.value = false;
      if (!isPolyAvailable.value && selectedClinic.value != null) {
        Get.snackbar('Info', 'Tidak ada poli di klinik ini.');
      }
    }
  }

  Future<void> fetchDoctors(String clinicId, String polyId) async {
    try {
      isLoadingDoctors.value = true;
      final headers = await getHeaders();
      final response = await http.get(
          Uri.parse('$baseUrl/masters/doctors/$clinicId/$polyId'),
          headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'] ?? jsonResponse;

        final list = data.map((e) => Doctor.fromJson(e)).toList();
        doctors.assignAll(list);
        isDoctorAvailable.value = list.isNotEmpty;

        resetDates();
      } else {
        isDoctorAvailable.value = false;
      }
    } catch (e) {
      isDoctorAvailable.value = false;
    } finally {
      isLoadingDoctors.value = false;
      if (!isDoctorAvailable.value && selectedPoly.value != null) {
        Get.snackbar('Info', 'Tidak ada dokter di poli ini.');
      }
    }
  }

  Future<void> fetchScheduleDates(String polyId, String doctorId) async {
    try {
      isLoadingScheduleDates.value = true;
      final headers = await getHeaders();
      final response = await http.get(
          Uri.parse('$baseUrl/masters/schedule-dates/$polyId/$doctorId'),
          headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'] ?? jsonResponse;

        final list = data.map((e) => ScheduleDate.fromJson(e)).toList();
        scheduleDates.assignAll(list);
        isScheduleDateAvailable.value = list.isNotEmpty;

        resetTimes();
      } else {
        isScheduleDateAvailable.value = false;
      }
    } catch (e) {
      isScheduleDateAvailable.value = false;
    } finally {
      isLoadingScheduleDates.value = false;
      if (!isScheduleDateAvailable.value && selectedDoctor.value != null) {
        Get.snackbar('Info', 'Dokter ini belum memiliki jadwal.');
      }
    }
  }

  Future<void> fetchScheduleTimes(String dateId) async {
    try {
      isLoadingScheduleTimes.value = true;
      final headers = await getHeaders();
      final response = await http.get(
          Uri.parse('$baseUrl/masters/schedule-times/$dateId'),
          headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'] ?? jsonResponse;

        final list = data.map((e) => ScheduleTime.fromJson(e)).toList();
        scheduleTimes.assignAll(list);
        isScheduleTimeAvailable.value = list.isNotEmpty;
      } else {
        isScheduleTimeAvailable.value = false;
      }
    } catch (e) {
      isScheduleTimeAvailable.value = false;
    } finally {
      isLoadingScheduleTimes.value = false;
    }
  }

  // ===========================================================================
  // BAGIAN 2: SUBMIT APPOINTMENT (POST)
  // ===========================================================================

  Future<void> onNextPressed() async {
    final appointmentController = Get.find<AppointmentController>();

    // Jika sudah pernah buat, langsung geser tab aja
    if (appointmentController.hasCreatedAppointment.value) {
      tabController.animateTo(1);
      return;
    }

    if (!isFormValid()) {
      Get.snackbar('Error', 'Mohon lengkapi semua data',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah data janji temu sudah benar?'),
        actions: [
          TextButton(
              child: const Text('Batal'),
              onPressed: () => Get.back(result: false)),
          TextButton(
              child: const Text('Ya, Buat'),
              onPressed: () => Get.back(result: true)),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      final headers = await getHeaders();
      final body = json.encode({
        'clinic_id': selectedClinic.value!.id,
        'poly_id': selectedPoly.value!.id,
        'doctor_id': selectedDoctor.value!.id,
        'date_id': selectedScheduleDateId.value,
        'time_id': selectedScheduleTime.value!.id,
      });

      // Tembak Endpoint Create Appointment
      final response = await http.post(
        Uri.parse('$baseUrl/appointments'),
        headers: headers,
        body: body,
      );

      Get.back(); // Tutup loading

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        final appointmentData = jsonResponse['data'] ?? jsonResponse;

        // Convert ke Model
        final createdAppointment = Appointment.fromJson(appointmentData);

        // Update State di Controller Lain
        final barcodeController = Get.find<BarcodeAppointmentController>();
        barcodeController.setAppointmentData(createdAppointment);
        barcodeController.isAccessible.value = true;

        appointmentController.setAppointmentCreated(true);
        isFormReadOnly.value = true;

        // Pindah Tab ke QR Code
        tabController.animateTo(1);

        Get.snackbar('Sukses', 'Janji temu berhasil dibuat!',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        throw 'Gagal: ${response.body}';
      }
    } catch (e) {
      Get.back(); // Pastikan loading tertutup kalau error
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // ===========================================================================
  // BAGIAN 3: LOGIC UI (RESET & SELECTION)
  // ===========================================================================

  bool isFormValid() {
    return selectedClinic.value != null &&
        selectedPoly.value != null &&
        selectedDoctor.value != null &&
        selectedScheduleDateId.value != null &&
        selectedScheduleTime.value != null;
  }

  void setClinic(Clinic clinic) {
    selectedClinic.value = clinic;
    selectedPoly.value = null; // Reset selection Poly
    resetDoctors(); // Reset ke bawahnya juga
    fetchPolies(clinic.id); // Load Poly Baru
  }

  void setPoly(Poly poly) {
    selectedPoly.value = poly;
    selectedDoctor.value = null;
    resetDates();
    if (selectedClinic.value != null) {
      fetchDoctors(selectedClinic.value!.id, poly.id);
    }
  }

  void setDoctor(Doctor doctor) {
    selectedDoctor.value = doctor;
    resetDates();
    if (selectedPoly.value != null) {
      fetchScheduleDates(selectedPoly.value!.id, doctor.id);
    }
  }

  void setSelectedDate(DateTime? date) {
    selectedDate.value = date;
    resetTimes();

    if (date != null) {
      // Cari ID dari tanggal yang dipilih di list scheduleDates
      final foundDate = scheduleDates.firstWhereOrNull((d) =>
          d.scheduleDate.year == date.year &&
          d.scheduleDate.month == date.month &&
          d.scheduleDate.day == date.day);

      if (foundDate != null) {
        selectedScheduleDateId.value = foundDate.id;
        fetchScheduleTimes(foundDate.id);
      }
    }
  }

  void setSelectedScheduleTime(ScheduleTime? time) {
    selectedScheduleTime.value = time;
    selectedTime.value = time?.scheduleTime ?? '';
  }

  // --- Reset Methods ---
  void resetDoctors() {
    doctors.clear();
    selectedDoctor.value = null;
    resetDates();
  }

  void resetDates() {
    scheduleDates.clear();
    selectedDate.value = null;
    selectedScheduleDateId.value = null;
    resetTimes();
  }

  void resetTimes() {
    scheduleTimes.clear();
    selectedScheduleTime.value = null;
    selectedTime.value = '';
  }

  void resetForm() {
    selectedClinic.value = null;
    selectedPoly.value = null;
    resetDoctors();

    isPolyAvailable.value = true;
    isDoctorAvailable.value = true;
    isScheduleDateAvailable.value = true;
    isScheduleTimeAvailable.value = true;

    isFormReadOnly.value = false;

    fetchClinics(); // Fetch ulang klinik
  }

  Future<void> loadSavedAppointmentData() async {
    final barcodeController = Get.find<BarcodeAppointmentController>();
    final appointment = barcodeController.currentAppointment.value;

    if (appointment != null) {
      // 1. Set Clinic (Manual cari di list karena sudah difetch di onInit)
      // Note: Karena fetch async, ada risiko balapan (race condition).
      // Idealnya load data ini dipanggil SETELAH fetchClinics selesai.

      // Untuk simplifikasi, kita asumsikan clinics sudah terisi atau kita set manual.
      // Implementasi detailnya tergantung kebutuhan apakah mau fetch ulang endpoint masters
      // atau cukup pakai data ID yang ada di appointment.
    }
  }
}
