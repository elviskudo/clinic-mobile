import 'package:clinic_ai/app/modules/(doctor)/list_patients/controllers/list_patients_controller.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreenController extends GetxController {
  late Appointment appointment;
  final appointmentController = Get.find<ListPatientsController>();
  final isProcessingResult = false.obs;
  final isUpdating = false.obs;
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

    String scannedText = rawValue.trim().toUpperCase();
    String expectedDb = (appointment.qrCode ?? '').trim().toUpperCase();
    String expectedId = appointment.id.length >= 8
        ? appointment.id.substring(0, 8).trim().toUpperCase()
        : appointment.id.trim().toUpperCase();

    if (scannedText == expectedId || scannedText == expectedDb) {
      scannerController.stop();
      showConfirmationDialog();
    } else {
      Get.snackbar(
        'QR Tidak Cocok!',
        'Kamera membaca: "$rawValue"',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      Future.delayed(const Duration(seconds: 3), () {
        isProcessingResult.value = false;
      });
    }
  }

  void showConfirmationDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Confirm Medicine Handover',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                      'Are you sure you want to complete the process for ${appointment.user_name}?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: isUpdating.value
                              ? null
                              : () {
                                  Get.back(); // Tutup Pop-Up saja
                                  isProcessingResult.value = false;
                                  scannerController.start(); // Lanjutkan Kamera
                                },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(
                                    color: isUpdating.value
                                        ? Colors.grey[100]!
                                        : Colors.grey[300]!)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('Cancel',
                              style: TextStyle(
                                  color: isUpdating.value
                                      ? Colors.grey[400]
                                      : Colors.grey[700],
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isUpdating.value
                              ? null
                              : () async {
                                  await processMedicineHandover();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3498DB),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: isUpdating.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Confirm',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> processMedicineHandover() async {
    try {
      isUpdating.value = true;

      // 1. UPDATE STATUS DI DATABASE JADI 8 (COMPLETED)
      await appointmentController.updateAppointmentStatus(appointment.id, 8);

      // 2. MATIKAN KAMERA SEBELUM PINDAH
      await scannerController.stop();
      scannerController.dispose();

      // 3. NAVIGASI LANGSUNG KE LIST PATIENTS (MENGHAPUS SEMUA DIALOG DAN LAYAR KAMERA)
      // Ini cara paling sakti untuk mencegah "stuck" dan menutup dialog sekaligus halamannya.
      Get.offNamedUntil(Routes.HOME_DOCTOR, (route) => false);

      // 4. MUNCULKAN NOTIFIKASI DARI HALAMAN BARU
      // Gunakan Future.delayed agar UI Home Doctor selesai me-render sebelum menembakkan snackbar.
      Future.delayed(const Duration(milliseconds: 800), () {
        Get.snackbar(
          'Berhasil',
          'Obat diserahkan. Layar pasien otomatis berpindah.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      });
    } catch (e) {
      Get.back(); // Tutup Pop-Up jika gagal
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      isProcessingResult.value = false;
      scannerController.start(); // Nyalakan kamera lagi jika gagal
    } finally {
      isUpdating.value = false;
    }
  }

  void toggleFlash() => scannerController.toggleTorch();

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}
