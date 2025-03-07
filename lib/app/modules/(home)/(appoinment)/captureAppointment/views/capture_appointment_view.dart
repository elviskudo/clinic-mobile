import 'dart:io';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/symptomAppointment/controllers/symptom_appointment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/captureAppointment/controllers/capture_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';
import 'package:clinic_ai/app/routes/app_pages.dart'; // Pastikan path ini benar

class CaptureAppointmentView extends StatefulWidget {
  const CaptureAppointmentView({Key? key}) : super(key: key);

  @override
  State<CaptureAppointmentView> createState() => _CaptureAppointmentViewState();
}

class _CaptureAppointmentViewState extends State<CaptureAppointmentView> {
  //File? _selectedImage;
  final CaptureAppointmentController captureController = Get.find<CaptureAppointmentController>();

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      // Perbarui gambar di controller
      captureController.updateSelectedImage(File(image.path));
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Image Source"),
          actions: [
            TextButton(
              child: const Text("Gallery"),
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            TextButton(
              child: const Text("Camera"),
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final barcodeController = Get.find<BarcodeAppointmentController>();
    final symptomController = Get.find<SymptomAppointmentController>(); // Get Symptom Controller

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF2),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Warning Box
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFD1F0EA),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF35693E)),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Take image of your face, teeth or eyes!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF35693E)),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    '• Take pictures using HD resolution',
                    style: TextStyle(color: Color(0xFF35693E)),
                  ),
                  const Text(
                    '• Make sure to point the camera at the problem area',
                    style: TextStyle(color: Color(0xFF35693E)),
                  ),
                  const Text(
                    '• The captured image must be clear and not blurry.',
                    style: TextStyle(color: Color(0xFF35693E)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Image Area
            Expanded(
              child: GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  // Gunakan Obx untuk memantau selectedImage dari controller
                  child: Obx(() {
                    return captureController.selectedImage.value != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.file(
                        captureController.selectedImage.value!,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Center(
                      child: Text(
                        'Tap to Upload Image',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Next Button
            Obx(() => SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: captureController.selectedImage.value != null
                    ? () async {
                  // Pastikan appointment tersedia
                  if (barcodeController.currentAppointment.value == null ||
                      barcodeController.currentAppointment.value!.id == null) {
                    Get.snackbar('Error', 'Appointment not found. Please scan barcode first.');
                    return;
                  }
                  // Panggil fungsi upload dari controller
                  await captureController.uploadFileToCloudinary(
                      XFile(captureController.selectedImage.value!.path),
                      barcodeController.currentAppointment.value!.id!);

                  // Navigasi ke SummaryAppointmentView setelah upload selesai
                  Get.toNamed(
                    Routes.SUMMARY_APPOINTMENT, // Sesuaikan dengan rute yang benar
                    arguments: barcodeController.currentAppointment.value!.id!, // Kirimkan ID sebagai argumen
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF35693E),
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: captureController.isLoading.value
                    ? const CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 4,
                  ) // Tampilkan loading indicator
                    : const Text(
                  'Next',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}