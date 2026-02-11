import 'package:clinic_ai/app/modules/(doctor)/list_patients/views/list_patients_view.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/color/color.dart';
import 'package:clinic_ai/components/skeletonLoading.dart';
import 'package:clinic_ai/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; // Pastikan import ini ada
import '../controllers/home_doctor_controller.dart';

class HomeDoctorView extends GetView<HomeDoctorController> {
  const HomeDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          bgColor, // Pastikan warna background hijau muda/putih gading
      body: SafeArea(
        child: Obx(() => _buildBody()),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: controller.selectedIndex.value,
      children: [
        _buildHomePage(),
        const ListPatientsView(),
        const ListPatientsView(), // Ganti dengan ProfileView jika sudah ada
        const ListPatientsView(),
      ],
    );
  }

  Widget _buildHomePage() {
    return StreamBuilder<List<Appointment>>(
      stream: controller.getAppointmentsStream(),
      builder: (context, snapshot) {
        final bool isLoading =
            snapshot.connectionState == ConnectionState.waiting;

        // Note: Error handling di stream kadang bikin kedip, jadi bisa di-skip visualnya
        if (snapshot.hasError) {
          debugPrint('Stream Error: ${snapshot.error}');
        }

        return Column(
          children: [
            _buildHeader(isLoading),
            _buildStats(isLoading),
            _buildAppointmentsList(isLoading),
          ],
        );
      },
    );
  }

  Widget _buildHeader(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              isLoading
                  ? ShimmerEffect(
                      child: SkeletonLoading(
                          width: 150, height: 30, borderRadius: 4),
                    )
                  : Obx(
                      () => Text(
                        'Dr. ${controller.currentUserName.value}',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    )
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child:
                const Icon(Icons.notifications_outlined, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(bool isLoading) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ShimmerEffect(
          child: SkeletonLoading(
              width: double.infinity, height: 220, borderRadius: 16),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Waiting',
                      controller
                          .getStatusCount(AppointmentStatus.waiting)
                          .toString(),
                      Colors.orange,
                      Icons.hourglass_empty,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildStatCard(
                      'Approved',
                      controller
                          .getStatusCount(AppointmentStatus.approved)
                          .toString(),
                      Colors.blue,
                      Icons.check_circle_outline,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildStatCard(
                      'Diagnose',
                      controller
                          .getStatusCount(AppointmentStatus.diagnose)
                          .toString(),
                      Colors.purple,
                      Icons.medical_services_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Unpaid',
                      controller
                          .getStatusCount(AppointmentStatus.unpaid)
                          .toString(),
                      Colors.amber,
                      Icons.payment_outlined,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildStatCard(
                      'Drugs',
                      controller
                          .getStatusCount(AppointmentStatus.waitingForDrugs)
                          .toString(),
                      Colors.teal,
                      Icons.medication_outlined,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildStatCard(
                      'Done',
                      controller
                          .getStatusCount(AppointmentStatus.completed)
                          .toString(),
                      Colors.green,
                      Icons.task_alt_outlined,
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget _buildStatCard(
      String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(bool isLoading) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Appointments',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? _buildAppointmentsSkeletonList()
                  : Obx(() {
                      if (controller.todayAppointments.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today_outlined,
                                  size: 48, color: Colors.grey[300]),
                              const SizedBox(height: 12),
                              Text(
                                'No appointments today',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: controller.todayAppointments.length,
                        padding: const EdgeInsets.only(bottom: 20),
                        itemBuilder: (context, index) {
                          final appointment =
                              controller.todayAppointments[index];
                          return _buildAppointmentCard(appointment);
                        },
                      );
                    }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsSkeletonList() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: ShimmerEffect(
            child: SkeletonLoading(
                width: double.infinity, height: 80, borderRadius: 12),
          ),
        );
      },
    );
  }

  // --- KARTU APPOINTMENT VERSI BARU & LEBIH RAPI ---
  Widget _buildAppointmentCard(Appointment appointment) {
    // Ambil jam dari object 'time' jika ada, fallback ke string kosong
    String timeDisplay = appointment.time?.scheduleTime ?? '-';

    // Ambil nama pasien
    String patientName = appointment.user_name ?? 'Unknown Patient';
    String initial =
        patientName.isNotEmpty ? patientName[0].toUpperCase() : '?';

    return InkWell(
      onTap: () => _showActionDialog(appointment),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar / Icon Pasien
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initial,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(Get.context!).primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Detail Pasien (Tengah)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patientName,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.layers_outlined,
                          size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          appointment.poly_name ?? 'General',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Jam & Status (Kanan)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppointmentStatus.getStatusColor(appointment.status)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppointmentStatus.getStatusText(appointment.status),
                    style: GoogleFonts.poppins(
                      color:
                          AppointmentStatus.getStatusColor(appointment.status),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      timeDisplay,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showActionDialog(Appointment app) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Action for ${app.user_name}',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading:
                  const Icon(Icons.check_circle_outline, color: Colors.blue),
              title: Text('Approve Appointment', style: GoogleFonts.poppins()),
              onTap: () {
                controller.updateAppointmentStatus(app.id, 2);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined, color: Colors.red),
              title: Text('Reject Appointment', style: GoogleFonts.poppins()),
              onTap: () {
                controller.updateAppointmentStatus(app.id, 3);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services_outlined,
                  color: Colors.purple),
              title: Text('Start Diagnose', style: GoogleFonts.poppins()),
              onTap: () {
                controller.updateAppointmentStatus(app.id, 4);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, top: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFD4E8D1), // Sesuaikan dengan warna tema
          borderRadius: BorderRadius.circular(24),
        ),
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomBarItem(
                    Icons.home_rounded, controller.selectedIndex.value == 0, 0),
                _buildBottomBarItem(Icons.calendar_today_rounded,
                    controller.selectedIndex.value == 1, 1),
                _buildBottomBarItem(Icons.people_alt_rounded,
                    controller.selectedIndex.value == 2, 2),
                _buildBottomBarItem(Icons.person_rounded,
                    controller.selectedIndex.value == 3, 3),
              ],
            )),
      ),
    );
  }

  Widget _buildBottomBarItem(IconData icon, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => controller.selectedIndex.value = index,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.green[800] : Colors.grey[600],
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.green[800],
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
