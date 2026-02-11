import 'package:clinic_ai/models/appointment_model.dart';
import 'package:clinic_ai/models/scheduleTime_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeDoctorController extends GetxController {
  final supabase = Supabase.instance.client;
  final RxInt selectedIndex = 0.obs;
  RxString currentUserId = ''.obs;
  RxString currentUserName = ''.obs;

  // Observable lists and stats
  final RxList<Appointment> allAppointments = <Appointment>[].obs;
  final RxList<Appointment> todayAppointments = <Appointment>[].obs;
  RxInt todayPatients = 0.obs;
  RxInt pendingAppointments = 0.obs;
  RxInt activePatients = 0.obs;
  RxInt waitingPatients = 0.obs;
  RxString doctorId = ''.obs;
  final baseUrl = "https://be-clinic-rx7y.vercel.app";

  @override
  void onInit() {
    super.onInit();
    // getCurrentUser();
    initialDataLoad();
  }

  Future<void> initialDataLoad() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId.value = prefs.getString('userId') ?? '';
    currentUserName.value = prefs.getString('name') ?? '';

    await fetchDoctorId(); // Cari ID Dokter dulu!
  }

  Future<void> fetchDoctorId() async {
    try {
      print("Fetching Doctor ID from API for User: ${currentUserId.value}");

      // Tembak API NestJS
      final response = await GetConnect().get(
        '$baseUrl/doctors/profile/${currentUserId.value}',
      );

      print("Status API: ${response.statusCode}");
      print("Body API: ${response.body}"); // Debugging: Liat isi aslinya

      if (response.status.isOk) {
        final body = response.body;

        // Cek bertingkat biar aman dari null
        if (body != null &&
            body['data'] != null &&
            body['data']['id'] != null) {
          // SOLUSI UTAMA: Pake .toString() biar gak error tipe data
          doctorId.value = body['data']['id'].toString();

          print("✅ Doctor ID Found (API): ${doctorId.value}");
        } else {
          print("⚠️ Data dokter kosong atau struktur JSON salah.");
        }
      } else {
        print("❌ Gagal fetch API. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching doctor ID from API: $e");
    }
  }

  // Future<void> getCurrentUser() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   currentUserId.value = prefs.getString('userId') ?? '';
  //   currentUserName.value = prefs.getString('name') ?? '';
  // }

  Stream<List<Appointment>> getAppointmentsStream() async* {
    if (doctorId.value.isEmpty) {
      await fetchDoctorId();
    }

    if (doctorId.value.isEmpty) {
      yield [];
      return;
    }

    yield* supabase
        .from('appointments')
        .stream(primaryKey: ['id'])
        .eq('doctor_id', doctorId.value)
        .order('created_at')
        .map((events) => events.map((item) async {
              Appointment appointment = Appointment.fromJson(item);

              try {
                // 1. Fetch User (Nama Pasien)
                final userData = await supabase
                    .from('users')
                    .select('name')
                    .eq('id', appointment.userId)
                    .maybeSingle();

                // 2. Fetch Poly (Nama Poli)
                final polyData = await supabase
                    .from('polies')
                    .select('name')
                    .eq('id', appointment.polyId)
                    .maybeSingle();

                // 3. Fetch Schedule Time (Jam) - INI YANG KETINGGALAN KEMARIN
                final timeData = await supabase
                    .from('schedule_times') // Nama tabel di database
                    .select()
                    .eq('id', appointment.timeId)
                    .maybeSingle();

                // Update data appointment dengan hasil fetch
                appointment = appointment.copyWith(
                  user_name: userData != null ? userData['name'] : 'Unknown',
                  poly_name: polyData != null ? polyData['name'] : '-',
                );

                // Masukkan object time secara manual karena copyWith mungkin belum support object nested
                if (timeData != null) {
                  appointment.time = ScheduleTime.fromJson(timeData);
                }
              } catch (e) {
                print("Error fetching details: $e");
              }
              return appointment;
            }).toList())
        .asyncMap((appointments) => Future.wait(appointments))
        .map((appointments) {
          // --- LOGIKA FILTER HARI INI & STATISTIK ---

          allAppointments.value = appointments;

          // Reset Hitungan
          int waiting = 0;
          int approved = 0;
          int diagnose = 0;
          int unpaid = 0;
          int drugs = 0;
          int completed = 0;

          final now = DateTime.now();
          final todayString = DateFormat('yyyy-MM-dd').format(now);

          List<Appointment> todayList = [];

          for (var app in appointments) {
            // Hitung Statistik
            switch (app.status) {
              case 1:
                waiting++;
                break;
              case 2:
                approved++;
                break;
              case 4:
                diagnose++;
                break;
              case 5:
                unpaid++;
                break;
              case 6:
                drugs++;
                break;
              case 7:
                completed++;
                break;
            }

            // Filter Hari Ini (Cek CreatedAt atau ScheduleDate)
            // Kita pakai createdAt dulu yang paling aman untuk test
            final appDateStr = DateFormat('yyyy-MM-dd').format(app.createdAt);

            if (appDateStr == todayString) {
              todayList.add(app);
            }
          }

          todayAppointments.value = todayList;

          // Update ke variabel reactive agar UI berubah
          waitingPatients.value = waiting;
          // (Anda bisa update variabel stats lain di sini jika perlu ditampilkan)

          return appointments;
        });
  }

  Future<void> updateAppointmentStatus(String appointmentId, int status) async {
    try {
      await supabase
          .from('appointments')
          .update({'status': status}).eq('id', appointmentId);

      Get.snackbar(
        'Success',
        'Appointment status updated',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (error) {
      print('Error updating appointment status: $error');
      Get.snackbar(
        'Error',
        'Failed to update appointment status',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  int getStatusCount(int status) {
    return allAppointments
        .where((appointment) => appointment.status == status)
        .length;
  }
}

class AppointmentStatus {
  static const int waiting = 1;
  static const int approved = 2;
  static const int rejected = 3;
  static const int diagnose = 4;
  static const int unpaid = 5;
  static const int waitingForDrugs = 6;
  static const int completed = 7;

  static String getStatusText(int status) {
    switch (status) {
      case waiting:
        return 'Waiting';
      case approved:
        return 'Approved';
      case rejected:
        return 'Rejected';
      case diagnose:
        return 'Diagnose';
      case unpaid:
        return 'Unpaid';
      case waitingForDrugs:
        return 'Waiting for Drugs';
      case completed:
        return 'Completed';
      default:
        return 'Unknown';
    }
  }

  static int getStatusValue(String statusText) {
    switch (statusText) {
      case 'Waiting':
        return waiting;
      case 'Approved':
        return approved;
      case 'Rejected':
        return rejected;
      case 'Diagnose':
        return diagnose;
      case 'Unpaid':
        return unpaid;
      case 'Waiting for Drugs':
        return waitingForDrugs;
      case 'Completed':
        return completed;
      default:
        return -1; // Unknown status
    }
  }

  static Color getStatusColor(int status) {
    switch (status) {
      case waiting:
        return Colors.orange;
      case approved:
        return Colors.blue;
      case rejected:
        return Colors.red;
      case diagnose:
        return Colors.purple;
      case unpaid:
        return Colors.amber;
      case waitingForDrugs:
        return Colors.teal;
      case completed:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  static bool isActiveStatus(int status) {
    // Returns true for statuses that count as "active" cases
    return status == waiting ||
        status == approved ||
        status == diagnose ||
        status == unpaid ||
        status == waitingForDrugs;
  }
}
