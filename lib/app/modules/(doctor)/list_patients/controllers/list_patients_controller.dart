import 'package:clinic_ai/app/modules/(doctor)/home_doctor/controllers/home_doctor_controller.dart';
import 'package:clinic_ai/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class ListPatientsController extends GetxController {
  final supabase = Supabase.instance.client;
  var selectedFilter = 'All'.obs;
  RxString currentUserId = ''.obs;
  final RxInt selectedIndex = 1.obs;

  // TAMBAHAN PENTING: Variabel Doctor ID & Base URL
  RxString doctorId = ''.obs;
  final baseUrl = "https://be-clinic-rx7y.vercel.app";

  // Date filter
  final selectedDate = Rx<DateTime?>(null);
  final isDateFilterActive = false.obs;

  // Status filter
  final selectedStatus = 'All'.obs;
  final isStatusFilterActive = false.obs;
  final List<String> statusOptions = [
    'All',
    'Waiting',
    'Approved',
    'Rejected',
    'Diagnose',
    'Unpaid',
    'Waiting for Drugs',
    'Completed',
  ];

  @override
  void onInit() {
    super.onInit();
    initialDataLoad(); // Panggil fungsi load data
  }

  Future<void> initialDataLoad() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId.value = prefs.getString('userId') ?? '';
    await fetchDoctorId(); // Cari ID Dokter dulu sebelum stream jalan!
  }

  // --- FUNGSI CARI DOKTER ID (COPAS DARI HOME) ---
  Future<void> fetchDoctorId() async {
    try {
      print(
          "Fetching Doctor ID in ListPatients for User: ${currentUserId.value}");

      final response = await GetConnect().get(
        '$baseUrl/doctors/profile/${currentUserId.value}',
      );

      if (response.status.isOk) {
        final body = response.body;
        // Sesuai log terakhir lu, datanya ada di body['data']['id']
        if (body != null &&
            body['data'] != null &&
            body['data']['id'] != null) {
          doctorId.value = body['data']['id'].toString();
          print("✅ Doctor ID Found (ListPatients): ${doctorId.value}");
        } else {
          print("⚠️ Data dokter kosong.");
        }
      } else {
        print("❌ Gagal fetch API.");
      }
    } catch (e) {
      print("❌ Error: $e");
    }
  }

  Stream<List<Appointment>> getAppointmentsStream() async* {
    // 1. Cek Doctor ID
    if (doctorId.value.isEmpty) {
      await fetchDoctorId();
    }

    if (doctorId.value.isEmpty) {
      yield [];
      return;
    }

    print('🚀 Streaming appointments for Doctor ID: ${doctorId.value}');

    yield* supabase
        .from('appointments')
        .stream(primaryKey: ['id'])
        .eq('doctor_id', doctorId.value) // ✅ KEMBALIKAN FILTER INI
        .order('updated_at')
        .asyncMap((List<Map<String, dynamic>> data) async {
          if (data.isEmpty) return <Appointment>[];

          // --- TEKNIK BATCH FETCHING (ANTI-CRASH) ---
          // Daripada nembak 60x, kita kumpulkan ID-nya dulu

          // 1. Ambil semua User ID & Poly ID unik dari data appointment
          final userIds = data.map((e) => e['user_id']).toSet().toList();
          final polyIds = data.map((e) => e['poly_id']).toSet().toList();

          // 2. Ambil Data User SEKALIGUS (Cuma 1 Request)
          final usersResponse = await supabase
              .from('users')
              .select('id, name')
              .inFilter('id', userIds); // Ambil user yang ID-nya ada di list

          // 3. Ambil Data Poly SEKALIGUS (Cuma 1 Request)
          final poliesResponse = await supabase
              .from('polies')
              .select('id, name')
              .inFilter('id', polyIds);

          // 4. Buat Kamus (Map) agar pencarian cepat
          // Contoh: {'id_user_1': 'Budi', 'id_user_2': 'Siti'}
          final userMap = {
            for (var item in usersResponse) item['id']: item['name']
          };

          final polyMap = {
            for (var item in poliesResponse) item['id']: item['name']
          };

          // 5. Gabungkan Data (Tanpa Request Internet lagi)
          return data.map((item) {
            final appointment = Appointment.fromJson(item);

            // Cari nama di kamus yang sudah kita download tadi
            final userName = userMap[appointment.userId] ?? 'Unknown';
            final polyName = polyMap[appointment.polyId] ?? '-';

            return appointment.copyWith(
              user_name: userName,
              poly_name: polyName,
            );
          }).toList();
        });
  }

  // ... (Sisa fungsi filter, setDate, setStatus, updateStatus SAMA PERSIS kayak kode lu) ...

  void setDateFilter(DateTime? date) {
    selectedDate.value = date;
    isDateFilterActive.value = date != null;
    if (isDateFilterActive.value) {
      selectedFilter.value = 'Date';
    } else if (isStatusFilterActive.value) {
      selectedFilter.value = 'Status';
    } else {
      selectedFilter.value = 'All';
    }
  }

  void setStatusFilter(String status) {
    if (status == 'All') {
      isStatusFilterActive.value = false;
      selectedStatus.value = 'All';
    } else {
      isStatusFilterActive.value = true;
      selectedStatus.value = status;
      selectedFilter.value = 'Status';
    }
    if (!isDateFilterActive.value && !isStatusFilterActive.value) {
      selectedFilter.value = 'All';
    }
  }

  void clearFilters() {
    selectedDate.value = null;
    isDateFilterActive.value = false;
    selectedStatus.value = 'All';
    isStatusFilterActive.value = false;
    selectedFilter.value = 'All';
  }

  List<Appointment> filterAppointments(
      List<Appointment> appointments, String filter) {
    List<Appointment> filteredList = List.from(appointments);

    if (isDateFilterActive.value && selectedDate.value != null) {
      filteredList = filteredList.where((appointment) {
        if (appointment.updatedAt == null) return false;
        final appointmentDate = DateTime(
          appointment.updatedAt!.year,
          appointment.updatedAt!.month,
          appointment.updatedAt!.day,
        );
        final filterDate = DateTime(
          selectedDate.value!.year,
          selectedDate.value!.month,
          selectedDate.value!.day,
        );
        return appointmentDate.isAtSameMomentAs(filterDate);
      }).toList();
    }

    if (isStatusFilterActive.value && selectedStatus.value != 'All') {
      final statusValue =
          AppointmentStatus.getStatusValue(selectedStatus.value);
      if (statusValue != -1) {
        filteredList = filteredList
            .where((appointment) => appointment.status == statusValue)
            .toList();
      }
    }
    return filteredList;
  }

  Future<void> updateAppointmentStatus(String appointmentId, int status) async {
    // Logic update status lu udah bener, pake API atau Supabase bebas
    // Karena ini simple update field, Supabase direct kayak kode lu aman.
    try {
      await supabase
          .from('appointments')
          .update({'status': status}).eq('id', appointmentId);
      Get.snackbar('Success', 'Status updated',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (error) {
      Get.snackbar('Error', 'Failed update',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
