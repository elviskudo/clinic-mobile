import 'package:clinic_ai/app/modules/(doctor)/list_patients/controllers/list_patients_controller.dart';
import 'package:clinic_ai/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreenController extends GetxController {
  late Appointment appointment;
  final appointmentController = Get.find<ListPatientsController>();
  final isProcessingResult = false.obs;
  final scannerController = MobileScannerController();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Appointment) {
      appointment = Get.arguments;
    } else {
      Get.back();
    }
  }

  void onDetect(BarcodeCapture capture) {
    if (isProcessingResult.value) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    final String? rawValue = barcode.rawValue;

    if (rawValue == null) return;

    isProcessingResult.value = true;

    if (rawValue == appointment.qrCode) {
      // Stop scanner when valid QR code is detected
      scannerController.stop();

      // Navigate back to list_patients first
      Get.back();

      // Show confirmation dialog
      showConfirmationDialog();
    } else {
      Get.snackbar(
        'Error',
        'Invalid QR code. Please scan the correct QR code.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isProcessingResult.value = false;
    }
  }

  void showConfirmationDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Do you really want to approve\nthis patient?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Reject Button
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                        isProcessingResult.value = false;
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Reject',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Approve Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        await updateAppointmentStatus();
                        Get.snackbar(
                          'Success',
                          'Appointment status updated to Completed',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF1B5E20), // Dark green color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Yes, Approve',
                        style: TextStyle(
                          color: Colors.white,
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
      ),
      barrierDismissible: false,
    );
  }

  Future<void> updateAppointmentStatus() async {
    try {
      await appointmentController.updateAppointmentStatus(appointment.id, 2);
    } catch (error) {
      print('Error updating appointment status: $error');
      Get.snackbar(
        'Error',
        'Failed to update appointment status',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void toggleFlash() {
    scannerController.toggleTorch();
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}
