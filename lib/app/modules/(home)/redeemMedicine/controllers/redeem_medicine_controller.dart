import 'package:clinic_ai/models/bank_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RedeemMedicineController extends GetxController {
  // Sample data for medicines
  var medicines = [
    {
      'name': 'Paramex',
      'category': 'Drug Category',
      'detail': '500gr',
      'price': '96.000',
      'image': 'https://via.placeholder.com/50',
    },
    {
      'name': 'Oskadon',
      'category': 'Drug Category',
      'detail': '25 Strip',
      'price': '96.000',
      'image': 'https://via.placeholder.com/50',
    },
  ].obs;

  // Payment details
  var productSubtotal = '192.000'.obs;
  var consultationFee = '150.000'.obs;
  var handlingFee = '30.000'.obs;
  var total = '372.000'.obs;

  // Supabase client
  final supabase = Supabase.instance.client;

  // RxList untuk menampung data bank
  RxList<Bank> banks = <Bank>[].obs;

  // RxString untuk menyimpan nama bank yang dipilih
  RxString selectedBankName = 'Belum Dipilih'.obs;

  // RxString untuk menyimpan id bank yang dipilih
  RxString selectedBankId = ''.obs;

  // Method untuk mengambil data bank dari Supabase
  Future<void> fetchBanks() async {
    try {
      final response = await supabase.from('banks').select('*');
      if (response != null) {
        banks.value = (response as List).map((e) => Bank.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching banks: $e');
      // Handle error (misalnya, menampilkan snackbar)
    }
  }

  // Method untuk menyimpan id dan nama bank yang dipilih
  void selectBank(String bankId, String bankName) {
    selectedBankName.value = "Bank $bankName";
    selectedBankId.value = bankId;
    update(); // Panggil update() untuk memperbarui tampilan
  }

  @override
  void onInit() {
    fetchBanks(); // Ambil data bank saat controller diinisialisasi
    super.onInit();
  }
}