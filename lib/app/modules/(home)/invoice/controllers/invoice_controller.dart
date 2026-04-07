import 'dart:io';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/models/appointment_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:clinic_ai/models/symptom_model.dart';
import 'package:clinic_ai/models/scheduleDate_model.dart';
import 'package:clinic_ai/models/scheduleTime_model.dart';
import 'package:clinic_ai/models/fee_model.dart';
import 'package:clinic_ai/models/drug_model.dart';
import 'package:clinic_ai/models/clinic_model.dart';
import 'package:clinic_ai/models/poly_model.dart';
import 'package:clinic_ai/models/doctor_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class InvoiceController extends GetxController {
  final supabase = Supabase.instance.client;

  final isLoading = false.obs;
  final appointment = Rxn<Appointment>();
  final errorMessage = Rxn<String>();
  final symptoms = <Symptom>[].obs;
  final scheduleDate = Rxn<ScheduleDate>();
  final scheduleTime = Rxn<ScheduleTime>();

  final medicines = <Map<String, dynamic>>[].obs;
  final fees = <Map<String, dynamic>>[].obs;

  final productSubtotal = '0'.obs;
  final total = '0'.obs;

  final clinic = Rxn<Clinic>();
  final poly = Rxn<Poly>();
  final doctor = Rxn<Doctor>();
  final patientName = ''.obs;

  String appointmentId = '';
  String redirectUrl = '';
  String bankName = '';
  String transactionCode = '';

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args != null && args is Map) {
      appointmentId = args['appointmentId'] ?? '';
      redirectUrl = args['redirectUrl'] ?? '';
      bankName = args['bankName'] ?? '';

      String shortId = appointmentId.length > 4
          ? appointmentId.substring(0, 4).toUpperCase()
          : "0001";
      transactionCode = "CMV$shortId";

      getPatientName();
      getAppointmentData(appointmentId);
    }
  }

  Future<void> getPatientName() async {
    final prefs = await SharedPreferences.getInstance();
    patientName.value = prefs.getString('name') ?? 'Tidak ada nama';
  }

  Future<void> getAppointmentData(String appointmentId) async {
    isLoading.value = true;
    errorMessage.value = null;
    symptoms.clear();
    scheduleDate.value = null;
    scheduleTime.value = null;
    medicines.clear();
    fees.clear();

    try {
      final appointmentResponse = await supabase
          .from('appointments')
          .select()
          .eq('id', appointmentId)
          .single();
      appointment.value = Appointment.fromJson(appointmentResponse);

      final symptomsString = appointment.value?.symptoms;
      if (symptomsString != null && symptomsString.isNotEmpty) {
        final symptomIds = symptomsString.split(',');
        final symptomsResponse =
            await supabase.from('symptoms').select().inFilter('id', symptomIds);
        if (symptomsResponse != null) {
          symptoms.assignAll(
              symptomsResponse.map((json) => Symptom.fromJson(json)).toList());
        }
      }

      final scheduleDateResponse = await supabase
          .from('schedule_dates')
          .select()
          .eq('id', appointment.value!.dateId)
          .maybeSingle();
      if (scheduleDateResponse != null) {
        scheduleDate.value = ScheduleDate.fromJson(scheduleDateResponse);
      }

      final scheduleTimeResponse = await supabase
          .from('schedule_times')
          .select()
          .eq('id', appointment.value!.timeId)
          .maybeSingle();
      if (scheduleTimeResponse != null) {
        scheduleTime.value = ScheduleTime.fromJson(scheduleTimeResponse);
      }

      await fetchDrugsAndFees(appointmentId);
    } catch (e) {
      errorMessage.value = 'Error fetching appointment: ${e.toString()}';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDataTambahan(String appointmentId) async {
    try {
      isLoading(true);
      final appointmentResponse = await supabase
          .from('appointments')
          .select()
          .eq('id', appointmentId)
          .single();
      appointment.value = Appointment.fromJson(appointmentResponse);

      final clinicResponse = await supabase
          .from('clinics')
          .select()
          .eq('id', appointment.value!.clinicId)
          .single();
      clinic.value = Clinic.fromJson(clinicResponse);

      final polyResponse = await supabase
          .from('polies')
          .select()
          .eq('id', appointment.value!.polyId)
          .single();
      poly.value = Poly.fromJson(polyResponse);

      final doctorResponse = await supabase
          .from('doctors')
          .select()
          .eq('id', appointment.value!.doctorId)
          .single();
      doctor.value = Doctor.fromJson(doctorResponse);
    } catch (e) {
      print('Error fetching additional data: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchDrugsAndFees(String appointmentId) async {
    try {
      final appDrugs = await supabase
          .from('appointment_drugs')
          .select('qty, price, drugs(*)')
          .eq('appointment_id', appointmentId);

      List<Map<String, dynamic>> tempDrugs = [];
      double subtotal = 0;

      if (appDrugs != null) {
        for (var item in appDrugs) {
          var drugData = item['drugs'];
          if (drugData != null) {
            double price = double.tryParse(item['price']?.toString() ??
                    drugData['sell_price']?.toString() ??
                    '0') ??
                0;
            int qty = int.tryParse(item['qty']?.toString() ?? '1') ?? 1;

            tempDrugs.add({
              'name': drugData['name'] ?? 'Unknown Drug',
              'price': price,
              'qty': qty,
            });

            subtotal += (price * qty);
          }
        }
      }
      medicines.value = tempDrugs;
      productSubtotal.value = subtotal.toStringAsFixed(0);

      final appFees = await supabase
          .from('appointment_fees')
          .select('price, fees(*)')
          .eq('appointment_id', appointmentId);

      List<Map<String, dynamic>> tempFees = [];
      double totalFees = 0;

      if (appFees != null) {
        for (var item in appFees) {
          var feeData = item['fees'];
          if (feeData != null) {
            double price = double.tryParse(item['price']?.toString() ??
                    feeData['price']?.toString() ??
                    '0') ??
                0;

            tempFees.add({
              'procedure': feeData['procedure'] ?? 'Unknown Fee',
              'price': price,
            });

            totalFees += price;
          }
        }
      }
      fees.value = tempFees;

      double finalTotal = subtotal + totalFees + 150000 + 30000;
      total.value = finalTotal.toStringAsFixed(0);
    } catch (error) {
      print('Error fetching drugs/fees: $error');
    }
  }

  void clearDataTambahan() {
    clinic.value = null;
    poly.value = null;
    doctor.value = null;
    patientName.value = '';
  }

  // =========================================================
  // FUNGSI DOWNLOAD & SHARE PDF (SESUAI DESAIN BARU)
  // =========================================================
  Future<bool> _requestStoragePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final androidVersion = androidInfo.version.sdkInt;

      if (androidVersion >= 33) {
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
        if (!await Permission.manageExternalStorage.isGranted) {
          final result = await Permission.manageExternalStorage.request();
          if (result.isDenied) {
            _showPermissionDialog(context);
            return false;
          }
        }
        return true;
      } else {
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
    return true;
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

  Future<void> downloadInvoicePDF(String appointmentId,
      {bool share = false}) async {
    final context = Get.context!;

    try {
      final hasPermission = await _requestStoragePermission(context);
      if (!hasPermission) return;

      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xff35693E)),
                  SizedBox(height: 10),
                  Text("Generating PDF..."),
                ],
              ),
            );
          },
        );
      }

      await fetchDataTambahan(appointmentId);

      final pdf = pw.Document();
      final currencyFormatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp',
        decimalDigits: 0,
      );
      final dateFormatter = DateFormat('dd MMMM yyyy');

      // WARNA UNTUK PDF
      final textDark = PdfColor.fromHex('#111111');
      final textLight = PdfColor.fromHex('#444444');
      final primaryGreen = PdfColor.fromHex('#35693E');
      final boxBg = PdfColor.fromHex('#F7FBF2');
      final cardBg = PdfColor.fromHex('#DCEBD8');

      // Helper Widget untuk Field
      pw.Widget buildField(String title, String value) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(title,
                  style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: textDark)),
              pw.SizedBox(height: 4),
              pw.Text(value,
                  style: pw.TextStyle(fontSize: 12, color: textLight)),
            ],
          ),
        );
      }

      // Helper Widget untuk Summary
      pw.Widget buildSummaryRow(String label, String value) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(label,
                  style: pw.TextStyle(fontSize: 12, color: textLight)),
              pw.Text(value,
                  style: pw.TextStyle(fontSize: 12, color: textLight)),
            ],
          ),
        );
      }

      pdf.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            buildBackground: (context) => pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(
                  color: PdfColor.fromHex('#EFEFEF')), // Background abu-abu
            ),
            margin: const pw.EdgeInsets.all(32),
          ),
          build: (pw.Context context) {
            return [
              // 1. HEADER (Info & QR Code)
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        buildField('Clinic Name', clinic.value?.name ?? "N/A"),
                        buildField('Poly Name', poly.value?.name ?? "N/A"),
                        buildField('Doctor Name', doctor.value?.name ?? "N/A"),
                        buildField(
                            'Tanggal Berobat',
                            (scheduleDate.value != null &&
                                    scheduleTime.value != null)
                                ? '${dateFormatter.format(scheduleDate.value!.scheduleDate.toLocal())} ${scheduleTime.value!.scheduleTime}'
                                : 'N/A'),
                        buildField('Patient Name', patientName.value),
                        buildField('Symptoms',
                            symptoms.map((s) => s.idName).join(', ')),
                        buildField('Symptom Descriptions',
                            appointment.value?.symptomDescription ?? "N/A"),
                      ],
                    ),
                  ),
                  pw.Container(
                    width: 70,
                    height: 70,
                    child: pw.BarcodeWidget(
                      data: appointment.value?.qrCode ?? 'N/A',
                      barcode: pw.Barcode.qrCode(),
                      color: PdfColors.black,
                    ),
                  ),
                ],
              ),

              // 2. AI RESPONSE BOX
              pw.Text('AI Response',
                  style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: textDark)),
              pw.SizedBox(height: 8),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: boxBg,
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(8)),
                  border: pw.Border.all(
                      color: PdfColor.fromHex('#CCCCCC'), width: 1),
                ),
                child: pw.Text(
                    appointment.value?.aiResponse ?? "Belum ada response",
                    style: pw.TextStyle(
                        fontSize: 12, color: textDark, lineSpacing: 2)),
              ),
              pw.SizedBox(height: 24),

              // 3. MEDICINE LIST
              pw.Text('Medicine',
                  style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: textDark)),
              pw.SizedBox(height: 8),
              ...medicines.map((med) {
                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 8),
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: cardBg, // Warna hijau terang kotak obat
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(16)),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(
                        children: [
                          // Placeholder Icon Avatar Obat
                          pw.Container(
                              width: 40,
                              height: 40,
                              decoration: const pw.BoxDecoration(
                                color: PdfColors.white,
                                shape: pw.BoxShape.circle,
                              ),
                              child: pw.Center(
                                  child: pw.Text('💊',
                                      style:
                                          const pw.TextStyle(fontSize: 18)))),
                          pw.SizedBox(width: 12),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(med['name'],
                                  style: pw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.bold,
                                      color: textDark)),
                              pw.SizedBox(height: 2),
                              pw.Text('Drug Category',
                                  style: pw.TextStyle(
                                      fontSize: 10, color: textLight)),
                              pw.Text('Qty: ${med['qty']}',
                                  style: pw.TextStyle(
                                      fontSize: 10, color: textLight)),
                            ],
                          ),
                        ],
                      ),
                      pw.Text(
                          currencyFormatter.format(med['price'] * med['qty']),
                          style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryGreen)),
                    ],
                  ),
                );
              }),
              pw.SizedBox(height: 24),

              // 4. PAYMENT METHOD
              pw.Divider(color: PdfColors.grey400, thickness: 0.5),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 8),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Payment Method',
                        style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: textDark)),
                    pw.Text(bankName.isNotEmpty ? bankName : "Midtrans",
                        style: pw.TextStyle(fontSize: 12, color: textLight)),
                  ],
                ),
              ),
              pw.Divider(color: PdfColors.grey400, thickness: 0.5),
              pw.SizedBox(height: 16),

              // 5. PAYMENT DETAILS
              pw.Text('Payment Details',
                  style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: textDark)),
              pw.SizedBox(height: 12),
              buildSummaryRow(
                  'Product Subtotal',
                  currencyFormatter
                      .format(double.tryParse(productSubtotal.value) ?? 0)),
              buildSummaryRow(
                  'Consultation Fee', currencyFormatter.format(150000)),
              buildSummaryRow('Handling Fee', currencyFormatter.format(30000)),
              ...fees
                  .map((fee) => buildSummaryRow(
                      fee['procedure'], currencyFormatter.format(fee['price'])))
                  ,
              pw.SizedBox(height: 8),

              // TOTAL BOLD GREEN
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total',
                      style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: textDark)),
                  pw.Text(
                      currencyFormatter
                          .format(double.tryParse(total.value) ?? 0),
                      style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryGreen)),
                ],
              ),
            ];
          },
        ),
      );

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'invoice_$timestamp.pdf';

      final tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/$fileName';
      final tempFile = File(tempPath);
      await tempFile.writeAsBytes(await pdf.save());

      if (context.mounted) {
        Navigator.of(context).pop(); // Tutup loading
      }

      if (share) {
        if (tempFile.existsSync()) {
          await Share.shareXFiles(
            [XFile(tempPath, mimeType: 'application/pdf')],
            text: 'Invoice Details - $transactionCode',
          );
        } else {
          Get.snackbar('Error', 'Failed to share PDF. File not found.');
        }
      } else {
        String? saveDir = await FilePicker.platform.getDirectoryPath();
        if (saveDir == null) return;

        final savedFile = File('$saveDir/$fileName');
        try {
          await tempFile.copy(savedFile.path);
          await tempFile.delete();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('PDF saved to: ${savedFile.path}'),
                backgroundColor: Colors.green));
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Error: ${e.toString()}'),
                backgroundColor: Colors.red));
          }
        }
      }
    } catch (e) {
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red));
      }
    }
  }
}
