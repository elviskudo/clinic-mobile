import 'package:awesome_notifications/awesome_notifications.dart';
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
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/appointment/controllers/appointment_controller.dart';

class ScheduleAppointmentController extends GetxController {
  final supabase = Supabase.instance.client;
  RxBool isFormReadOnly = false.obs;

  // Rx variables
  final Rxn<Clinic> selectedClinic = Rxn<Clinic>();
  final Rxn<Poly> selectedPoly = Rxn<Poly>();
  final Rxn<Doctor> selectedDoctor = Rxn<Doctor>();
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rxn<String> selectedScheduleDateId = Rxn<String>();
  final selectedTime = ''.obs;
  final Rxn<ScheduleTime> selectedScheduleTime = Rxn<ScheduleTime>();

  // Schedule Times
  final RxList<ScheduleTime> scheduleTimes = <ScheduleTime>[].obs;
  final RxBool isLoadingScheduleTimes = false.obs;

  // Flags for data availability
  final RxBool isPolyAvailable = true.obs;
  final RxBool isDoctorAvailable = true.obs;
  final RxBool isScheduleDateAvailable = true.obs;
  final RxBool isScheduleTimeAvailable = true.obs;

  // Lists
  final RxList<Clinic> clinics = <Clinic>[].obs;
  final RxBool isLoadingClinics = false.obs;
  final RxList<Poly> polies = <Poly>[].obs;
  final RxBool isLoadingPolies = false.obs;
  final RxList<Doctor> doctors = <Doctor>[].obs;
  final RxBool isLoadingDoctors = false.obs;
  final RxList<ScheduleDate> scheduleDates = <ScheduleDate>[].obs;
  final RxBool isLoadingScheduleDates = false.obs;

  late TabController tabController; // Tambahkan ini

  @override
  void onInit() {
    super.onInit();
    fetchClinics();
    final appointmentController = Get.find<AppointmentController>();
    isFormReadOnly.value = appointmentController.hasCreatedAppointment.value;

    if (isFormReadOnly.value) {
      loadSavedAppointmentData();
    }

    // Listen to selected doctor changes
    ever(selectedDoctor, (Doctor? doctor) {
      if (selectedPoly.value != null && doctor != null) {
        fetchScheduleDates(selectedPoly.value!.id, doctor.id);
      } else {
        _clearScheduleData();
      }
    });

    ever(selectedScheduleDateId, (String? dateId) {
      if (dateId != null) {
        fetchScheduleTimes(dateId);
      } else {
        _clearTimeData();
      }
    });
  }

  // Inisialisasi TabController
  void setTabController(TabController controller) {
    tabController = controller;
  }

  void _clearScheduleData() {
    scheduleDates.clear();
    selectedDate.value = null;
    selectedScheduleDateId.value = null;
    _clearTimeData();
    isScheduleDateAvailable.value = true;
  }

  void _clearTimeData() {
    scheduleTimes.clear();
    selectedScheduleTime.value = null;
    isScheduleTimeAvailable.value = true;
  }

  Future<void> loadSavedAppointmentData() async {
    final barcodeController = Get.find<BarcodeAppointmentController>();
    final appointment = barcodeController.currentAppointment.value;

    if (appointment != null) {
      // Load clinic
      selectedClinic.value =
          clinics.firstWhere((c) => c.id == appointment.clinicId);
      await fetchPolies(appointment.clinicId);

      // Load poly
      selectedPoly.value = polies.firstWhere((p) => p.id == appointment.polyId);
      await fetchDoctors(appointment.clinicId, appointment.polyId);

      // Load doctor
      selectedDoctor.value =
          doctors.firstWhere((d) => d.id == appointment.doctorId);
      await fetchScheduleDates(appointment.polyId, appointment.doctorId);

      // Load date and time
      final scheduleDate =
          scheduleDates.firstWhere((d) => d.id == appointment.dateId);
      selectedDate.value = scheduleDate.scheduleDate;
      selectedScheduleDateId.value = scheduleDate.id;

      await fetchScheduleTimes(appointment.dateId);
      selectedScheduleTime.value =
          scheduleTimes.firstWhere((t) => t.id == appointment.timeId);

      isFormReadOnly.value = true; // Set form to read-only
    }
  }

  Future<void> onNextPressed() async {
    final appointmentController = Get.find<AppointmentController>();

    if (appointmentController.hasCreatedAppointment.value) {
      // Just navigate to QR code tab
      // tabController.animateTo(1);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        tabController.animateTo(1);
      });
      return;
    }

    final shouldProceed = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Confirm Appointment'),
            content:
                const Text('Are you sure you want to create this appointment?'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Get.back(result: false),
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () => Get.back(result: true),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldProceed) return;

    try {
      // Show loading dialog
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        Get.back(); // Close loading dialog
        Get.snackbar('Error', 'User ID not found. Please login again.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      const uuid = Uuid();
      final appointmentId = uuid.v4();
      final qrCode = generateRandomQrCode(8);

      final appointment = Appointment(
          id: appointmentId,
          userId: userId,
          clinicId: selectedClinic.value!.id,
          polyId: selectedPoly.value!.id,
          doctorId: selectedDoctor.value!.id,
          dateId: selectedScheduleDateId.value!,
          timeId: selectedScheduleTime.value!.id,
          status: 1,
          qrCode: qrCode,
          rejectedNote: null,
          symptoms: null,
          symptomDescription: null,
          aiResponse: null,
          createdAt: DateTime.now().toLocal(),
          updatedAt: DateTime.now().toLocal());

      final response = await supabase
          .from('appointments')
          .insert(appointment.toJson())
          .select();

      Get.back(); // Close loading dialog

      if (response != null && response.isNotEmpty) {
        final appointmentController = Get.find<AppointmentController>();
        final barcodeController = Get.find<BarcodeAppointmentController>();

        Appointment createdAppointment = Appointment.fromJson(response.first);
        barcodeController.setAppointmentData(createdAppointment);
        barcodeController.isAccessible.value = true;
        appointmentController.setAppointmentCreated(true);
        isFormReadOnly.value = true;

        //resetForm();

        tabController.animateTo(1);

        Get.snackbar(
          'Success',
          'Appointment created successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to create appointment.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Error creating appointment: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool isFormValid1() {
    return selectedClinic.value != null &&
        selectedPoly.value != null &&
        selectedDoctor.value != null &&
        selectedDate.value != null &&
        selectedScheduleTime.value != null;
  }

  Future<void> fetchClinics() async {
    try {
      isLoadingClinics.value = true;
      final response = await supabase.from('clinics').select();
      if (response != null) {
        clinics.assignAll(
            (response as List).map((json) => Clinic.fromJson(json)).toList());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load clinics: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingClinics.value = false;
    }
  }

  Future<void> fetchPolies(String clinicId) async {
    try {
      isLoadingPolies.value = true;
      final response =
          await supabase.from('polies').select().eq('clinic_id', clinicId);
      if (response != null) {
        final poliesList =
            (response as List).map((json) => Poly.fromJson(json)).toList();
        polies.assignAll(poliesList);
        isPolyAvailable.value = poliesList.isNotEmpty;
        doctors.clear();
        selectedDoctor.value = null;
        scheduleDates.clear();
        selectedDate.value = null;
        selectedScheduleDateId.value = null;
        scheduleTimes.clear(); // bersihkan scheduleTimes
      } else {
        isPolyAvailable.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load polies: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
      isPolyAvailable.value = false;
    } finally {
      isLoadingPolies.value = false;
      if (!isPolyAvailable.value && selectedClinic.value != null) {
        Get.snackbar(
          'Information',
          'Tidak ada Poly yang tersedia untuk ${selectedClinic.value!.name}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> fetchDoctors(String clinicId, String polyId) async {
    try {
      isLoadingDoctors.value = true;
      print('1. Starting fetch doctors');

      final response = await supabase
          .from('doctors')
          .select(
              'id, degree, specialize, name') // Hanya ambil field yang dibutuhkan
          .eq('clinic_id', clinicId)
          .eq('poly_id', polyId);

      print('2. Response received: ${response != null ? 'not null' : 'null'}');

      if (response != null && response is List) {
        print('3. Processing response as List');

        final doctorsList = response
            .map((json) {
              // Add null checks for required fields
              if (json['id'] == null ||
                  json['degree'] == null ||
                  json['specialize'] == null ||
                  json['name'] == null) {
                print('Invalid doctor data: $json');
                return null;
              }

              try {
                return Doctor(
                  id: json['id'],
                  degree: json['degree'],
                  specialize: json['specialize'],
                  description:
                      "", // Provide default values for other properties if needed
                  clinicId: "",
                  polyId: "",
                  status: 1,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  name: json['name'], // Ambil nama langsung dari response
                  // summary: "",
                );
              } catch (e) {
                print('Error parsing doctor: $e');
                return null;
              }
            })
            .where((doctor) => doctor != null)
            .cast<Doctor>()
            .toList();

        print('4. Doctors list created with ${doctorsList.length} items');

        doctors.assignAll(doctorsList);
        isDoctorAvailable.value = doctorsList.isNotEmpty;

        print('5. Doctors assigned to list');

        scheduleDates.clear();
        selectedDate.value = null;
        selectedScheduleDateId.value = null;
        scheduleTimes.clear();

        print('6. Related fields cleared');
      } else {
        print('7. No valid response received');
        isDoctorAvailable.value = false;
        doctors.clear();
      }
    } catch (e, stackTrace) {
      print('Error in fetchDoctors: $e');
      print('Stack trace: $stackTrace');
      Get.snackbar(
        'Error',
        'Failed to load doctors: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isDoctorAvailable.value = false;
      doctors.clear();
    } finally {
      isLoadingDoctors.value = false;
      if (!isDoctorAvailable.value && selectedPoly.value != null) {
        Get.snackbar(
          'Information',
          'Tidak ada Doctor yang tersedia untuk Poly ${selectedPoly.value!.name}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> fetchScheduleDates(String polyId, String doctorId) async {
    try {
      isLoadingScheduleDates.value = true;
      final response = await supabase
          .from('schedule_dates')
          .select()
          .eq('poly_id', polyId)
          .eq('doctor_id', doctorId);
      if (response != null) {
        final scheduleDatesList = (response as List)
            .map((json) => ScheduleDate.fromJson(json))
            .toList();
        scheduleDates.assignAll(scheduleDatesList);
        isScheduleDateAvailable.value = scheduleDatesList.isNotEmpty;
        scheduleTimes.clear(); // bersihkan scheduleTimes
        selectedScheduleTime.value = null;
      } else {
        isScheduleDateAvailable.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load schedule dates: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
      isScheduleDateAvailable.value = false;
    } finally {
      isLoadingScheduleDates.value = false;
      if (!isScheduleDateAvailable.value && selectedDoctor.value != null) {
        Get.snackbar(
          'Information',
          'Tidak ada Schedule Date yang tersedia untuk Doctor ${selectedDoctor.value!.degree}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    }
  }

  // Fetch Schedule Times berdasarkan dateId
  Future<void> fetchScheduleTimes(String dateId) async {
    try {
      isLoadingScheduleTimes.value = true;
      final response =
          await supabase.from('schedule_times').select().eq('date_id', dateId);

      if (response != null) {
        final scheduleTimesList = (response as List)
            .map((json) => ScheduleTime.fromJson(json))
            .toList();
        scheduleTimes.assignAll(scheduleTimesList);
        isScheduleTimeAvailable.value = scheduleTimesList.isNotEmpty;

        print("Apakah scheduleTimesList kosong? ${scheduleTimesList.isEmpty}");

        // PERUBAHAN: Hapus snackbar di sini
      } else {
        isScheduleTimeAvailable.value = false;
        // PERUBAHAN: Hapus snackbar di sini
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load schedule times: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      isScheduleTimeAvailable.value = false;
    } finally {
      isLoadingScheduleTimes.value = false;
    }
  }

  void setClinic(Clinic clinic) {
    selectedClinic.value = clinic;
    selectedPoly.value = null;
    selectedDoctor.value = null;
    doctors.clear();
    scheduleDates.clear();
    selectedDate.value = null;
    selectedScheduleDateId.value = null;
    scheduleTimes.clear(); // bersihkan scheduleTimes
    selectedScheduleTime.value = null;
    fetchPolies(clinic.id);
  }

  void setPoly(Poly poly) {
    selectedPoly.value = poly;
    selectedDoctor.value = null;
    doctors.clear();
    scheduleDates.clear();
    selectedDate.value = null;
    selectedScheduleDateId.value = null;
    scheduleTimes.clear(); // bersihkan scheduleTimes
    selectedScheduleTime.value = null;
    if (selectedClinic.value != null) {
      fetchDoctors(selectedClinic.value!.id, poly.id);
    }
  }

  void setDoctor(Doctor doctor) {
    selectedDoctor.value = doctor;
    if (selectedPoly.value != null) {
      fetchScheduleDates(selectedPoly.value!.id, doctor.id);
    }
  }

  void setSelectedDate(DateTime? date) async {
    selectedDate.value = date;

    selectedScheduleTime.value = null; // Reset selectedScheduleTime
    scheduleTimes.clear(); // Bersihkan daftar waktu

    if (date != null) {
      ScheduleDate? selectedScheduleDate = scheduleDates.firstWhereOrNull(
          (scheduleDate) =>
              scheduleDate.scheduleDate.year == date.year &&
              scheduleDate.scheduleDate.month == date.month &&
              scheduleDate.scheduleDate.day == date.day);

      if (selectedScheduleDate != null) {
        selectedScheduleDateId.value = selectedScheduleDate.id;
        print(
            'selectedScheduleDateId.value sekarang: ${selectedScheduleDateId.value}');

        await fetchScheduleTimes(
            selectedScheduleDateId.value!); // Fetch times setelah ID diatur

        if (scheduleTimes.isEmpty) {
          // PERUBAHAN: Tampilkan snackbar hanya jika scheduleTimesList kosong
          Get.snackbar(
            'Information',
            'Tidak ada Schedule Time yang tersedia untuk tanggal ${DateFormat('dd/MM/yyyy').format(selectedDate.value!)}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } else {
        selectedScheduleDateId.value = null;
        print('Tidak ada ScheduleDate yang cocok.');
      }
    } else {
      selectedScheduleDateId.value = null;
      print('Tanggal dibatalkan.');
    }
  }

  // Method untuk mengatur selectedScheduleTime
  void setSelectedScheduleTime(ScheduleTime? time) {
    selectedScheduleTime.value = time;
    selectedTime.value = time?.scheduleTime ?? '';
  }

  void setTime(String time) {
    selectedTime.value = time;
  }

  String generateRandomQrCode(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  void resetForm() {
    selectedClinic.value = null;
    selectedPoly.value = null;
    selectedDoctor.value = null;
    selectedDate.value = null;
    selectedScheduleDateId.value = null;
    selectedScheduleTime.value = null;
    selectedTime.value = '';
    polies.clear();
    doctors.clear();
    scheduleDates.clear();
    scheduleTimes.clear();
    isPolyAvailable.value = true;
    isDoctorAvailable.value = true;
    isScheduleDateAvailable.value = true;
    isScheduleTimeAvailable.value = true;

    // Tambahkan baris ini:
    isFormReadOnly.value = false;
  }

}

