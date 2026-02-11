// medical_history_view.dart

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
        automaticallyImplyLeading:
            false, // Hilangkan tombol back jika ini tab view
      ),
      body: Obx(
        () {
          if (controller.isLoadingMedicalRecords.value) {
            // Gunakan isLoadingMedicalRecords
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
    // Ambil data langsung dari RECORD (karena Model sudah diupdate dengan nested object)
    // Jangan ambil dari 'existingDoctor' controller karena itu cuma single object
    final doctor = record.doctor;
    final poly = record.poly;
    final scheduleDate = record.date;
    final scheduleTime = record.time;
    final clinic = record.clinic;

    String formattedDate = scheduleDate?.scheduleDate != null
        ? DateFormat('dd MMM yyyy')
            .format(DateTime.parse(scheduleDate!.scheduleDate!.toString()))
        : 'Unknown Date';

    // --- BUNGKUS DENGAN INKWELL ---
    return InkWell(
      onTap: () {
        controller.navigateToDetail(record); // Panggil fungsi navigasi
      },
      child: Container(
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
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        // Logic gambar bisa disederhanakan atau ambil dari record jika ada
                        'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg'),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${doctor?.degree ?? ''} ${doctor?.name ?? 'Unknown'}, ${doctor?.specialize ?? ''}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          clinic?.name ?? 'Unknown Clinic',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color:
                                Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          poly?.name ?? 'Unknown Poly',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color:
                                Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Icon More Vert tetap bisa diklik terpisah jika perlu
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios,
                        size: 16), // Ganti jadi panah biar user tau bisa diklik
                    onPressed: () {
                      controller.navigateToDetail(record);
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
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                      Text(
                        scheduleTime?.scheduleTime ?? 'Unknown Time',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: record.status == 7
                          ? Colors.green[50]
                          : const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      controller.getStatusText(record.status ?? 0),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: record.status == 7
                            ? Colors.green[700]
                            : Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
