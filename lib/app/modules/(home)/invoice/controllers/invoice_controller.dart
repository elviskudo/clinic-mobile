import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/models/appointment_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:clinic_ai/models/symptom_model.dart';
import 'package:clinic_ai/models/scheduleDate_model.dart';
import 'package:clinic_ai/models/scheduleTime_model.dart';
import 'package:clinic_ai/models/bank_model.dart';
import 'package:clinic_ai/models/fee_model.dart';
import 'package:clinic_ai/models/drug_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:clinic_ai/models/appointment_fee_model.dart';
import 'package:clinic_ai/models/appointment_drug_model.dart';
import 'package:clinic_ai/models/file_model.dart';
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
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class InvoiceController extends GetxController {
  // Supabase Instance
  final supabase = Supabase.instance.client;

  // Cloudinary Configuration
  final cloudName = 'dcthljxbl';
  final uploadPreset = 'dompet-mal';

  // Observables
  final isLoading = false.obs;
  final appointment = Rxn<Appointment>();
  final errorMessage = Rxn<String>();
  final symptoms = <Symptom>[].obs;
  final scheduleDate = Rxn<ScheduleDate>();
  final scheduleTime = Rxn<ScheduleTime>();
  final bank = Rxn<Bank>();
  final medicines = <Drug>[].obs;
  final fees = <Fee>[].obs;
  final productSubtotal = '0'.obs;
  final total = '0'.obs;
  final isUploading = false.obs;
  final isUploadComplete = false.obs;
  final imageUrl = ''.obs;
  final fileType = ''.obs;
  final selectedImage = Rxn<File>(); // Tambahkan ini

  //Tambahan Data
  final clinic = Rxn<Clinic>();
  final poly = Rxn<Poly>();
  final doctor = Rxn<Doctor>();
  final patientName = ''.obs;

  // Supabase Realtime Channel
  RealtimeChannel? _channel;

  @override
  void onInit() {
    super.onInit();
    getPatientName();
  }

  @override
  void onClose() {
    _channel?.unsubscribe();
    super.onClose();
  }
    Future<void> getPatientName() async {
     final prefs = await SharedPreferences.getInstance();
      patientName.value = prefs.getString('name') ?? 'Tidak ada nama';
  }

  void setupRealtimeSubscription(String appointmentId) {
    // Unsubscribe dari channel sebelumnya jika ada
    _channel?.unsubscribe();

    _channel = supabase
        .channel('appointment_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'appointments',
          callback: (payload) {
            print("Realtime update diterima!");
            // Access the new record directly from payload
            final Map<String, dynamic> newRecord = payload.newRecord;
            if (newRecord['id'] == appointmentId) {
              final int newStatus = (newRecord['status'] as num).toInt();
              print('Status appointment berubah menjadi: $newStatus');
             
              if (newStatus == 2) {
               
                Get.offAllNamed(
                  Routes.PAYMENT_SUCCESS,
                  arguments: {
                    'qr_code': appointment.value!.qrCode,
                    'patient_name': patientName.value,
                  },
                );
              } else if (newStatus == 3) {
                Get.toNamed(Routes.PAYMENT_DENIED);
              }
            } else {
              print("Update bukan untuk appointment ini.");
            }
          },
        )
        .subscribe();
  }

  Future<void> getAppointmentData(String appointmentId, String bankId) async {
    print(
        "Fungsi getAppointmentData dijalankan dengan ID: $appointmentId dan bankId: $bankId");
    isLoading.value = true;
    errorMessage.value = null;
    symptoms.clear();
    scheduleDate.value = null;
    scheduleTime.value = null;
    bank.value = null;
    medicines.clear();
    fees.clear();

    try {
      // Ambil data appointment dari Supabase
      final appointmentResponse = await supabase
          .from('appointments')
          .select()
          .eq('id', appointmentId)
          .single();

      print('1. Response Appointment $appointmentResponse');

      if (appointmentResponse == null) {
        errorMessage.value = 'Gagal mengambil data appointment.';
        print(errorMessage.value);
        appointment.value = null;
        return;
      }

      appointment.value = Appointment.fromJson(appointmentResponse);
      print('Appointment data: ${appointment.value}');

      // Setup Realtime setelah mendapatkan data
      if (appointment.value != null) {
        setupRealtimeSubscription(appointment.value!.id);
      }

      // Ambil Daftar Gejala
      final symptomsString = appointment.value?.symptoms;
      print('2. Daftar gejala $symptomsString');
      if (symptomsString != null && symptomsString.isNotEmpty) {
        final symptomIds = symptomsString.split(',');
        final symptomsResponse =
            await supabase.from('symptoms').select().inFilter('id', symptomIds);
        print('3. Response symptom $symptomsResponse');
        if (symptomsResponse != null && symptomsResponse is List) {
          symptoms.assignAll(
              symptomsResponse.map((json) => Symptom.fromJson(json)).toList());
        } else {
          print('Gagal mengambil daftar gejala.');
        }
      }
      // Ambil Data Bank
      final bankResponse =
          await supabase.from('banks').select().eq('id', bankId).single();

      if (bankResponse != null) {
        bank.value = Bank.fromJson(bankResponse);
        print('Data Bank: ${bank.value}'); // Debugging
      } else {
        print('Gagal mengambil data bank.');
        bank.value = null;
      }
      // Ambil ScheduleDate
      final scheduleDateResponse = await supabase
          .from('schedule_dates')
          .select()
          .eq('id', appointment.value!.dateId)
          .single();
      print('4. Response ScheduleDate $scheduleDateResponse');
      if (scheduleDateResponse != null) {
        scheduleDate.value = ScheduleDate.fromJson(scheduleDateResponse);
        print('ScheduleDate data: ${scheduleDate.value}'); // Debugging
      } else {
        scheduleDate.value = null;
      }

      // Ambil ScheduleTime
      final scheduleTimeResponse = await supabase
          .from('schedule_times')
          .select()
          .eq('id', appointment.value!.timeId)
          .single();
      print('5. Response ScheduleTime $scheduleTimeResponse');
      if (scheduleTimeResponse != null) {
        scheduleTime.value = ScheduleTime.fromJson(scheduleTimeResponse);
        print('ScheduleTime data: ${scheduleTime.value}'); // Debugging
      } else {
        scheduleTime.value = null;
      }
      // Ambil Data Appointment Drugs
      await fetchAppointmentDrugs(appointmentId);

      // Ambil Data Appointment Fees
      await fetchAppointmentFees(appointmentId);
      calculateTotalPrice();
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      print(errorMessage.value);
      appointment.value = null;
      Get.snackbar('Error', 'Error fetching appointment data: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchDataTambahan(String appointmentId) async {
    try {
      isLoading(true);

      // Ambil data Appointment
      final appointmentResponse = await supabase
          .from('appointments')
          .select()
          .eq('id', appointmentId)
          .single();
      appointment.value = Appointment.fromJson(appointmentResponse);

      // Ambil data Clinic
      final clinicResponse = await supabase
          .from('clinics')
          .select()
          .eq('id', appointment.value!.clinicId)
          .single();
      clinic.value = Clinic.fromJson(clinicResponse);

      // Ambil data Poly (Perbaikan nama tabel)
      final polyResponse = await supabase
          .from('polies')
          .select()
          .eq('id', appointment.value!.polyId)
          .single();
      poly.value = Poly.fromJson(polyResponse);

      // Ambil data Doctor
      final doctorResponse = await supabase
          .from('doctors')
          .select()
          .eq('id', appointment.value!.doctorId)
          .single();
      doctor.value = Doctor.fromJson(doctorResponse);

      // Ambil nama pasien dari Shared Preferences
      final prefs = await SharedPreferences.getInstance();
      patientName.value = prefs.getString('name') ?? 'Tidak ada nama';
    } catch (e) {
      errorMessage.value = 'Gagal mengambil data: ${e.toString()}';
      Get.snackbar('Error', 'Error fetching additional data: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchAppointmentDrugs(String appointmentId) async {
    isLoading.value = true;
    try {
      final appointmentDrugsResponse = await supabase
          .from('appointment_drugs')
          .select('*')
          .eq('appointment_id', appointmentId);

      if (appointmentDrugsResponse != null) {
        final List<AppointmentDrug> appointmentDrugs =
            (appointmentDrugsResponse as List)
                .map((e) => AppointmentDrug.fromJson(e))
                .toList();

        List<Drug> fetchedDrugs = [];
        for (var appointmentDrug in appointmentDrugs) {
          try {
            final drugResponse = await supabase
                .from('drugs')
                .select('*')
                .eq('id', appointmentDrug.drugId)
                .single();

            if (drugResponse != null) {
              fetchedDrugs.add(Drug.fromJson(drugResponse));
            } else {
              fetchedDrugs.add(
                Drug(
                  id: '0',
                  name: 'Obat Tidak Ditemukan',
                  description: 'Deskripsi tidak tersedia',
                  companyName: 'Tidak ada',
                  stock: 0,
                  buyPrice: 0,
                  sellPrice: 0,
                  dosis: 'Tidak ada',
                  kind: 'Tidak ada',
                  isHalal: false,
                  createdAt: DateTime.now().toString(),
                  updatedAt: DateTime.now(),
                ),
              );
            }
          } catch (drugError) {
            print(
                'Error fetching drug with ID ${appointmentDrug.drugId}: $drugError');
            Get.snackbar('Error', 'Error fetching drug: $drugError');
          }
        }

        medicines.value = fetchedDrugs;
        calculateTotalPrice();
      } else {
        medicines.value = [];
        productSubtotal.value = '0';
        total.value = '0';
      }
    } catch (error) {
      medicines.value = [];
      productSubtotal.value = '0';
      total.value = '0';
      Get.snackbar('Error', 'Error fetching appointment drugs: $error');
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchAppointmentFees(String appointmentId) async {
    isLoading.value = true;
    try {
      final appointmentFeesResponse = await supabase
          .from('appointment_fees')
          .select('*')
          .eq('appointment_id', appointmentId);

      if (appointmentFeesResponse != null) {
        final List<AppointmentFee> appointmentFees =
            (appointmentFeesResponse as List)
                .map((e) => AppointmentFee.fromJson(e))
                .toList();

        List<Fee> fetchedFees = [];
        for (var appointmentFee in appointmentFees) {
          try {
            final feeResponse = await supabase
                .from('fees')
                .select('*')
                .eq('id', appointmentFee.feeId)
                .single();

            if (feeResponse != null) {
              fetchedFees.add(Fee.fromJson(feeResponse));
            } else {
              print('Fee dengan ID ${appointmentFee.feeId} tidak ditemukan');
              fetchedFees.add(
                Fee(
                  id: '0',
                  procedure: 'Biaya Tidak Ditemukan',
                  price: 0,
                  status: false,
                ),
              );
            }
          } catch (feeError) {
            print(
                'Error fetching fee with ID ${appointmentFee.feeId}: $feeError');
            Get.snackbar('Error', 'Error fetching fee: $feeError');
          }
        }

        fees.value = fetchedFees;
        calculateTotalPrice();
      } else {
        fees.value = [];
        print('Tidak ada data biaya untuk appointment ini.');
      }
    } catch (error) {
      print('Terjadi kesalahan saat mengambil data biaya: $error');
      fees.value = [];
      Get.snackbar('Error', 'Error fetching appointment fees: $error');
    } finally {
      setLoading(false);
    }
  }

  Future<void> pickImage(XFile file, String transactionId) async {
    try {
      setLoading(true);
      selectedImage.value = File(file.path); // Set gambar yang dipilih

      final bytes = await file.readAsBytes();
      fileType.value = file.name.split('.').last;

      final formData = dio.FormData.fromMap({
        'file': dio.MultipartFile.fromBytes(
          bytes,
          filename: file.name,
        ),
        'upload_preset': uploadPreset,
      });

      final response = await dio.Dio().post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        imageUrl.value = response.data['secure_url'];
        // After successful upload, save file info to Supabase
        await saveFileInfo(transactionId);
        setUploadComplete(true);
      } else {
        Get.snackbar('Error', 'Failed to upload image to Cloudinary');
      }
    } catch (e) {
      print('Upload error: $e');
      Get.snackbar('Error', 'Failed to upload file: $e');
    } finally {
      setLoading(false);
    }
  }
  // Function to upload file to Cloudinary

  //Function delete file from Supabase
  Future<void> cancelImage(String transactionId) async {
    try {
      setLoading(true);

      // Find the file info in Supabase based on module_class and module_id
      final response = await supabase
          .from('files')
          .select()
          .eq('module_class', 'transactions')
          .eq('module_id', transactionId)
          .single();

      if (response != null) {
        final fileId = response['id'];

        // Delete the file info from Supabase
        await supabase.from('files').delete().eq('id', fileId);
        print("fileId: $fileId");
      } else {
        print('File information not found in Supabase.');
      }
      selectedImage.value = null; // Hapus gambar yang dipilih
      imageUrl.value = ''; // Reset imageUrl
      fileType.value = ''; // Reset fileType
      isUploadComplete.value = false; // Reset status upload
    } catch (e) {
      print('Error deleting file info: $e');
      Get.snackbar('Error', 'Failed to delete file information: $e');
    } finally {
      setLoading(false);
    }
  }

  void clearUploadState() {
    imageUrl.value = '';
    fileType.value = '';
    setUploadComplete(false);
  }

  // Function to save file info to Supabase
  Future<void> saveFileInfo(String transactionId) async {
    try {
      setLoading(true);
      final fileData = FileModel(
        moduleClass: 'transactions',
        moduleId: transactionId,
        fileName: imageUrl.value,
        fileType: fileType.value,
      ).toJson();

      await supabase.from('files').insert(fileData);

      Get.snackbar('Success', 'File information saved successfully');
    } catch (e) {
      print('Error saving file info: $e');
      Get.snackbar('Error', 'Failed to save file information: $e');
    } finally {
      setLoading(false);
    }
  }

  void calculateTotalPrice() {
    double subtotal = 0;
    for (var medicine in medicines) {
      //Penaganan Error NAN
      if (medicine.sellPrice.isNaN) {
        print('Warning: Medicine price is NaN. Skipping.');
        continue; // Skip to the next medicine
      }
      subtotal += medicine.sellPrice;
    }
    productSubtotal.value = subtotal.toStringAsFixed(0);

    // Hitung total biaya dari fees
    double feeTotal = 0;
    for (var fee in fees) {
      //Penaganan Error NAN
      if (fee.price.isNaN) {
        print('Warning: Fee price is NaN. Skipping.');
        continue; // Skip to the next fee
      }
      feeTotal += fee.price;
    }

    double totalValue = subtotal + feeTotal;
    // Ensure totalValue is not NaN before formatting
    if (totalValue.isNaN) {
      print('Error: Total value is NaN. Setting to 0.');
      totalValue = 0; // Set to a default value
    }

    total.value = totalValue.toStringAsFixed(0);
  }

  // Fungsi untuk mengubah status upload menjadi selesai
  void setLoading(bool value) {
    isLoading.value = value;
  }

  void setUploadComplete(bool value) {
    isUploadComplete.value = value;
  }

  //Fungsi Donwload PDF
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

  Future<void> downloadInvoicePDF(String appointmentId,
      {bool share = false}) async {
    final context = Get.context!;

    try {
      // Meminta izin penyimpanan
      final hasPermission = await _requestStoragePermission(context);
      if (!hasPermission) {
        return;
      }

      // Menampilkan loading indicator
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

      await fetchDataTambahan(appointmentId);

      final pdf = pw.Document();

      // Define colors
      final textColor = PdfColors.black;

      // Number formatter
      final currencyFormatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
      final dateFormatter = DateFormat('dd MMMM yyyy');

      // DEBUGGING: Periksa data QR Code
      print("Data QR Code: ${appointment.value!.qrCode}");

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(24),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'INVOICE',
                    style: pw.TextStyle(
                      color: textColor,
                      fontSize: 32,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 24),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Clinic Information',
                              style: pw.TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              'Clinic Name: ${clinic.value?.name ?? "N/A"}',
                              style:
                                  pw.TextStyle(color: textColor, fontSize: 14),
                            ),
                            pw.Text(
                              'Address: ${clinic.value?.address ?? "N/A"}',
                              style:
                                  pw.TextStyle(color: textColor, fontSize: 14),
                            ),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Doctor Information',
                              style: pw.TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              'Name: ${doctor.value?.name ?? "N/A"}',
                              style:
                                  pw.TextStyle(color: textColor, fontSize: 14),
                            ),
                            pw.Text(
                              'Specialization: ${doctor.value?.specialize ?? "N/A"}',
                              style:
                                  pw.TextStyle(color: textColor, fontSize: 14),
                            ),
                            pw.Text(
                              'Poly: ${poly.value?.name ?? "N/A"}',
                              style:
                                  pw.TextStyle(color: textColor, fontSize: 14),
                            ),
                          ],
                        ),
                      ]),
                  pw.SizedBox(height: 24),
                  pw.Text(
                    'Patient Information',
                    style: pw.TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Name: ${patientName.value}',
                    style: pw.TextStyle(color: textColor, fontSize: 14),
                  ),
                  pw.SizedBox(height: 24),
                  pw.Text(
                    'Appointment Details',
                    style: pw.TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Appointment Date: ${appointment.value?.createdAt != null ? dateFormatter.format(appointment.value!.createdAt.toLocal()) : 'N/A'}',
                    style: pw.TextStyle(color: textColor, fontSize: 14),
                  ),
                  pw.Text(
                    'Payment Method: ${bank.value?.name ?? "N/A"} - ${bank.value?.accountNumber ?? "N/A"}',
                    style: pw.TextStyle(color: textColor, fontSize: 14),
                  ),
                  pw.Text(
                    'Symptoms: ${symptoms.map((s) => s.idName).join(', ')}',
                    style: pw.TextStyle(color: textColor, fontSize: 14),
                  ),
                  pw.Text(
                    'Symptom Description: ${appointment.value?.symptomDescription ?? "N/A"}',
                    style: pw.TextStyle(color: textColor, fontSize: 14),
                  ),
                  pw.Text(
                    'AI Response: ${appointment.value?.aiResponse ?? "N/A"}',
                    style: pw.TextStyle(color: textColor, fontSize: 14),
                  ),
                  pw.SizedBox(height: 24),
                  pw.Row(
                    // Row untuk menyelaraskan Medicines dan QR Code
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment
                        .start, // Penting untuk menyelaraskan atas
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Medicines',
                              style: pw.TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: medicines.map((medicine) {
                                return pw.Text(
                                  '- ${medicine.name} (${currencyFormatter.format(medicine.sellPrice)})',
                                  style: pw.TextStyle(
                                      color: textColor, fontSize: 14),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(
                          width: 20), // Jarak antara Medicines dan QR Code
                      pw.Container(
                        width: 100,
                        height: 100,
                        child: pw.BarcodeWidget(
                          data: appointment.value!.qrCode,
                          barcode: pw.Barcode.qrCode(),
                          color: PdfColors.black,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 24),
                  pw.Text(
                    'Fees',
                    style: pw.TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: fees.map((fee) {
                      return pw.Text(
                        '- ${fee.procedure} (${currencyFormatter.format(fee.price)})',
                        style: pw.TextStyle(color: textColor, fontSize: 14),
                      );
                    }).toList(),
                  ),
                  pw.SizedBox(height: 24),
                  pw.Text(
                    'Total: ${currencyFormatter.format(double.parse(total.value))}',
                    style: pw.TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Generate unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'invoice_$timestamp.pdf';

      // Construct the file path within the temporary directory
      final tempDir = await getTemporaryDirectory();
      String tempPath = '${tempDir.path}/$fileName';
      final tempFile = File(tempPath);
      print("tempPath ======> $tempPath");

      // Simpan PDF ke file temporary
      await tempFile.writeAsBytes(await pdf.save());

      // Close loading indicator
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (share) {
        // Bagikan PDF
        if (tempFile.existsSync()) {
          await Share.shareXFiles(
            [
              XFile(
                tempPath,
                mimeType: 'application/pdf',
              ),
            ],
            text: 'Invoice Details',
          );
        } else {
          print('Error: PDF file does not exist at path: $tempPath');
          Get.snackbar('Error', 'Failed to share PDF. File not found.');
        }
      } else {
        // Let user pick the save location
        String? saveDir = await FilePicker.platform.getDirectoryPath();
        if (saveDir == null) {
          // User cancelled directory selection
          return;
        }
        final savedFile = File('$saveDir/$fileName');
        try {
          await tempFile.copy(savedFile.path);
          print('PDF Berhasil Disimpan di: ${savedFile.path}');

          // Menghapus file temporary setelah disalin
          await tempFile.delete();
          // Show success message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('PDF saved to: ${savedFile.path}'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          print('Error copying file: $e');
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
    void clearDataTambahan() {
    clinic.value = null;
    poly.value = null;
    doctor.value = null;
    patientName.value = '';
    print('Additional data cleared!');
  }
}
