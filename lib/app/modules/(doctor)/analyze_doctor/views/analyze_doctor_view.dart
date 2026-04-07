import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Diperlukan untuk format Rupiah
import '../controllers/analyze_doctor_controller.dart';

class AnalyzeDoctorView extends GetView<AnalyzeDoctorController> {
  const AnalyzeDoctorView({super.key});

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
          'Analyze',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xff35693E)));
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchDetail,
                  child: const Text('Coba Lagi'),
                )
              ],
            ),
          );
        }

        final data = controller.appointmentData;
        if (data.isEmpty) {
          return const Center(child: Text("Data tidak tersedia"));
        }

        String symptomsText = "Tidak ada gejala terpilih";
        if (data['symptomList'] != null &&
            (data['symptomList'] as List).isNotEmpty) {
          symptomsText = (data['symptomList'] as List)
              .map((e) => e['id_name'] ?? e['en_name'] ?? '')
              .join(', ');
        }

        final String? imageUrl = data['image_url'];

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- PATIENT SECTION ---
                    Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        // FIX: Memaksa isi ExpansionTile untuk rata kiri
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        expandedAlignment: Alignment.centerLeft,
                        title: Text(
                          'Patient',
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        children: [
                          _buildDetailItem(
                              "Patient Name", data['patientName'] ?? 'Unknown'),
                          _buildDetailItem(
                              "Patient Code", data['qr_code'] ?? '-'),
                          _buildDetailItem("Symptoms", symptomsText),
                          _buildDetailItem(
                              "Symptom Descriptions",
                              data['symptom_description'] ??
                                  'Tidak ada deskripsi'),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: Text("Image Captured",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.grey[200]),
                            child: imageUrl != null && imageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                            child: CircularProgressIndicator(
                                                color: Color(0xff35693E)));
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image,
                                                  color: Colors.grey, size: 40),
                                    ),
                                  )
                                : const Icon(Icons.image_not_supported,
                                    color: Colors.grey, size: 40),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ==========================================
                    // DYNAMIC UI: BEFORE / AFTER AI
                    // ==========================================
                    if (!controller.isAIDone.value) ...[
                      Text("Doctor Analyst",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: controller.analystController,
                          minLines: 5,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: "Tuliskan keluhan spesifik ke AI...",
                            hintStyle:
                                GoogleFonts.inter(color: Colors.grey[400]),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ] else ...[
                      // 1. AI Response Box
                      Text("AI Response",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Text(
                          controller.aiResponseText.value,
                          style: GoogleFonts.inter(
                              fontSize: 14, color: Colors.black87, height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 2. Redeem Medicine (Search Box)
                      Text("Redeem Medicine",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: controller.searchMedicineController,
                          onChanged: controller.onSearchMedicineChanged,
                          decoration: const InputDecoration(
                            hintText: "Search medicine...",
                            suffixIcon:
                                Icon(Icons.search, color: Colors.black87),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),

                      // Dropdown Hasil Pencarian API
                      Obx(() {
                        if (controller.isSearching.value) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Color(0xff35693E))),
                          );
                        }
                        if (controller.searchResults.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Container(
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2))
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.searchResults.length,
                            itemBuilder: (context, index) {
                              final drug = controller.searchResults[index];
                              return ListTile(
                                title: Text(drug['name'] ?? 'Unknown',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                                subtitle: Text(
                                    "${drug['kind'] ?? '-'} | ${formatRupiah(drug['sell_price'])}",
                                    style: GoogleFonts.inter(fontSize: 12)),
                                trailing: const Icon(Icons.add_circle,
                                    color: Color(0xff35693E)),
                                onTap: () => controller.addDrug(drug),
                              );
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 16),

                      // 3. List Obat yang Dipilih
                      Obx(() {
                        if (controller.selectedDrugs.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          children: List.generate(
                              controller.selectedDrugs.length, (index) {
                            final drug = controller.selectedDrugs[index];
                            final int price = int.tryParse(
                                    drug['sell_price']?.toString() ?? '0') ??
                                0;
                            final int qty = drug['qty'] ?? 1;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(
                                    0xFFD6EAD7), // Hijau pastel Figma
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      radius: 24,
                                      child: const Icon(Icons.medication,
                                          color: Colors.white)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(drug['name'] ?? '-',
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        Text(drug['kind'] ?? 'Drug Category',
                                            style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: Colors.black54)),
                                        Text(drug['dosis'] ?? '500gr',
                                            style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: Colors.black54)),
                                        const SizedBox(height: 8),
                                        Text(formatRupiah(price),
                                            style: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: Colors.black54,
                                                decoration: TextDecoration
                                                    .lineThrough)),
                                        Text(formatRupiah(price * qty),
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () =>
                                            controller.increaseDrugQty(index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black54),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child:
                                              const Icon(Icons.add, size: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Text(qty.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Color(0xff35693E))),
                                      ),
                                      InkWell(
                                        onTap: () =>
                                            controller.decreaseDrugQty(index),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black54),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: const Icon(Icons.remove,
                                              size: 20),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                        );
                      }),
                      const SizedBox(height: 16),

                      // 4. Add Fee (Dropdown Sesuai Figma)
                      Text("Add Fee",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Map<String, dynamic>>(
                            isExpanded: true,
                            hint: Text("Pilih salah satu",
                                style:
                                    GoogleFonts.inter(color: Colors.grey[500])),
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.black87),
                            items: controller.feeOptions.map((fee) {
                              return DropdownMenuItem<Map<String, dynamic>>(
                                value: fee,
                                child: Text(
                                    "${fee['name']} (${formatRupiah(fee['price'])})"),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) controller.addFee(val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // List Biaya Tambahan yang Dipilih (Kotak Hijau)
                      Obx(() {
                        if (controller.selectedFees.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          children: List.generate(
                              controller.selectedFees.length, (index) {
                            final fee = controller.selectedFees[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFD6EAD7), // Background Hijau
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "${fee['name']} (${formatRupiah(fee['price'])})",
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500)),
                                  InkWell(
                                    onTap: () => controller.removeFee(index),
                                    child: const Icon(Icons.close,
                                        color: Colors.black87, size: 20),
                                  )
                                ],
                              ),
                            );
                          }),
                        );
                      }),
                      const SizedBox(height: 24),

                      // 5. Payment Details
                      Text("Payment Details",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Consultation Fee",
                              style: GoogleFonts.inter(
                                  color: Colors.grey[600], fontSize: 14)),
                          Text(formatRupiah(controller.consultationFee),
                              style: GoogleFonts.inter(
                                  color: Colors.grey[600], fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Handling Fee",
                              style: GoogleFonts.inter(
                                  color: Colors.grey[600], fontSize: 14)),
                          Text(formatRupiah(controller.handlingFee),
                              style: GoogleFonts.inter(
                                  color: Colors.grey[600], fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Rincian Tambahan (Obat & Fee)
                      Obx(() {
                        if (controller.selectedDrugs.isEmpty &&
                            controller.selectedFees.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text("Additional Fee",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                            const SizedBox(height: 8),

                            // Looping Obat untuk dimasukkan ke detail payment
                            ...List.generate(controller.selectedDrugs.length,
                                (index) {
                              final drug = controller.selectedDrugs[index];
                              final int price = int.tryParse(
                                      drug['sell_price']?.toString() ?? '0') ??
                                  0;
                              final int qty = drug['qty'] ?? 1;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${drug['name']} (x$qty)",
                                        style: GoogleFonts.inter(
                                            color: Colors.grey[600],
                                            fontSize: 14)),
                                    Text(formatRupiah(price * qty),
                                        style: GoogleFonts.inter(
                                            color: Colors.grey[600],
                                            fontSize: 14)),
                                  ],
                                ),
                              );
                            }),

                            // Looping Fee Tambahan
                            ...List.generate(controller.selectedFees.length,
                                (index) {
                              final fee = controller.selectedFees[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(fee['name'],
                                        style: GoogleFonts.inter(
                                            color: Colors.grey[600],
                                            fontSize: 14)),
                                    Text(formatRupiah(fee['price']),
                                        style: GoogleFonts.inter(
                                            color: Colors.grey[600],
                                            fontSize: 14)),
                                  ],
                                ),
                              );
                            })
                          ],
                        );
                      }),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(),
                      ),
                      Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Payment",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(formatRupiah(controller.totalFeeAmount),
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: const Color(0xff35693E))),
                            ],
                          )),
                      const SizedBox(height: 40),
                    ]
                  ],
                ),
              ),
            ),

            // ==========================================
            // DYNAMIC BOTTOM BUTTON
            // ==========================================
            Container(
              padding: const EdgeInsets.all(20),
              decoration:
                  BoxDecoration(color: const Color(0xFFF9FBF6), boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10)
              ]),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: Obx(() {
                  if (!controller.isAIDone.value) {
                    return OutlinedButton(
                      onPressed: controller.isGeneratingAI.value
                          ? null
                          : () => controller.submitAI(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: controller.isGeneratingAI.value
                                ? Colors.grey
                                : const Color(0xff35693E)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: controller.isGeneratingAI.value
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.5, color: Color(0xff35693E)))
                          : Text("Submit AI",
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff35693E))),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () => controller.finishAnalyze(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff35693E),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text("Finish",
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    );
                  }
                }),
              ),
            ),
          ],
        );
      }),
    );
  }

  // FIX: Memaksa detail item untuk mengambil lebar penuh agar selaras di sebelah kiri
  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 4),
            Text(value,
                style: GoogleFonts.inter(
                    fontSize: 14, color: Colors.grey[800], height: 1.5)),
          ],
        ),
      ),
    );
  }
}
