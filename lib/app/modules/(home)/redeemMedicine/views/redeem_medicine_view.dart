import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/redeem_medicine_controller.dart';

class RedeemMedicineView extends GetView<RedeemMedicineController> {
  const RedeemMedicineView({super.key});

  // ANTI ERROR STRING -> INT
  String formatRupiah(dynamic amount) {
    if (amount == null) return "Rp0";
    int value = 0;
    if (amount is int) {
      value = amount;
    } else if (amount is String) {
      value = int.tryParse(amount.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    } else if (amount is double) {
      value = amount.toInt();
    }
    return NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0)
        .format(value);
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<RedeemMedicineController>()) {
      Get.put(RedeemMedicineController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FBF6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Redeem Medicine',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xff35693E)));
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==========================================
                    // 1. AI RESPONSE BOX
                    // ==========================================
                    Text(
                      'AI Response',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors
                            .grey.shade200, // Warna abu-abu seperti desain
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.grey.shade400, width: 1),
                      ),
                      child: Text(
                        controller.aiResponse.value,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Divider(height: 1, color: Colors.grey.shade300),
                    const SizedBox(height: 24),

                    // ==========================================
                    // 2. MEDICINE LIST
                    // ==========================================
                    Text(
                      'Medicine',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (controller.medicines.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Tidak ada obat yang diresepkan.",
                              style: GoogleFonts.inter(color: Colors.grey)),
                        ),
                      )
                    else
                      ...controller.medicines.map((drug) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFD6EAD7), // Warna hijau pastel
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.white,
                                child: const Icon(Icons.medication,
                                    color: Color(0xff35693E)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      drug['name'],
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      drug['kind'],
                                      style: GoogleFonts.inter(
                                          fontSize: 12, color: Colors.black54),
                                    ),
                                    Text(
                                      drug['dosis'],
                                      style: GoogleFonts.inter(
                                          fontSize: 12, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                              // Harga Total Obat per Item (Harga x QTY)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    formatRupiah(drug['price'] * drug['qty']),
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xff35693E),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Qty: ${drug['qty']}",
                                    style: GoogleFonts.inter(
                                        fontSize: 12, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                    const SizedBox(height: 12),
                    Divider(height: 1, color: Colors.grey.shade300),
                    const SizedBox(height: 16),

                    // ==========================================
                    // 3. PAYMENT METHOD
                    // ==========================================
                    GestureDetector(
                      onTap: () => _showBankBottomSheet(context, controller),
                      child: Row(
                        children: [
                          const Icon(Icons.payment, color: Colors.black54),
                          const SizedBox(width: 12),
                          Text(
                            'Payment Method',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            controller.selectedBankName.value,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios,
                              size: 14, color: Colors.black54),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(height: 1, color: Colors.grey.shade300),
                    const SizedBox(height: 24),

                    // ==========================================
                    // 4. PAYMENT DETAILS
                    // ==========================================
                    Text(
                      'Payment Details',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPaymentRow(
                        'Product Subtotal', controller.productSubtotal.value),
                    _buildPaymentRow(
                        'Consultation Fee', controller.consultationFee.value),
                    _buildPaymentRow(
                        'Handling Fee', controller.handlingFee.value),

                    // Render Extra Fees dari Dokter jika ada
                    if (controller.extraFees.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text("Additional Fee:",
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700])),
                      const SizedBox(height: 4),
                      ...controller.extraFees
                          .map((fee) =>
                              _buildPaymentRow(fee['name'], fee['price']))
                          .toList(),
                    ],

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          formatRupiah(controller.totalAmount.value),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff35693E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // ==========================================
            // 5. PAY BUTTON
            // ==========================================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  )
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff35693E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  onPressed: controller.selectedBankId.value.isNotEmpty
                      ? () => controller.createTransaction()
                      : null,
                  // onPressed: () => controller.createTransaction(),
                  child: Text(
                    'Next',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // Row untuk rincian harga
  Widget _buildPaymentRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            formatRupiah(value),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Pop up Bottom Sheet Bank
  void _showBankBottomSheet(
      BuildContext context, RedeemMedicineController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
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
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.banks.isEmpty) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xff35693E)));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.banks.length,
                    itemBuilder: (context, index) {
                      final bank = controller.banks[index];
                      return Obx(() => ListTile(
                            title: Text(bank.name ?? 'Unknown Bank',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(
                                'Account Number: ${bank.accountNumber ?? 'N/A'}',
                                style: GoogleFonts.inter(fontSize: 12)),
                            trailing: Radio<String>(
                              value: bank.id ?? '',
                              groupValue: controller.selectedBankId.value,
                              onChanged: (String? value) {
                                controller.selectBank(
                                    value ?? '', bank.name ?? '');
                                Get.back();
                              },
                              activeColor: const Color(0xff35693E),
                            ),
                            onTap: () {
                              controller.selectBank(
                                  bank.id ?? '', bank.name ?? '');
                              Get.back();
                            },
                          ));
                    },
                  );
                }
              }),
            ],
          ),
        );
      },
    );
  }
}
