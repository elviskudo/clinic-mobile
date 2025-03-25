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
  final CaptureAppointmentController captureController =
      Get.find<CaptureAppointmentController>();

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
    final symptomController =
        Get.find<SymptomAppointmentController>(); // Get Symptom Controller

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Warning Box
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8.0),
                      Text(
                        'Take image of your face, teeth or eyes!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '• Take pictures using HD resolution',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  Text(
                    '• Make sure to point the camera at the problem area',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  Text(
                    '• The captured image must be clear and not blurry.',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Image Area
            Expanded(
              child: GestureDetector(
                onTap: _showImageSourceDialog,
                child: LayoutBuilder(
                  // Use LayoutBuilder
                  builder: (context, constraints) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      // Gunakan Obx untuk memantau selectedImage dari controller
                      child: Obx(() {
                        return captureController.selectedImage.value != null
                            ? Stack(
                                // Gunakan Stack untuk menumpuk widget
                                alignment:
                                    Alignment.topRight, // Posisi tombol cancel
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.file(
                                      captureController.selectedImage.value!,
                                      width: constraints.maxWidth, // Atur lebar
                                      height:
                                          constraints.maxHeight, // Atur tinggi
                                      fit:
                                          BoxFit.fill, // Set fit ke BoxFit.fill
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      // Gunakan InkWell untuk efek ripple
                                      onTap: () {
                                        // Reset gambar yang dipilih
                                        captureController
                                            .updateSelectedImage(null);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.7),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: Text(
                                  'Tap to Upload Image',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              );
                      }),
                    );
                  },
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
                            if (barcodeController.currentAppointment.value ==
                                    null ||
                                barcodeController
                                        .currentAppointment.value!.id ==
                                    null) {
                              Get.snackbar('Error',
                                  'Appointment not found. Please scan barcode first.');
                              return;
                            }
                            // Panggil fungsi upload dari controller
                            await captureController.uploadFileToCloudinary(
                                XFile(captureController
                                    .selectedImage.value!.path),
                                barcodeController
                                    .currentAppointment.value!.id!);

                            // Navigasi ke SummaryAppointmentView setelah upload selesai
                            Get.toNamed(
                              Routes
                                  .SUMMARY_APPOINTMENT, // Sesuaikan dengan rute yang benar
                              arguments: barcodeController.currentAppointment
                                  .value!.id!, // Kirimkan ID sebagai argumen
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      disabledBackgroundColor:
                          Theme.of(context).colorScheme.surfaceVariant,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: captureController.isLoading.value
                        ? CircularProgressIndicator(
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            strokeWidth: 4,
                          )
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
