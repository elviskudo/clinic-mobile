import 'package:clinic_ai/models/clinic_model.dart';
import 'package:clinic_ai/models/doctor_model.dart';
import 'package:clinic_ai/models/poly_model.dart';
import 'package:clinic_ai/models/scheduleDate_model.dart';
import 'package:clinic_ai/models/scheduleTime_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class ScheduleAppointmentController extends GetxController {
  final supabase = Supabase.instance.client;

  final Rxn<Clinic> selectedClinic = Rxn<Clinic>();
  final Rxn<Poly> selectedPoly = Rxn<Poly>();
  final Rxn<Doctor> selectedDoctor = Rxn<Doctor>();
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rxn<String> selectedScheduleDateId = Rxn<String>();
  final selectedTime = ''.obs;

  // Schedule Times
  final RxList<ScheduleTime> scheduleTimes = <ScheduleTime>[].obs;
  final RxBool isLoadingScheduleTimes = false.obs;
  final Rxn<ScheduleTime> selectedScheduleTime = Rxn<ScheduleTime>();

  // Flag untuk menandakan data tidak tersedia
  final RxBool isPolyAvailable = true.obs;
  final RxBool isDoctorAvailable = true.obs;
  final RxBool isScheduleDateAvailable = true.obs;
  final RxBool isScheduleTimeAvailable = true.obs;

  final RxList<Clinic> clinics = <Clinic>[].obs;
  final RxBool isLoadingClinics = false.obs;

  final RxList<Poly> polies = <Poly>[].obs;
  final RxBool isLoadingPolies = false.obs;

  final RxList<Doctor> doctors = <Doctor>[].obs;
  final RxBool isLoadingDoctors = false.obs;

  final RxList<ScheduleDate> scheduleDates = <ScheduleDate>[].obs;
  final RxBool isLoadingScheduleDates = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClinics();
    ever(selectedDoctor, (Doctor? doctor) {
      if (selectedPoly.value != null && doctor != null) {
        fetchScheduleDates(selectedPoly.value!.id, doctor.id);
      } else {
        scheduleDates.clear();
        selectedDate.value = null;
        selectedScheduleDateId.value = null;
        scheduleTimes.clear(); // bersihkan schdeuletimes
        isScheduleDateAvailable.value = true;
      }
    });

    // Reaktif terhadap perubahan pada selectedScheduleDateId
    ever(selectedScheduleDateId, (String? dateId) {
      if (dateId != null) {
        fetchScheduleTimes(dateId);
      } else {
        scheduleTimes.clear(); // bersihkan scheduleTimes
        selectedScheduleTime.value = null;
        isScheduleTimeAvailable.value = true;
      }
    });
  }

  Future<void> fetchClinics() async {
    try {
      isLoadingClinics.value = true;
      final response = await supabase.from('clinics').select();
      if (response != null) {
        clinics.assignAll((response as List).map((json) => Clinic.fromJson(json)).toList());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load clinics: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingClinics.value = false;
    }
  }

  Future<void> fetchPolies(String clinicId) async {
    try {
      isLoadingPolies.value = true;
      final response = await supabase.from('polies').select().eq('clinic_id', clinicId);
      if (response != null) {
        final poliesList = (response as List).map((json) => Poly.fromJson(json)).toList();
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
      Get.snackbar('Error', 'Failed to load polies: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
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
      final response = await supabase.from('doctors').select().eq('clinic_id', clinicId).eq('poly_id', polyId);
      if (response != null) {
        final doctorsList = (response as List).map((json) => Doctor.fromJson(json)).toList();
        doctors.assignAll(doctorsList);
        isDoctorAvailable.value = doctorsList.isNotEmpty;

        scheduleDates.clear();
        selectedDate.value = null;
        selectedScheduleDateId.value = null;
        scheduleTimes.clear(); // bersihkan scheduleTimes
      } else {
        isDoctorAvailable.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load doctors: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
      isDoctorAvailable.value = false;
    } finally {
      isLoadingDoctors.value = false;
      if (!isDoctorAvailable.value && selectedPoly.value != null) {
        Get.snackbar(
          'Information',
          'Tidak ada Doctor yang tersedia untuk Poly ${selectedPoly.value!.name}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> fetchScheduleDates(String polyId, String doctorId) async {
    try {
      isLoadingScheduleDates.value = true;
      final response = await supabase.from('schedule_dates').select().eq('poly_id', polyId).eq('doctor_id', doctorId);
      if (response != null) {
        final scheduleDatesList = (response as List).map((json) => ScheduleDate.fromJson(json)).toList();
        scheduleDates.assignAll(scheduleDatesList);
        isScheduleDateAvailable.value = scheduleDatesList.isNotEmpty;
        scheduleTimes.clear(); // bersihkan scheduleTimes
        selectedScheduleTime.value = null;
      } else {
        isScheduleDateAvailable.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load schedule dates: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
      isScheduleDateAvailable.value = false;
    } finally {
      isLoadingScheduleDates.value = false;
      if (!isScheduleDateAvailable.value && selectedDoctor.value != null) {
        Get.snackbar(
          'Information',
          'Tidak ada Schedule Date yang tersedia untuk Doctor ${selectedDoctor.value!.name}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  // Fetch Schedule Times berdasarkan dateId
  Future<void> fetchScheduleTimes(String dateId) async {
    try {
      isLoadingScheduleTimes.value = true;
      final response = await supabase
          .from('schedule_times')
          .select()
          .eq('date_id', dateId);

      if (response != null) {
        final scheduleTimesList = (response as List)
            .map((json) => ScheduleTime.fromJson(json))
            .toList();
        scheduleTimes.assignAll(scheduleTimesList);
        isScheduleTimeAvailable.value = scheduleTimesList.isNotEmpty;
      } else {
        isScheduleTimeAvailable.value = false;
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
      if (!isScheduleTimeAvailable.value && selectedDate.value != null) {
        Get.snackbar(
          'Information',
          'Tidak ada Schedule Time yang tersedia untuk tanggal ${DateFormat('dd/MM/yyyy').format(selectedDate.value!)}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
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

  void setSelectedDate(DateTime? date) {
    print('setSelectedDate dipanggil dengan date: $date');
    selectedDate.value = date;
    print('selectedDate.value sekarang: ${selectedDate.value}');

    selectedScheduleTime.value = null; // Reset selectedScheduleTime
    scheduleTimes.clear(); // Bersihkan daftar waktu

    if (date != null) {
      ScheduleDate? selectedScheduleDate = scheduleDates.firstWhereOrNull((scheduleDate) =>
      scheduleDate.scheduleDate.year == date.year &&
          scheduleDate.scheduleDate.month == date.month &&
          scheduleDate.scheduleDate.day == date.day);

      if (selectedScheduleDate != null) {
        selectedScheduleDateId.value = selectedScheduleDate.id;
        print('selectedScheduleDateId.value sekarang: ${selectedScheduleDateId.value}');
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

  bool isFormValid() {
    return selectedClinic.value != null &&
        selectedPoly.value != null &&
        selectedDoctor.value != null &&
        selectedDate.value != null &&
        selectedScheduleTime.value != null; // Ubah validasi
  }

  void onNextPressed() {
    if (isFormValid()) {
      print("Selected Doctor ID: ${selectedDoctor.value!.id}");
      print("Selected ScheduleDate ID: ${selectedScheduleDateId.value}");
      print("Selected ScheduleTime ID: ${selectedScheduleTime.value!.id}"); // Tampilkan ID waktu
    }
  }
}