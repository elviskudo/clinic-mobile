import 'package:clinic_ai/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/medical_history_controller.dart';

class MedicalHistoryView extends GetView<MedicalHistoryController> {
  const MedicalHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Medical Record',
          style: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.medicalRecords.isEmpty) {
            return Center(
              child: Text(
                'No medical records found.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: controller.medicalRecords.length,
              itemBuilder: (context, index) {
                final record = controller.medicalRecords[index];
                return _buildMedicalRecordCard(record, context);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildMedicalRecordCard(Appointment record, BuildContext context) {
    final doctor = controller.existingDoctor.value;
    final poly = controller.existingPoly.value;
    final scheduleDate = controller.existingScheduleDate.value;
    final scheduleTime = controller.existingScheduleTime.value;
    final clinic = controller.existingClinic.value;
    String formattedDate = scheduleDate?.scheduleDate != null
        ? DateFormat('dd MMM yyyy')
            .format(DateTime.parse(scheduleDate!.scheduleDate!.toString()))
        : 'Unknown Date';

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Obx(() => CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(controller
                              .doctorProfilePictureUrl.value.isNotEmpty
                          ? controller.doctorProfilePictureUrl.value
                          : 'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg'),
                    )),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${doctor?.degree ?? ''} ${doctor?.name ?? ''}, ${doctor?.specialize ?? ''}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(Get.context!)
                              .textTheme
                              .titleLarge
                              ?.color,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        clinic?.name ?? 'Unknown Clinic',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Theme.of(Get.context!)
                              .textTheme
                              .titleLarge
                              ?.color,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        poly?.name ?? 'Unknown Poly',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Theme.of(Get.context!)
                              .textTheme
                              .titleLarge
                              ?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () {
                    // Tambahkan aksi yang diinginkan di sini
                  },
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color:
                            Theme.of(Get.context!).textTheme.titleLarge?.color,
                      ),
                    ),
                    Text(
                      scheduleTime?.scheduleTime ?? 'Unknown Time',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color:
                            Theme.of(Get.context!).textTheme.titleLarge?.color,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.getStatusText(record.status ?? 0),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
