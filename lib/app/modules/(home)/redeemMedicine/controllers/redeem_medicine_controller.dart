import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/models/bank_model.dart';

class RedeemMedicineController extends GetxController {
  RxBool isLoading = false.obs;
  final aiResponse = ''.obs;

  RxList<Map<String, dynamic>> medicines = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> extraFees = <Map<String, dynamic>>[].obs;

  var productSubtotal = 0.obs;
  var consultationFee = 150000.obs;
  var handlingFee = 30000.obs;
  var totalAmount = 0.obs;

  final supabase = Supabase.instance.client;
  RxList<Bank> banks = <Bank>[].obs;
  RxString selectedBankName = 'Belum Dipilih'.obs;
  RxString selectedBankId = ''.obs;

  RxString clinicInitials = 'CL'.obs;
  RxString polyInitials = 'PL'.obs;

  late String appointmentId;
  final String baseUrl = 'https://be-clinic-rx7y.vercel.app';

  @override
  void onInit() {
    super.onInit();
    appointmentId = Get.arguments as String? ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBanks();
      if (appointmentId.isNotEmpty) {
        fetchMedicalReport(appointmentId);
      }
    });
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

  Future<void> fetchMedicalReport(String id) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/appointments/$id/medical-report'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        var rawData = decoded['data'] ?? decoded;

        aiResponse.value = rawData['ai_response'] ?? 'Tidak ada catatan analisis.';
        final clinicName = rawData['clinic']?['name'] as String? ?? 'Clinic';
        final polyName = rawData['poly']?['name'] as String? ?? 'Poly';

        clinicInitials.value = clinicName.split(' ').map((w) => w.isNotEmpty ? w[0] : '').join().toUpperCase();
        polyInitials.value = polyName.split(' ').map((w) => w.isNotEmpty ? w[0] : '').join().toUpperCase();

        List<Map<String, dynamic>> parsedDrugs = [];
        int subtotalDrugs = 0;

        if (rawData['appointmentDrugs'] != null) {
          for (var item in rawData['appointmentDrugs']) {
            final drugMaster = item['drug'];
            if (drugMaster != null) {
              int qty = item['qty'] ?? 1;
              int price = int.tryParse(item['price']?.toString() ?? drugMaster['sell_price']?.toString() ?? '0') ?? 0;
              subtotalDrugs += (price * qty);
              parsedDrugs.add({
                'name': drugMaster['name'] ?? 'Unknown',
                'kind': drugMaster['kind'] ?? '-',
                'dosis': drugMaster['dosis'] ?? '-',
                'price': price,
                'qty': qty,
              });
            }
          }
        }
        medicines.assignAll(parsedDrugs);
        productSubtotal.value = subtotalDrugs;

        List<Map<String, dynamic>> parsedFees = [];
        int totalExtraFees = 0;
        if (rawData['appointmentFees'] != null) {
          for (var item in rawData['appointmentFees']) {
            final fee = item['fee'];
            if (fee != null) {
              int price = int.tryParse(fee['price']?.toString() ?? '0') ?? 0;
              totalExtraFees += price;
              parsedFees.add({
                'name': fee['procedure'] ?? fee['name'] ?? 'Extra Fee',
                'price': price,
              });
            }
          }
        }
        extraFees.assignAll(parsedFees);
        totalAmount.value = consultationFee.value + handlingFee.value + subtotalDrugs + totalExtraFees;
      }
    } catch (e) {
      print('Error Fetching Medical Report: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectBank(String bankId, String bankName) {
    selectedBankName.value = "Bank $bankName";
    selectedBankId.value = bankId;
    update();
  }

  // ==============================================================
  // BUAT TRANSAKSI DAN LEMPAR DATA KE HALAMAN INVOICE
  // ==============================================================
  Future<void> createTransaction() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';
      final String bankId = selectedBankId.value.isNotEmpty ? selectedBankId.value : "";

      if (appointmentId.isEmpty) {
        Get.snackbar("Error", "ID Janji Temu tidak ditemukan.", backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/transactions/midtrans-checkout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'appointment_id': appointmentId,
          'bank_id': bankId,
          'total_amount': totalAmount.value,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var innerData = responseData['data'] ?? responseData;
        final String? redirectUrl = innerData['redirect_url'];

        if (redirectUrl == null || redirectUrl.isEmpty) {
          Get.snackbar("Transaksi Gagal", "Link pembayaran tidak valid.", backgroundColor: Colors.red, colorText: Colors.white);
          return;
        }

        // ==========================================================
        // PINDAH KE HALAMAN INVOICE (BAWA LINK MIDTRANS)
        // ==========================================================
        Get.toNamed(Routes.INVOICE, arguments: {
          'appointmentId': appointmentId,
          'redirectUrl': redirectUrl,
          'bankName': selectedBankName.value,
        });

      } else {
        Get.snackbar("Transaksi Gagal", responseData['message']?.toString() ?? "Error dari server", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('System Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}