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

      updateAppointmentStatus();
      Get.snackbar(
        'Success',
        'Appointment status updated to Completed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back();
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

  Future<void> updateAppointmentStatus() async {
    try {
      await appointmentController.updateAppointmentStatus(appointment.id, 1);
    } catch (error) {
      print('Error updating appointment status: $error');
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
