import 'dart:io';

import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/widget/barcode_content.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/symptomAppointment/controllers/symptom_appointment_controller.dart';
import 'package:clinic_ai/models/appointment_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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

    try {
      // Check storage permission first
      final hasPermission = await _requestStoragePermission(context);
      if (!hasPermission) {
        return;
      }

      // Show loading indicator
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Generating PDF..."),
                ],
              ),
            );
          },
        );
      }

      final pdf = pw.Document();

      // Define colors
      final baseColor = PdfColor.fromHex('35693E');
      final lightColor = PdfColor.fromHex('70B67C');
      final textColor = PdfColors.white;

      // PDF Metadata
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4, // Ensure A4 format
          build: (pw.Context context) {
            return pw.Center(
              // Center content on the page
              child: pw.Container(
                width: PdfPageFormat.a4.width * 0.8, // 80% of page width
                decoration: pw.BoxDecoration(
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(10)),
                  gradient: pw.LinearGradient(
                    begin: pw.Alignment.topLeft,
                    end: pw.Alignment.bottomRight,
                    colors: [lightColor, baseColor],
                  ),
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(24),
                  child: pw.Column(
                    mainAxisAlignment: pw
                        .MainAxisAlignment.center, // Center content vertically
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        '${controller.currentAppointment.value?.qrCode ?? ''} - ${controller.userName.value}',
                        style: pw.TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 12),
                      pw.Text(
                        'Save this barcode and show it to the clinic staff',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          color: textColor,
                          fontSize: 16,
                        ),
                      ),
                      pw.SizedBox(height: 36),
                      pw.Container(
                        decoration: pw.BoxDecoration(
                          color: PdfColors.white,
                          borderRadius:
                              const pw.BorderRadius.all(pw.Radius.circular(8)),
                        ),
                        padding: const pw.EdgeInsets.all(16),
                        child: pw.BarcodeWidget(
                          data: controller.currentAppointment.value!.qrCode,
                          barcode: pw.Barcode.qrCode(),
                          width: 250, // Adjust QR code size
                          height: 250,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );

      // Generate unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'appointment_qr_$timestamp.pdf';

      // Get temporary directory and save PDF there first
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(await pdf.save());

      // Close loading indicator
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Let user pick the save location
      String? saveDir = await FilePicker.platform.getDirectoryPath();
      if (saveDir == null) {
        // User cancelled directory selection
        return;
      }

      // Copy file to selected directory
      final savedFile = File('$saveDir/$fileName');
      await tempFile.copy(savedFile.path);

      // Delete temporary file
      await tempFile.delete();

      // Show success message
      if (context.mounted) {
        print("ini -----------> ${savedFile.path}");
        print("ini -----------> ${savedFile.path.codeUnits}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF saved to: ${savedFile.path}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Close loading indicator if open
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
