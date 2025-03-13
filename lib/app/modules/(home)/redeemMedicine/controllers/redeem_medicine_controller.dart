import 'package:clinic_ai/models/appointment_model.dart';
import 'package:clinic_ai/models/bank_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:clinic_ai/models/drug_model.dart';
import 'package:clinic_ai/models/appointment_drug_model.dart';
import 'package:clinic_ai/models/appointment_fee_model.dart';
import 'package:clinic_ai/models/fee_model.dart';

class RedeemMedicineController extends GetxController {
  // RxList untuk menampung data obat dari appointment
  RxList<Drug> medicines = RxList<Drug>([]);

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
      final response = await supabase
          .from('appointments')
          .select('ai_response') // Hanya ambil ai_response
          .eq('id', appointmentId)
          .single();

      if (response != null) {
        final aiResponseValue = response['ai_response'] as String?;
        aiResponse.value = aiResponseValue ?? 'Belum ada response';
      } else {
        aiResponse.value = 'Tidak ada response dari Supabase';
      }
    } catch (e) {
      aiResponse.value = 'Gagal mengambil response. Error: ${e.toString()}';
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
        final List<AppointmentDrug> appointmentDrugs = (appointmentDrugsResponse as List)
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
            print('Error fetching drug with ID ${appointmentDrug.drugId}: $drugError');
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
        final List<AppointmentFee> appointmentFees = (appointmentFeesResponse as List)
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
            print('Error fetching fee with ID ${appointmentFee.feeId}: $feeError');
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
      calculateTotalPrice();
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