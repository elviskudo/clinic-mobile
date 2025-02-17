import 'package:clinic_ai/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListPatientsController extends GetxController {
  final supabase = Supabase.instance.client;
  var selectedFilter = 'All'.obs;

   Stream<List<Appointment>> getAppointmentsStream() {
    return supabase
        .from('appointments')
        .stream(primaryKey: ['id'])
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

  List<Appointment> filterAppointments(List<Appointment> appointments, String filter) {
    if (filter == 'All') {
      return appointments;
    } else if (filter == 'Waiting') {
      return appointments.where((appointment) => appointment.status == 0).toList();
    } else {
      return appointments.where((appointment) => appointment.status == 1).toList();
    }
  }

  Future<void> updateAppointmentStatus(String appointmentId, int status) async {
    try {
      await supabase
          .from('appointments')
          .update({'status': status})
          .eq('id', appointmentId);
      
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