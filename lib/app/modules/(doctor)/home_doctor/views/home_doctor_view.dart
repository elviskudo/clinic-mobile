import 'package:clinic_ai/app/modules/(doctor)/list_patients/views/list_patients_view.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/color/color.dart';
import 'package:clinic_ai/components/skeletonLoading.dart';
import 'package:clinic_ai/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_doctor_controller.dart';

class HomeDoctorView extends GetView<HomeDoctorController> {
  const HomeDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Obx(() => _buildBody()),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    // Use IndexedStack to keep all pages alive and just show the selected one
    return IndexedStack(
      index: controller.selectedIndex.value,
      children: [
        _buildHomePage(),
        const ListPatientsView(), // Schedule view
        const ListPatientsView(), // Patients view
        const ListPatientsView(), // Profile view - replace with actual profile view
      ],
    );
  }

  Widget _buildHomePage() {
    return StreamBuilder<List<Appointment>>(
      stream: controller.getAppointmentsStream(),
      builder: (context, snapshot) {
        final bool isLoading =
            snapshot.connectionState == ConnectionState.waiting;

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        return Column(
          children: [
            _buildHeader(isLoading),
            _buildStats(isLoading),
            _buildAppointmentsList(isLoading, snapshot.data),
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
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              isLoading
                  ? ShimmerEffect(
                      child: SkeletonLoading(
                        width: 150,
                        height: 30,
                        borderRadius: 4,
                      ),
                    )
                  : Obx(
                      () => Text(
                        'Dr. ${controller.currentUserName.value}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(bool isLoading) {
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: List.generate(
                3,
                (index) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index < 2 ? 15 : 0),
                    child: ShimmerEffect(
                      child: SkeletonLoading(
                        width: double.infinity,
                        height: 100,
                        borderRadius: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: List.generate(
                3,
                (index) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index < 2 ? 15 : 0),
                    child: ShimmerEffect(
                      child: SkeletonLoading(
                        width: double.infinity,
                        height: 100,
                        borderRadius: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
                      AppointmentStatus.getStatusColor(
                          AppointmentStatus.waiting),
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
                      AppointmentStatus.getStatusColor(
                          AppointmentStatus.approved),
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
                      AppointmentStatus.getStatusColor(
                          AppointmentStatus.diagnose),
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
                      AppointmentStatus.getStatusColor(
                          AppointmentStatus.unpaid),
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
                      AppointmentStatus.getStatusColor(
                          AppointmentStatus.waitingForDrugs),
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
                      AppointmentStatus.getStatusColor(
                          AppointmentStatus.completed),
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
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            spreadRadius: -2,
            blurRadius: 5,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(
      bool isLoading, List<Appointment>? appointments) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Appointments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? _buildAppointmentsSkeletonList()
                  : Obx(() => controller.todayAppointments.isEmpty
                      ? const Center(child: Text('No appointments today'))
                      : ListView.builder(
                          itemCount: controller.todayAppointments.length,
                          itemBuilder: (context, index) {
                            final appointment =
                                controller.todayAppointments[index];
                            return _buildAppointmentCard(appointment);
                          },
                        )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsSkeletonList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: ShimmerEffect(
            child: SkeletonLoading(
              width: double.infinity,
              height: 80,
              borderRadius: 12,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: appointment.status == 0 ? Colors.orange : Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.user_name ?? 'Unknown Patient',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  appointment.poly_name ?? 'Unknown Poly',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                appointment.createdAt.toString().substring(11, 16),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: appointment.status == 0
                      ? Colors.orange.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getStatusText(appointment.status),
                  style: TextStyle(
                    color: _getStatusColor(appointment.status),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Waiting';
      case 1:
        return 'Approved';
      case 2:
        return 'Diagnose';
      case 3:
        return 'Unpaid';
      case 4:
        return 'Waiting For Drugs';
      case 5:
        return 'Completed';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.purple;
      case 3:
        return Colors.red;
      case 4:
        return Colors.amber;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildBottomNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, top: 8),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFD4E8D1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomBarItem(Icons.home_outlined,
                    controller.selectedIndex.value == 0, 0),
                _buildBottomBarItem(Icons.calendar_today_outlined,
                    controller.selectedIndex.value == 1, 1),
                _buildBottomBarItem(Icons.people_outline,
                    controller.selectedIndex.value == 2, 2),
                _buildBottomBarItem(Icons.person_outline,
                    controller.selectedIndex.value == 3, 3),
              ],
            )),
      ),
    );
  }

  Widget _buildBottomBarItem(IconData icon, bool isSelected, int index) {
    return GestureDetector(
      onTap: () {
        controller.selectedIndex.value = index;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.green[700] : Colors.grey[700],
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.green[700],
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
