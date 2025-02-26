import 'package:clinic_ai/color/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_diagnose_controller.dart';

class DetailDiagnoseView extends GetView<DetailDiagnoseController> {
  const DetailDiagnoseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Appointment'),
        centerTitle: true,
      ),
      backgroundColor: bgColor,
      body: Obx(() {
        // Ambil data appointment dari controller
        final appointment = controller.appointment.value;

        // Jika appointment null, tampilkan indikator atau teks
        if (appointment == null) {
          return const Center(
            child: Text('No appointment data'),
          );
        }

        // Jika appointment tidak null, tampilkan detailnya
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian "Patient"
              const Text(
                'Patient',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Patient Name
              const Text(
                'Patient Name',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                appointment.user_name ?? '-', // <-- data dinamis
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Patient Code (bisa juga menampilkan QR Code)
              const Text(
                'Patient Code',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                appointment.qrCode, // <-- data dinamis
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Symptoms
              const Text(
                'Symptoms',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                appointment.symptoms ?? '-', // <-- data dinamis
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),

              // Symptom Descriptions
              const Text(
                'Symptom Descriptions',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                appointment.symptomDescription ?? '-', // <-- data dinamis
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),

              // Image Captured (Contoh statis, ganti URL sesuai data yang diambil)
              const Text(
                'Image Captured',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(8),
              //   child: Image.network(
              //     // Ganti dengan URL gambar dari server, jika tersedia
              //     'https://via.placeholder.com/400x200?text=Captured+Image',
              //     fit: BoxFit.cover,
              //     height: 180,
              //     width: double.infinity,
              //   ),
              // ),
              const SizedBox(height: 24),

              // Doctor Analyst
              const Text(
                'Doctor Analyst',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.doctorAnalystController,
                decoration: InputDecoration(
                  hintText: 'Ask here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Submit AI Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    controller.submitAI();
                  },
                  child: const Text('Submit AI'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
