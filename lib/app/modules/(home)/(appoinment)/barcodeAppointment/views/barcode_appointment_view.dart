import 'dart:io';

import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/widget/barcode_content.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/symptomAppointment/controllers/symptom_appointment_controller.dart';
import 'package:clinic_ai/models/appointment_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/barcode_appointment_controller.dart';

class BarcodeAppointmentView extends GetView<BarcodeAppointmentController> {
  const BarcodeAppointmentView({Key? key}) : super(key: key);

  Future<bool> _requestStoragePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      // Check Android version
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final androidVersion = androidInfo.version.sdkInt;

      if (androidVersion >= 33) {
        // Android 13 and above
        final photos = await Permission.photos.status;
        if (photos.isDenied) {
          final result = await Permission.photos.request();
          if (result.isDenied) {
            _showPermissionDialog(context);
            return false;
          }
        }
        return true;
      } else if (androidVersion >= 30) {
        // Android 11 and 12
        if (!await Permission.manageExternalStorage.isGranted) {
          final result = await Permission.manageExternalStorage.request();
          if (result.isDenied) {
            _showPermissionDialog(context);
            return false;
          }
        }
        return true;
      } else {
        // Android 10 and below
        final storage = await Permission.storage.status;
        if (storage.isDenied) {
          final result = await Permission.storage.request();
          if (result.isDenied) {
            _showPermissionDialog(context);
            return false;
          }
        }
        return true;
      }
    }
    return true; // For iOS or other platforms
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Storage Permission Required'),
        content: const Text(
          'This app needs storage access to save PDF files. Please grant storage permission in app settings.',
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _generatePDF(BuildContext context) async {
    final controller = Get.find<BarcodeAppointmentController>();
    final appointment = controller.currentAppointment.value;

    if (appointment == null) {
      Get.snackbar('Error', 'Data appointment tidak ditemukan');
      return;
    }

    try {
      // 1. Cek Permission
      final hasPermission = await _requestStoragePermission(context);
      if (!hasPermission) return;

      if (context.mounted) _showLoadingDialog(context);

      // 2. Persiapkan Data
      // Ambil data dari nested object appointment (menggunakan fallback ke string kosong jika null)
      final doctorName = appointment.doctor?.name ?? '-';
      final clinicName = appointment.clinic?.name ?? '-';
      final polyName = appointment.poly?.name ?? '-';

      // Format Tanggal yang Cantik
      String dateString = '-';
      if (appointment.date?.scheduleDate != null) {
        dateString = DateFormat('EEEE, d MMMM yyyy')
            .format(appointment.date!.scheduleDate!);
      } else if (appointment.updatedAt != null) {
        // Fallback ke updated_at jika scheduleDate kosong
        dateString =
            DateFormat('EEEE, d MMMM yyyy').format(appointment.updatedAt);
      }

      final timeString = appointment.time?.scheduleTime ?? '-';
      final patientName = controller.userName.value;
      final qrCode = appointment.qrCode;

      // 3. Buat Dokumen PDF
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Header(
                  level: 0,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('TIKET JANJI TEMU',
                          style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.green800)),
                      pw.Text('Clinic AI',
                          style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey600)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Kotak Utama Tiket
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400),
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(10)),
                  ),
                  padding: const pw.EdgeInsets.all(20),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Sisi Kiri: Informasi Teks
                      pw.Expanded(
                        flex: 2,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildPdfRow('Nama Pasien', patientName,
                                isBold: true),
                            pw.Divider(color: PdfColors.grey300),
                            _buildPdfRow('Klinik', clinicName),
                            pw.SizedBox(height: 8),
                            _buildPdfRow('Poli', polyName),
                            pw.SizedBox(height: 8),
                            _buildPdfRow('Dokter', doctorName),
                            pw.Divider(color: PdfColors.grey300),
                            _buildPdfRow('Tanggal', dateString),
                            pw.SizedBox(height: 8),
                            _buildPdfRow('Jam', timeString),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 20),

                      // Sisi Kanan: QR Code
                      pw.Expanded(
                        flex: 1,
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Container(
                              height: 120,
                              width: 120,
                              child: pw.BarcodeWidget(
                                data: qrCode,
                                barcode: pw.Barcode.qrCode(),
                              ),
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(qrCode,
                                style: const pw.TextStyle(
                                    fontSize: 10, color: PdfColors.grey600)),
                            pw.SizedBox(height: 4),
                            pw.Text('Tunjukkan di Admin',
                                style: const pw.TextStyle(
                                    fontSize: 10, color: PdfColors.green800)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 20),
                // Footer Notes
                pw.Text(
                  '* Harap datang 15 menit sebelum jadwal konsultasi.',
                  style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                      fontStyle: pw.FontStyle.italic),
                ),
                pw.Text(
                  '* Tunjukkan QR Code ini kepada staf administrasi klinik untuk check-in.',
                  style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                      fontStyle: pw.FontStyle.italic),
                ),
              ],
            );
          },
        ),
      );

      // 4. Simpan File
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'Tiket_ClinicAI_$timestamp.pdf';

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final String filePath = '${directory!.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      if (context.mounted) Navigator.of(context).pop(); // Tutup Loading

      Get.snackbar(
        'Berhasil',
        'Tiket disimpan di folder Download:\n$fileName',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      print("PDF Error: $e");
      Get.snackbar('Error', 'Gagal membuat PDF: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Helper Widget untuk Baris di dalam PDF agar rapi
  pw.Widget _buildPdfRow(String label, String value, {bool isBold = false}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: PdfColors.black,
          ),
        ),
      ],
    );
  }

// Fungsi pembantu untuk Loading
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StreamBuilder<List<Appointment>>(
        stream: controller.getAppointmentsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No appointment data found'));
          }

          final appointment = snapshot.data!.first;

          // Initialize SymptomAppointmentController HERE
          final symptomController = Get.put(SymptomAppointmentController());
          WidgetsBinding.instance.addPostFrameCallback((_) {
            symptomController.fetchSymptoms();
          });

          return BarcodeContent(
            appointment: appointment,
            onDownloadQrCode: () => _generatePDF(context),
          ); // Passing the PDF generation function
        },
      ),
    );
  }
}
