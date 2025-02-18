import 'dart:math';

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
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId.value = prefs.getString('userId') ?? '';
  }

  Stream<List<Appointment>> getAppointmentsStream() async* {
    final prefs = await SharedPreferences.getInstance();
    currentUserId.value = prefs.getString('userId') ?? '';
    print('current user id: ${currentUserId.value}');
    yield* supabase
        .from('appointments')
        .stream(primaryKey: ['id'])
        .eq('doctor_id', currentUserId.value)
        .order('updated_at')
        .map((events) => events.map((item) async {
              // Create appointment object
              Appointment appointment = Appointment.fromJson(item);

              try {
                // Fetch user data
                final userData = await supabase
                    .from('users')
                    .select('name')
                    .eq('id', appointment.userId)
                    .single();

                // Fetch poly data
                final polyData = await supabase
                    .from('polies')
                    .select('name')
                    .eq('id', appointment.polyId)
                    .single();

                // Update appointment with user and poly names
                appointment = appointment.copyWith(
                  user_name: userData['name'],
                  poly_name: polyData['name'],
                );
              } catch (e) {
                print('Error fetching related data: $e');
                // If there's an error, keep original appointment data
              }

              return appointment;
            }).toList())
        .asyncMap((appointments) => Future.wait(appointments));
  }

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

    // If no filters are active, set to 'All'
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

    // Apply date filter if active
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

    // Apply status filter if active
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
}
