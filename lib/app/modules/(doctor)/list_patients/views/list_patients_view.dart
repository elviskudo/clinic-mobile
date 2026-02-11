import 'package:clinic_ai/app/modules/(doctor)/home_doctor/controllers/home_doctor_controller.dart';
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
        title: const Text('List Patients'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
          Obx(() {
            // Show date picker if date filter is selected
            if (controller.selectedFilter.value == 'Date') {
              return _buildDateFilter();
            }

            // Show status filter if status filter is selected
            if (controller.selectedFilter.value == 'Status') {
              return _buildStatusFilter();
            }

            return const SizedBox.shrink();
          }),
          Expanded(
            child: Obx(() {
              // 1. CEK DULU: Jika Doctor ID masih kosong, tampilkan Loading
              if (controller.doctorId.value.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text("Mengambil profil dokter..."),
                    ],
                  ),
                );
              }

              // 2. Jika Doctor ID sudah ada, baru jalankan StreamBuilder
              return StreamBuilder<List<Appointment>>(
                // PENTING: Gunakan key unik agar StreamBuilder di-reset jika filter berubah
                key: ValueKey(controller.selectedFilter.value),
                stream: controller.getAppointmentsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  // Cek null dan empty
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today,
                              size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada pasien untuk Dokter ID: ${controller.doctorId.value}',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  final filteredAppointments = controller.filterAppointments(
                      snapshot.data!, controller.selectedFilter.value);

                  if (filteredAppointments.isEmpty) {
                    return const Center(
                        child: Text(
                            'Tidak ada janji temu yang cocok dengan filter.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredAppointments.length,
                    itemBuilder: (context, index) {
                      return _buildAppointmentCard(filteredAppointments[
                          index]); // Pastikan fungsi ini ada di class View Anda
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          _buildFilterChip('All'),
          const SizedBox(width: 8),
          _buildFilterChip('Date'),
          const SizedBox(width: 8),
          _buildFilterChip('Status'),
          const Spacer(),
          Obx(() {
            if (controller.selectedFilter.value != 'All') {
              return IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () => controller.clearFilters(),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Obx(() {
      bool isSelected = controller.selectedFilter.value == label;
      return GestureDetector(
        onTap: () {
          controller.selectedFilter.value = label;
          if (label == 'All') {
            controller.clearFilters();
          } else if (label == 'Date') {
            // If date is already selected, keep it active
            controller.isDateFilterActive.value =
                controller.selectedDate.value != null;
            controller.isStatusFilterActive.value = false;
          } else if (label == 'Status') {
            // If status is already selected, keep it active
            controller.isStatusFilterActive.value =
                controller.selectedStatus.value != 'All';
            controller.isDateFilterActive.value = false;
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFFD7F1D8) : const Color(0xFFEAEAEA),
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

  Widget _buildDateFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Obx(() {
              final selectedDate = controller.selectedDate.value;
              final dateText = selectedDate != null
                  ? DateFormat('yyyy-MM-dd').format(selectedDate)
                  : 'Select date';

              return OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(dateText),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: Get.context!,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );

                  if (pickedDate != null) {
                    controller.setDateFilter(pickedDate);
                  }
                },
              );
            }),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => controller.setDateFilter(null),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.statusOptions
            .map((status) => _buildStatusFilterChip(status))
            .toList(),
      ),
    );
  }

  Widget _buildStatusFilterChip(String status) {
    return Obx(() {
      final isSelected = controller.selectedStatus.value == status;
      Color chipColor;

      // Choose color based on status
      switch (status) {
        case 'Waiting':
          chipColor = Colors.orange;
          break;
        case 'Approved':
          chipColor = Colors.blue;
          break;
        case 'Rejected':
          chipColor = Colors.red;
          break;
        case 'Diagnose':
          chipColor = Colors.purple;
          break;
        case 'Unpaid':
          chipColor = Colors.amber;
          break;
        case 'Waiting for Drugs':
          chipColor = Colors.teal;
          break;
        case 'Completed':
          chipColor = Colors.green;
          break;
        default:
          chipColor = Colors.grey;
      }

      return GestureDetector(
        onTap: () => controller.setStatusFilter(status),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? chipColor.withOpacity(0.3)
                : const Color(0xFFEAEAEA),
            borderRadius: BorderRadius.circular(20),
            border: isSelected ? Border.all(color: chipColor) : null,
          ),
          child: Text(
            status,
            style: TextStyle(
              color: isSelected ? chipColor : Colors.grey[800],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    // Use AppointmentStatus to get the status text
    String statusText = AppointmentStatus.getStatusText(appointment.status);
    Color statusColor;

    // Choose color based on status
    switch (appointment.status) {
      case AppointmentStatus.waiting:
        statusColor = Colors.orange;
        break;
      case AppointmentStatus.approved:
        statusColor = Colors.blue;
        break;
      case AppointmentStatus.rejected:
        statusColor = Colors.red;
        break;
      case AppointmentStatus.diagnose:
        statusColor = Colors.purple;
        break;
      case AppointmentStatus.unpaid:
        statusColor = Colors.amber;
        break;
      case AppointmentStatus.waitingForDrugs:
        statusColor = Colors.teal;
        break;
      case AppointmentStatus.completed:
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    String formattedDate = '';

    if (appointment.updatedAt != null) {
      formattedDate = DateFormat('EEEE, MMMM d, yyyy | HH:mm')
          .format(appointment.updatedAt!);
    }

    return InkWell(
      onTap: () {
        // Allow scanning only for appointments that are not completed or rejected
        if (appointment.status != AppointmentStatus.completed &&
            appointment.status != AppointmentStatus.rejected) {
          Get.toNamed(Routes.QR_SCANNER_SCREEN, arguments: appointment);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: appointment.status == AppointmentStatus.rejected
              ? const Color(0xFFFFF3F0) // Light red for rejected
              : appointment.status == AppointmentStatus.completed
                  ? Colors.white // White for completed
                  : const Color(0xFFE8F5E9), // Light green for others
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 8, top: 12, bottom: 0),
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
                style: const TextStyle(
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
              trailing: _buildStatusChip(statusText, statusColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
