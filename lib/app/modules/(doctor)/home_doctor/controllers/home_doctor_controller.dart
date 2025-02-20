import 'package:clinic_ai/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void onInit() {
    super.onInit();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId.value = prefs.getString('userId') ?? '';
    currentUserName.value = prefs.getString('name') ?? '';
  }

  Stream<List<Appointment>> getAppointmentsStream() async* {
    yield* supabase
        .from('appointments')
        .stream(primaryKey: ['id'])
        .eq('doctor_id', currentUserId.value)
        .order('created_at')
        .map((events) => events.map((item) async {
              Appointment appointment = Appointment.fromJson(item);

              try {
                final userData = await supabase
                    .from('users')
                    .select('name')
                    .eq('id', appointment.userId)
                    .single();

                final polyData = await supabase
                    .from('polies')
                    .select('name')
                    .eq('id', appointment.polyId)
                    .single();

                appointment = appointment.copyWith(
                  user_name: userData['name'],
                  poly_name: polyData['name'],
                );
              } catch (e) {
                print('Error fetching related data: $e');
              }

              return appointment;
            }).toList())
        .asyncMap((appointments) => Future.wait(appointments))
        .map((appointments) {
          // Update all appointments
          allAppointments.value = appointments;

          // Update today's appointments
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          todayAppointments.value = appointments
              .where((app) =>
                  DateTime(app.createdAt.year, app.createdAt.month,
                      app.createdAt.day) ==
                  today)
              .toList();

          // Update stats
          activePatients.value = appointments
              .where((app) =>
                  DateTime(app.createdAt.year, app.createdAt.month,
                          app.createdAt.day) ==
                      today &&
                  AppointmentStatus.isActiveStatus(app.status))
              .length;

          waitingPatients.value = appointments
              .where((app) => app.status == AppointmentStatus.waiting)
              .length;

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
