import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/captureAppointment/controllers/capture_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';

class CaptureAppointmentView extends StatefulWidget {
  const CaptureAppointmentView({Key? key}) : super(key: key);

  @override
  State<CaptureAppointmentView> createState() => _CaptureAppointmentViewState();
}

class _CaptureAppointmentViewState extends State<CaptureAppointmentView> {
  File? _selectedImage;
  final CaptureAppointmentController captureController = Get.put(CaptureAppointmentController());

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
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
                  child: _selectedImage != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Center(
                    child: Text(
                      'Tap to Upload Image',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Next Button
            Obx(() => SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _selectedImage != null
                    ? () async {
                  // Pastikan appointment tersedia
                  if (barcodeController.currentAppointment.value == null ||
                      barcodeController.currentAppointment.value!.id == null) {
                    Get.snackbar('Error', 'Appointment not found. Please scan barcode first.');
                    return;
                  }
                  // Panggil fungsi upload dari controller
                  await captureController.uploadFileToCloudinary(
                      XFile(_selectedImage!.path),
                      barcodeController.currentAppointment.value!.id!);
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
                    ? const CircularProgressIndicator() // Tampilkan loading indicator
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