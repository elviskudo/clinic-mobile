import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../controllers/summary_appointment_controller.dart';

class SummaryAppointmentView extends StatefulWidget {
  const SummaryAppointmentView({Key? key}) : super(key: key);

  @override
  State<SummaryAppointmentView> createState() => _SummaryAppointmentViewState();
}

class _SummaryAppointmentViewState extends State<SummaryAppointmentView> {
  final SummaryAppointmentController controller = Get.put(SummaryAppointmentController());
  String? appointmentId;

  @override
  void initState() {
    super.initState();
    appointmentId = Get.arguments as String?; // Dapatkan ID dari arguments
    if (appointmentId != null) {
      controller.fetchAppointmentAndDoctor(appointmentId!); // Panggil fetch dengan ID yang benar
    } else {
      controller.errorMessage.value = 'Appointment ID tidak tersedia.'; // Atur pesan error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF2),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text('Error: ${controller.errorMessage.value}'));
          } else if (controller.appointment.value == null ||
              controller.doctor.value == null) {
            return const Center(child: Text('Data tidak ditemukan.'));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildAppBar(context),
                    const SizedBox(height: 24),
                    _buildDoctorInfo(),
                    const SizedBox(height: 16),
                    _buildAppointmentDetails(),
                    const SizedBox(height: 24),
                    _buildPatientCode(context),
                    const SizedBox(height: 24),
                    _buildPatientInfo(),
                    const SizedBox(height: 24),
                    _buildSymptoms(),
                    const SizedBox(height: 24),
                    _buildSymptomDescriptions(),
                    const SizedBox(height: 40),
                    _buildWaitingForResultsButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
        Text(
          'Appointment',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorInfo() {
    return Center(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              "https://plus.unsplash.com/premium_photo-1736165168647-e216dcd23720?q=80&w=1925&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", // Ubah URL gambar di sini
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Doctor ${controller.doctor.value?.degree}" ?? 'Nama Dokter',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
              controller.poly.value!.name.toString() ?? "Unknown Poly",
             // Ubah ke data yang sesuai jika ada
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildAppointmentDetails() {
  final formattedDate = controller.scheduleDate.value != null
      ? DateFormat('dd/MM/yyyy').format(controller.scheduleDate.value!.scheduleDate)
      : 'Tanggal Tidak Tersedia';
  final time = controller.scheduleTime.value?.scheduleTime ?? 'Waktu Tidak Tersedia';

  return Center(
    child: Text(
      '$time | $formattedDate',
      style: GoogleFonts.inter(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
  Widget _buildPatientCode(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 350; // Ukuran layar kecil
    final maxTextWidth = screenWidth * 0.4; // Lebar maksimum teks 40% dari lebar layar
    final fontSize = isSmallScreen ? 13.0 : 15.0; // Ukuran font responsif
    final paddingVertical = isSmallScreen ? 8.0 : 16.0; // Padding Vertical
    final paddingHorizontal = isSmallScreen ? 12.0 : 26.0; // Padding Horizontal

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      InkWell(
        onTap: () {
          // Tampilkan informasi ketika Container ditekan
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Appointment Details"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kode QR: ${controller.appointment.value?.qrCode ?? "Tidak Ada"}'),
                    Text('Nama: ${controller.userName.value}'),
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxTextWidth),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Text(
              '${controller.appointment.value?.qrCode}-${controller.userName.value}',
              style: GoogleFonts.inter(
                fontSize: fontSize, // Ukuran font responsif
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ),
       const SizedBox(width: 12),
       InkWell(
           onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Captured Image"),
                  content: SingleChildScrollView(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                       if (controller.imageUrl.value.isNotEmpty) {
                        return Image.network(
                          controller.imageUrl.value,
                          fit: BoxFit.contain,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            // Tampilkan pesan error jika gambar gagal dimuat
                            return const Text('Failed to load image');
                          },
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                         if (loadingProgress == null) {
                             return child;
                             }
                        return Center(
                           child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                             ? loadingProgress.cumulativeBytesLoaded /
                                 loadingProgress.expectedTotalBytes!
                              : null,
                           ),
                         );
                      }
                        );
                      } else {
                        return const Text('No image captured.');
                      }
                    }),
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
            decoration: BoxDecoration(
              color: const Color(0xFFD4E8D1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.green.shade300,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Image Captured',
                  style: GoogleFonts.inter(
                    fontSize: fontSize - 1, // Ukuran font responsif
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.check,
                  color: Colors.green[700],
                  size: fontSize + 1, // Ukuran icon responsif
                ),
              ],
            ),
          ),
       ),
      ],
    );
  }

  Widget _buildPatientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Patient Name',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${controller.userName.value}', // Ubah ke data dari appointment
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

 Widget _buildSymptoms() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Symptoms',
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      if (controller.symptoms.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: controller.symptoms.map((symptom) => Text(
            "${symptom.enName}, ", // Ganti enName dengan kolom yang ingin ditampilkan
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.black87,
            ),
          )).toList(),
        )
      else
        Text(
          'Tidak ada gejala',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
    ],
  );
}

  Widget _buildSymptomDescriptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Symptom Descriptions',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          controller.appointment.value?.symptomDescription ?? 'Tidak ada deskripsi', // Ubah ke data dari appointment
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildWaitingForResultsButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          'Waiting for the result ...',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}