import 'package:clinic_ai/app/modules/(home)/redeemMedicine/controllers/redeem_medicine_controller.dart';
import 'package:clinic_ai/models/drug_model.dart';
import 'package:clinic_ai/models/fee_model.dart';
import 'package:clinic_ai/models/transaction_model.dart'; //import transaction
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class RedeemMedicineView extends GetView<RedeemMedicineController> {
  const RedeemMedicineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<RedeemMedicineController>()) {
      Get.put(RedeemMedicineController());
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Reedem Medicine',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Text(
                          'AI Response',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1),
                          ),
                          child: Obx(
                            () => Text(
                              controller.aiResponse.value,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 4,
                        color: Colors.grey.shade200,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          'Medicine',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Obx(() => Column(
                            children: controller.medicines
                                .map((medicine) => _buildMedicineCard(medicine))
                                .toList(),
                          )),
                      GestureDetector(
                        onTap: () {
                          _showBankBottomSheet(context, controller);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Text(
                                '\u{1F4B3}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Payment Method',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              Obx(() => Text(
                                    controller.selectedBankName.value,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  )),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Payment Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Obx(() => Column(
                                  children: [
                                    // Tampilkan daftar fees
                                    ...controller.fees
                                        .map((fee) => _buildPaymentRow(
                                            fee.procedure,
                                            fee.price.toString()))
                                        .toList(),
                                    const SizedBox(height: 4),
                                    _buildPaymentRow(
                                        'Total', controller.total.value,
                                        isTotal: true),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80), // Ruang untuk tombol Pay
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              // Tombol Pay
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                decoration: const BoxDecoration(
                  color: Color(
                      0xFFF7FBF2), // Warna latar belakang yang sama dengan Scaffold
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    onPressed: controller.selectedBankId.value.isNotEmpty
                        ? () async {
                            // Action when Pay button is pressed
                            // Lakukan pembayaran di sini
                            await controller.createTransaction();
                          }
                        : null, // Disable tombol jika bank belum dipilih
                    child: const Text(
                      'Pay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildMedicineCard(Drug medicine) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade500,
            child: ClipOval(
              child: Image.network(
                'https://via.placeholder.com/50',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.medical_services, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  medicine.kind,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  medicine.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Text(
            currencyFormatter.format(medicine.sellPrice),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isTotal = false}) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          Text(
            currencyFormatter.format(double.parse(value)),
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal
                  ? Theme.of(Get.context!).primaryColor
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showBankBottomSheet(
      BuildContext context, RedeemMedicineController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Obx(() {
                if (controller.banks.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.banks.length,
                      itemBuilder: (context, index) {
                        final bank = controller.banks[index];
                        return Obx(() => ListTile(
                              title: Text(bank.name ?? 'Unknown Bank'),
                              subtitle: Text(
                                  'Account Number: ${bank.accountNumber ?? 'N/A'}'),
                              trailing: Radio<String>(
                                value: bank.id ?? '',
                                groupValue: controller.selectedBankId.value,
                                onChanged: (String? value) {
                                  controller.selectBank(
                                      value ?? '', bank.name ?? '');
                                  Get.back();
                                },
                                activeColor: Colors.green,
                              ),
                              onTap: () {
                                controller.selectBank(
                                    bank.id ?? '', bank.name ?? '');
                                Get.back();
                              },
                            ));
                      });
                }
              }),
            ],
          ),
        );
      },
    );
  }
}
