import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
    appointmentId = Get.arguments as String?; // Get ID from arguments
    if (appointmentId != null) {
      controller.fetchAppointmentAndDoctor(appointmentId!); // Call fetch with the correct ID
    } else {
      controller.errorMessage.value = 'Appointment ID tidak tersedia.'; // Set error message
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF2),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.value.isNotEmpty) {
            return Center(child: Text('Error: ${controller.errorMessage.value}'));
          } else if (controller.appointment.value == null || controller.doctor.value == null) {
            return const Center(child: Text('Data tidak ditemukan.'));
          } else {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildAppBar(context),
                        const SizedBox(height: 24),
                        _buildDoctorInfo(screenWidth, screenHeight),
                        const SizedBox(height: 16),
                        _buildAppointmentDetails(),
                        const SizedBox(height: 24),
                        _buildQRCodeSection(), // New QR Code section
                        const SizedBox(height: 24),
                        _buildPatientInfo(),
                        const SizedBox(height: 24),
                        _buildSymptoms(),
                        const SizedBox(height: 24),
                        _buildSymptomDescriptions(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                _buildResultButton(context), // Button outside SingleChildScrollView
                const SizedBox(height: 20),
              ],
            );
          }
        }),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
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

  Widget _buildDoctorInfo(double screenWidth, double screenHeight) {
    try {
      if (controller.doctor.value == null) {
        return const Center(
          child: Text('Data dokter tidak tersedia.'),
        );
      }

      final doctorName = controller.doctor.value!.name ?? 'Unknown';
      final doctorDegree = controller.doctor.value!.degree ?? 'Unknown';
      final doctorSpecialize = controller.doctor.value!.specialize ?? 'Unknown';

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Doctor Profile Picture - without QR code here
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Obx(() => controller.doctorProfilePictureUrl.value.isNotEmpty
                    ? Image.network(
                        controller.doctorProfilePictureUrl.value,
                        width: screenWidth * 0.35,
                        height: screenWidth * 0.35,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                      )
                    : Image.network(
                        "https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg",
                        width: screenWidth * 0.35,
                        height: screenWidth * 0.35,
                        fit: BoxFit.cover,
                      ),
                ),
              ),
            ),

            // Doctor Information
            const SizedBox(height: 16),
            Text(
              "$doctorDegree $doctorName, $doctorSpecialize",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              controller.poly.value?.name.toString() ?? 'Unknown Poly',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return Center(child: Text('Error in _buildDoctorInfo: ${e.toString()}'));
    }
  }

  Widget _buildAppointmentDetails() {
    try {
      final formattedDate = controller.scheduleDate.value != null
          ? DateFormat('dd/MM/yyyy').format(controller.scheduleDate.value!.scheduleDate)
          : 'Tanggal Tidak Tersedia';
      final time =
          controller.scheduleTime.value?.scheduleTime ?? 'Waktu Tidak Tersedia';

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
    } catch (e) {
      return Center(child: Text('Error in _buildAppointmentDetails: ${e.toString()}'));
    }
  }

  // New QR Code section
  Widget _buildQRCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appointment QR Code',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                // QR Code
                Obx(() => QrImageView(
                      data: controller.appointment.value?.qrCode ?? 'No QR Code',
                      version: QrVersions.auto,
                      size: MediaQuery.of(context).size.width * 0.7,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(10),
                    )),
                const SizedBox(height: 16),
                // Patient Code
                Text(
                  'Patient Code',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.appointment.value?.qrCode ?? 'Not Available',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                // Divider
                Divider(color: Colors.grey[300]),
                const SizedBox(height: 8),
                // Image Captured button
                GestureDetector(
                  onTap: () => _showImageDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4E8D1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.image, size: 18, color: Colors.green[700]),
                        const SizedBox(width: 8),
                        Text(
                          'View Captured Image',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Improved Alert Dialog for Appointment Details
  void _showAppointmentDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4E8D1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.article_rounded,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Appointment Details",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // QR Code section
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FBF2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.qr_code, color: Colors.black54),
                          const SizedBox(width: 10),
                          Text(
                            'Kode QR',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${controller.appointment.value?.qrCode ?? "Tidak Ada"}',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Patient name section
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FBF2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.black54),
                          const SizedBox(width: 10),
                          Text(
                            'Nama Pasien',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              controller.userName.value,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Close",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Improved Alert Dialog for Captured Image
  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4E8D1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.image,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Captured Image",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Image container with rounded corners
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FBF2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF4CAF50)),
                            ),
                          ),
                        );
                      }
                      if (controller.imageUrl.value.isNotEmpty) {
                        return Image.network(
                          controller.imageUrl.value,
                          fit: BoxFit.contain,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Container(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.broken_image,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Failed to load image',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF4CAF50)),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.no_photography,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No image captured',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                  ),
                ),
                const SizedBox(height: 24),

                // Button row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF4CAF50)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Close",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Add download functionality here if needed
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Image saved to gallery'),
                              backgroundColor: Color(0xFF4CAF50),
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Save",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
          controller.userName.value,
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
            children: controller.symptoms
                .map((symptom) => Text(
                      "${symptom.enName}, ",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ))
                .toList(),
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
          controller.appointment.value?.symptomDescription ??
              'Tidak ada deskripsi',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildResultButton(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: controller.supabase
          .from('appointments')
          .stream(primaryKey: ['id'])
          .eq('id', appointmentId ?? '')
          .execute(),
      builder: (context, snapshot) {
        // Show loading indicator while connection is being established
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error if any
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Process data when available
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final appointmentData = snapshot.data!.first;
          final status = appointmentData['status'] as int?;

          // Check if status has changed to 5
          final isCompleted = status == 5;

          // If status changed to completed and wasn't before, show snackbar
          if (isCompleted && !controller.isAppointmentCompleted.value) {
            // Update controller value
            controller.isAppointmentCompleted.value = true;
            controller.buttonText.value = 'Next';

            // Show snackbar (delayed to avoid build errors)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Your consultation has been completed!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 5),
                  action: SnackBarAction(
                    label: 'VIEW',
                    textColor: Colors.white,
                    onPressed: () {
                      controller.handleResultButtonPressed();
                    },
                  ),
                ),
              );
            });
          }

          // Update button color based on completion status
          Color buttonColor = isCompleted
              ? const Color(0xFF35693E) // Green if completed
              : Colors.grey.shade200; // Grey if not

          return GestureDetector(
            onTap: () {
              if (isCompleted) {
                Get.toNamed(Routes.REDEEM_MEDICINE, arguments: appointmentId); // Send appointmentId
              } else {
                controller.handleResultButtonPressed(); // Do other action if not completed
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  isCompleted ? 'Next' : 'Waiting for the result ...',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: isCompleted ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }

        // Fallback if no data is available
        return _buildWaitingForResultsButton();
      },
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
          controller.buttonText.value,
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