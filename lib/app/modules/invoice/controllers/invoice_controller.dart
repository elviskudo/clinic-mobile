import 'dart:io';
import 'package:clinic_ai/models/appointment_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:clinic_ai/models/symptom_model.dart';
import 'package:intl/intl.dart';
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

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getAppointmentData(String appointmentId, String bankId) async {
    print("Fungsi getAppointmentData dijalankan dengan ID: $appointmentId dan bankId: $bankId");
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

      // Ambil Daftar Gejala
      final symptomsString = appointment.value?.symptoms;
      print('2. Daftar gejala $symptomsString');
      if (symptomsString != null && symptomsString.isNotEmpty) {
        final symptomIds = symptomsString.split(',');
        final symptomsResponse = await supabase
            .from('symptoms')
            .select()
            .inFilter('id', symptomIds);
        print('3. Response symptom $symptomsResponse');
        if (symptomsResponse != null && symptomsResponse is List) {
          symptoms.assignAll(
              symptomsResponse.map((json) => Symptom.fromJson(json)).toList());
        } else {
          print('Gagal mengambil daftar gejala.');
        }
      }
         // Ambil Data Bank
      final bankResponse = await supabase
          .from('banks')
          .select()
          .eq('id', bankId)
          .single();

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
      if(scheduleDateResponse!= null){
           scheduleDate.value = ScheduleDate.fromJson(scheduleDateResponse);
      print('ScheduleDate data: ${scheduleDate.value}'); // Debugging
      }else{
           scheduleDate.value = null;
      }


      // Ambil ScheduleTime
      final scheduleTimeResponse = await supabase
          .from('schedule_times')
          .select()
          .eq('id', appointment.value!.timeId)
          .single();
      print('5. Response ScheduleTime $scheduleTimeResponse');
        if(scheduleTimeResponse!= null){
          scheduleTime.value = ScheduleTime.fromJson(scheduleTimeResponse);
        print('ScheduleTime data: ${scheduleTime.value}'); // Debugging
      }else{
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
    } finally {
      setLoading(false);
    }
  }
  // Function to upload file to Cloudinary
  Future<void> uploadFileToCloudinary(XFile file, String transactionId) async {
    try {
      setLoading(true);

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
      subtotal += medicine.sellPrice;
    }
    productSubtotal.value = subtotal.toStringAsFixed(0);

    // Hitung total biaya dari fees
    double feeTotal = 0;
    for (var fee in fees) {
      feeTotal += fee.price;
    }

    double totalValue = subtotal + feeTotal;
    total.value = totalValue.toStringAsFixed(0);
  }
 // Fungsi untuk mengubah status upload menjadi selesai
  void setLoading(bool value) {
    isLoading.value = value;
  }
   void setUploadComplete(bool value) {
    isUploadComplete.value = value;
  }
  @override
  void onClose() {
    // Dispose resources jika diperlukan
    imageUrl.value = '';
    fileType.value = '';
    super.onClose();
  }
}