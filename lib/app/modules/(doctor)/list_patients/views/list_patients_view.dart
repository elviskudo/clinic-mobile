import 'package:clinic_ai/app/modules/(doctor)/qr_scanner_screen/views/qr_scanner_screen_view.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/color/color.dart';
import 'package:clinic_ai/models/appointment_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/list_patients_controller.dart';

class ListPatientsView extends GetView<ListPatientsController> {
  const ListPatientsView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ListPatientsController());
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('List Patients'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();

            await prefs.setBool('isLoggedIn', false);
            await prefs.remove('userRole');
            await prefs.remove('userId');
            await prefs.remove('name');
            await GoogleSignIn().signOut();
            Get.offAllNamed(Routes.LOGIN);
          },
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterOptions(),
          Expanded(
            child: StreamBuilder<List<Appointment>>(
              stream: controller.getAppointmentsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No appointments found'),
                  );
                }

                final filteredAppointments = controller.filterAppointments(
                    snapshot.data!, controller.selectedFilter.value);

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: filteredAppointments.length,
                  itemBuilder: (context, index) {
                    return _buildAppointmentCard(
                      filteredAppointments[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          _buildFilterChip('All'),
          SizedBox(width: 8),
          _buildFilterChip('Date'),
          SizedBox(width: 8),
          _buildFilterChip('Status'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Obx(() {
      bool isSelected = controller.selectedFilter.value == label;
      return GestureDetector(
        // onTap: () => controller.filterByStatus(label),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFFD7F1D8) : Color(0xFFEAEAEA),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.green : Colors.grey[800],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    bool isCompleted = appointment.status == 1;
    String formattedDate = '';

    if (appointment.updatedAt != null) {
      formattedDate = DateFormat('EEEE, MMMM d, yyyy | HH:mm')
          .format(appointment.updatedAt!);
    }

    return InkWell(
      onTap: () {
        if (!isCompleted) {
          // Only allow scanning for non-completed appointments
          Get.toNamed(Routes.QR_SCANNER_SCREEN, arguments: appointment);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isCompleted ? Colors.white : Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 8, top: 12, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.grey),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, color: Colors.grey[600]),
              ),
              title: Text(
                appointment.user_name ?? "no name",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                appointment.poly_name ?? 'description',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              trailing: isCompleted
                  ? _buildStatusChip('Approved', Colors.blue)
                  : _buildStatusChip('Waiting', Colors.orange),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
