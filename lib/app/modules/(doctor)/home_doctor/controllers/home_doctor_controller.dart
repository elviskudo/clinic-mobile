import 'package:clinic_ai/models/appointment_model.dart';
import 'package:clinic_ai/models/scheduleTime_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:clinic_ai/models/scheduleDate_model.dart';

class HomeDoctorController extends GetxController {
  final supabase = Supabase.instance.client;
  final RxInt selectedIndex = 0.obs;
  RxString currentUserId = ''.obs;
  RxString currentUserName = ''.obs;

  // Observable lists and stats
  final RxList<Appointment> allAppointments = <Appointment>[].obs;
  final RxList<Appointment> todayAppointments = <Appointment>[].obs;
  RxInt todayPatients = 0.obs;
  RxInt activePatients = 0.obs;
  RxInt waitingPatients = 0.obs;
  RxString doctorId = ''.obs;
  final baseUrl = "https://be-clinic-rx7y.vercel.app";

  @override
  void onInit() {
    super.onInit();
    initialDataLoad();
  }

  Future<void> initialDataLoad() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId.value = prefs.getString('userId') ?? '';
    currentUserName.value = prefs.getString('name') ?? '';

    await fetchDoctorId();
  }

  Future<void> fetchDoctorId() async {
    try {
      print("Fetching Doctor ID from API for User: ${currentUserId.value}");

      final response = await GetConnect().get(
        '$baseUrl/doctors/profile/${currentUserId.value}',
      );

      print("Status API: ${response.statusCode}");

      if (response.status.isOk) {
        final body = response.body;

        if (body != null &&
            body['data'] != null &&
            body['data']['id'] != null) {
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

  Stream<List<Appointment>> getAppointmentsStream() async* {
    if (doctorId.value.isEmpty) {
      await fetchDoctorId();
    }

    if (doctorId.value.isEmpty) {
      print("⚠️ Doctor ID Kosong, Stream berhenti.");
      yield [];
      return;
    }

    print('🚀 START STREAMING... Target Doctor ID: ${doctorId.value}');

    yield* supabase
        .from('appointments')
        .stream(primaryKey: ['id'])
        .eq('doctor_id', doctorId.value)
        .order('created_at')
        .map((events) {
          return events;
        })
        .map((events) => events.map((item) async {
              Appointment appointment = Appointment.fromJson(item);

              try {
                // Fetch User
                final userData = await supabase
                    .from('users')
                    .select('name')
                    .eq('id', appointment.userId)
                    .maybeSingle();
                // Fetch Poly
                final polyData = await supabase
                    .from('polies')
                    .select('name')
                    .eq('id', appointment.polyId)
                    .maybeSingle();
                // Fetch Time
                final timeData = await supabase
                    .from('schedule_times')
                    .select()
                    .eq('id', appointment.timeId)
                    .maybeSingle();
                // Fetch Date
                final dateData = await supabase
                    .from('schedule_dates')
                    .select()
                    .eq('id', appointment.dateId)
                    .maybeSingle();

                appointment = appointment.copyWith(
                  user_name: userData != null ? userData['name'] : 'Unknown',
                  poly_name: polyData != null ? polyData['name'] : '-',
                );

                if (timeData != null)
                  appointment.time = ScheduleTime.fromJson(timeData);
                if (dateData != null)
                  appointment.date = ScheduleDate.fromJson(dateData);
              } catch (e) {
                print("Error details: $e");
              }
              return appointment;
            }).toList())
        .asyncMap((appointments) => Future.wait(appointments))
        .map((appointments) {
          allAppointments.value = appointments;

          // ==========================================
          // FIX: RESET HITUNGAN (HANYA 8 STATUS AKTIF)
          // ==========================================
          int waiting = 0; // 1
          int approved = 0; // 2
          int diagnose = 0; // 4
          int unpaid = 0; // 6
          int getMedicine = 0; // 7
          int completed = 0; // 8

          final now = DateTime.now();
          final todayString = DateFormat('yyyy-MM-dd').format(now);
          List<Appointment> todayList = [];

          for (var app in appointments) {
            // Hitung Stats sesuai status baru
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
              case 6:
                unpaid++;
                break;
              case 7:
                getMedicine++;
                break;
              case 8:
                completed++;
                break;
            }

            // Filter Tanggal
            String checkDate = '';
            if (app.date != null && app.date!.scheduleDate != null) {
              checkDate = DateFormat('yyyy-MM-dd')
                  .format(app.date!.scheduleDate!.toLocal());
            } else {
              checkDate =
                  DateFormat('yyyy-MM-dd').format(app.createdAt.toLocal());
            }

            if (checkDate == todayString) {
              todayList.add(app);
            }
          }

          todayAppointments.value = todayList;
          waitingPatients.value = waiting;
          activePatients.value = waiting + approved + diagnose;

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

// ==========================================
// FIX: CLASS HELPER STATUS SESUAI ATURAN BARU
// ==========================================
class AppointmentStatus {
  static const int waiting = 1;
  static const int approved = 2;
  static const int rejected = 3;
  static const int diagnose = 4; // atau Summary
  static const int redeemed = 5;
  static const int unpaid = 6;
  static const int getMedicine = 7;
  static const int completed = 8;

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
      case redeemed:
        return 'Redeemed';
      case unpaid:
        return 'Unpaid';
      case getMedicine:
        return 'Get Medicine';
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
      case 'Redeemed':
        return redeemed;
      case 'Unpaid':
        return unpaid;
      case 'Get Medicine':
        return getMedicine;
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
      case redeemed:
        return Colors.indigo;
      case unpaid:
        return Colors.amber;
      case getMedicine:
        return Colors.teal;
      case completed:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  static bool isActiveStatus(int status) {
    return status == waiting ||
        status == approved ||
        status == diagnose ||
        status == unpaid ||
        status == getMedicine;
  }
}