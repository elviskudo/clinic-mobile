import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/models/appointment_model.dart';
import 'package:clinic_ai/models/bank_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:clinic_ai/models/drug_model.dart';
import 'package:clinic_ai/models/appointment_drug_model.dart';
import 'package:clinic_ai/models/appointment_fee_model.dart';
import 'package:clinic_ai/models/fee_model.dart';
import 'package:clinic_ai/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:clinic_ai/models/clinic_model.dart'; //import model clinic
import 'package:clinic_ai/models/poly_model.dart'; //import model poly

class RedeemMedicineController extends GetxController {
  // RxList untuk menampung data obat dari appointment
  RxList<Drug> medicines = <Drug>[].obs;

  // RxList untuk menampung data fees dari appointment
  RxList<Fee> fees = <Fee>[].obs;

  // Loading state
  RxBool isLoading = false.obs;

  // Payment details
  var productSubtotal = '0'.obs;
  var consultationFee = '0'.obs;
  var handlingFee = '30.000'.obs;
  var total = '0'.obs;

  // Supabase client
  final supabase = Supabase.instance.client;

  // RxList untuk menampung data bank
  RxList<Bank> banks = <Bank>[].obs;

  // RxString untuk menyimpan nama bank yang dipilih
  RxString selectedBankName = 'Belum Dipilih'.obs;

  // RxString untuk menyimpan id bank yang dipilih
  RxString selectedBankId = ''.obs;

  // RxString untuk menampilkan ai response
  final aiResponse = ''.obs;
  Rxn<Appointment> appointment = Rxn<Appointment>();
  Rxn<Clinic> clinic = Rxn<Clinic>();
  Rxn<Poly> poly = Rxn<Poly>();
  RxString clinicInitials = ''.obs;
  RxString polyInitials = ''.obs;

  @override
  void onInit() {
    fetchBanks();
    final appointmentId = Get.arguments as String? ?? '';
    if (appointmentId.isNotEmpty) {
      fetchAppointment(appointmentId);
      fetchAppointmentDrugs(appointmentId);
      fetchAppointmentFees(appointmentId);
    }
    super.onInit();
  }

  Future<void> fetchBanks() async {
    try {
      final response = await supabase.from('banks').select('*');
      if (response != null) {
        banks.value = (response as List).map((e) => Bank.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching banks: $e');
    }
  }

  Future<void> fetchAppointment(String appointmentId) async {
    try {
      print('Appointment ID: $appointmentId');
      final response = await supabase
          .from('appointments')
          .select(
              '*, clinics(name), polies(name)') // Ambil semua kolom appointment + relasi
          .eq('id', appointmentId)
          .single();

      if (response != null) {
        print('Data Respons Lengkap: $response'); // Cetak data lengkap

        final aiResponseValue = response['ai_response'] as String?;
        aiResponse.value = aiResponseValue ?? 'Belum ada response';

        // Ambil data polies dengan aman
        final poliesData = response['polies'] as Map<String, dynamic>?;
        final polyName = poliesData?['name'] as String?;

        // Ambil data polies dengan aman
        final clinicData = response['clinics'] as Map<String, dynamic>?;
        final clinicName = clinicData?['name'] as String?;

        // Ambil clinic ID dan poly ID dari respons
        print('Ambil Klinik ${clinicName}');
        clinicInitials.value =
            clinicName?.split(' ').map((word) => word[0]).join() ?? 'CL';
        print('Ambil poly ${polyName}');
        polyInitials.value =
            polyName?.split(' ').map((word) => word[0]).join() ?? 'PL';

        appointment.value = Appointment.fromJson(response);
        print("betul");
      } else {
        aiResponse.value = 'Tidak ada response dari Supabase';
        print("betul22");
      }
    } catch (e) {
      aiResponse.value = 'Gagal mengambil response. Error: ${e.toString()}';
      print("Error fetch $e");
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
        total.value = consultationFee.value;
      }
    } catch (error) {
      medicines.value = [];
      productSubtotal.value = '0';
      total.value = consultationFee.value;
    } finally {
      isLoading.value = false;
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
      isLoading.value = false;
    }
  }

 Future<void> createTransaction() async {
  try {
    isLoading.value = true; // Start loading

    // Get required data
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    final String bankId = selectedBankId.value;
    final String appointmentId = Get.arguments as String? ?? '';
    final int totalPrice = int.parse(total.value);
    
    // Get data from appointment
    final appointmentData = appointment.value;
    final String clinicId = appointmentData?.clinicId ?? '';
    final String polyId = appointmentData?.polyId ?? '';

    // Generate transaction number
    final String transactionNumber = await generateTransactionNumber(clinicId, polyId);
    print('Transaction number: $transactionNumber');

    // Create transaction ID using UUID
    final String transactionId = const Uuid().v4();

    // Create transaction map directly instead of using the model
    final Map<String, dynamic> transactionData = {
      'id': transactionId,
      'bank_id': bankId,
      'appointment_id': appointmentId,
      'user_id': userId ?? '',
      'transaction_number': transactionNumber,
      'total_price': totalPrice.toDouble(),
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'status': 1,
    };

    // Send data to Supabase
    final response = await supabase
        .from('transactions')
        .insert(transactionData)
        .select()
        .single();

    // Show success message regardless of navigation
    Get.snackbar(
      'Transaksi Berhasil',
      'Transaksi Anda telah berhasil diproses.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Try to navigate after a short delay
    await Future.delayed(Duration(milliseconds: 800));
    
    // Print the response for debugging
    print('Transaction response: $response');
    
    if (response != null) {
      // Navigate with the raw response data instead of using the model
      Get.offAllNamed(Routes.INVOICE, arguments: response);
    }
  } catch (e) {
    print('Error creating transaction: $e');
    Get.snackbar(
      'Transaksi Gagal',
      'Terjadi kesalahan saat memproses transaksi. Silakan coba lagi.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false; // End loading
  }
}

  Future<String> generateTransactionNumber(
      String clinicId, String polyId) async {
    print('ini  id clinik $clinicId dan poly  ${polyId}');
    // 2. Ambil jumlah transaksi yang sudah ada
    int transactionCount = await getTransactionCount(clinicId, polyId);
    print('jumlah trasaksi   ${transactionCount}');
    // 3. Format nomor transaksi
    String formattedCount =
        (transactionCount + 1).toString().padLeft(4, '0'); // Misalnya, 0001
    print('Nomor ke berpa  $formattedCount}');
    // 4. Gabungkan semuanya dan ubah ke huruf besar
    return '${clinicInitials.value}${polyInitials.value}$formattedCount'
        .toUpperCase(); // Contoh: CMPL0001
  }

  Future<int> getTransactionCount(String clinicId, String polyId) async {
    try {
      final appointmentIdsQuery = supabase
          .from('appointments')
          .select('id')
          .eq('clinic_id', clinicId)
          .eq('poly_id', polyId);
      print('Ini Query ke Transaksi ${appointmentIdsQuery}');
      final List<dynamic> appointmentIdsResult = await appointmentIdsQuery;
      print('Hasilnya datanya adalah  ${appointmentIdsResult}');

      final List<String> appointmentIds =
          appointmentIdsResult.map((item) => item['id'] as String).toList();
      print('Id Transaksinya ${appointmentIds}');

      // Pastikan appointmentIds tidak kosong sebelum melakukan filter
      if (appointmentIds.isNotEmpty) {
        final response = await supabase
            .from('transactions')
            .select('id')
            .filter('appointment_id', 'in', appointmentIds);
        print('Setelah ke transak ${response}');

        if (response != null) {
          print('berhasil  ${response.length}');
          return response.length;
        } else {
          print('ini Nollll coy ${0}');
          return 0;
        }
      } else {
        // Jika tidak ada appointmentIds, return 0
        print('Appointment id nya kosong   ${0}');
        return 0;
      }
    } catch (e) {
      print('Error getting transaction count: $e');
      return 0;
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

  void selectBank(String bankId, String bankName) {
    selectedBankName.value = "Bank $bankName";
    selectedBankId.value = bankId;
    update();
  }
}
