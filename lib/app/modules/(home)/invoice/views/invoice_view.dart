import 'package:clinic_ai/app/modules/(home)/invoice/controllers/invoice_controller.dart';
import 'package:clinic_ai/app/modules/(home)/redeemMedicine/views/midtrans_payment_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InvoiceView extends StatefulWidget {
  const InvoiceView({Key? key}) : super(key: key);

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  final invoiceController = Get.find<InvoiceController>();

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final DateFormat dateFormatter = DateFormat('dd MMMM yyyy');

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FBF2),
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Invoice',
          style: TextStyle(
              color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (invoiceController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (invoiceController.errorMessage.value != null) {
          return Center(
            child: Text(
              invoiceController.errorMessage.value!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),

                // =====================================
                // UI BARU: Kode Transaksi CMV
                // =====================================
                const Text('Kode Transaksi',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87)),
                const SizedBox(height: 4.0),
                Text(invoiceController.transactionCode,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 16.0),

                // Transfer Via
                const Text('Transfer Via',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87)),
                const SizedBox(height: 4.0),
                Text(
                    invoiceController.bankName.isNotEmpty
                        ? invoiceController.bankName
                        : 'Midtrans Payment',
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 16.0),

                // Tanggal Transaksi
                const Text('Tanggal Transaksi',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87)),
                const SizedBox(height: 4.0),
                Text(
                    invoiceController.appointment.value?.createdAt != null
                        ? dateFormatter.format(invoiceController
                            .appointment.value!.createdAt
                            .toLocal())
                        : 'N/A',
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 16.0),

                // Tanggal Berobat
                const Text('Tanggal Berobat',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87)),
                const SizedBox(height: 4.0),
                Text(
                  invoiceController.scheduleDate.value != null &&
                          invoiceController.scheduleTime.value != null
                      ? '${dateFormatter.format(invoiceController.scheduleDate.value!.scheduleDate.toLocal())}, ${invoiceController.scheduleTime.value!.scheduleTime}'
                      : 'N/A',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 20.0),

                // Symptoms
                const Text('Symptoms',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87)),
                const SizedBox(height: 4.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: invoiceController.symptoms
                      .map((symptom) => Text(symptom.idName,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87)))
                      .toList(),
                ),
                const SizedBox(height: 12.0),

                // Symptom Descriptions
                const Text('Symptom Descriptions',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87)),
                const SizedBox(height: 4.0),
                Text(
                  invoiceController.appointment.value?.symptomDescription ??
                      'N/A',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 20.0),

                // AI Response
                const Text('AI Response',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87)),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    invoiceController.appointment.value?.aiResponse ??
                        'Belum ada response',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 16.0),

                // Redeem Drug
                const Text('Redeem Drug',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87)),
                const SizedBox(height: 8.0),
                Column(
                  children: invoiceController.medicines.map((medicine) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(medicine['name'],
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87)),
                        Text(
                          currencyFormatter.format(medicine['price']),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),

                // Biaya
                const Text('Biaya',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87)),
                const SizedBox(height: 8.0),
                Column(
                  children: invoiceController.fees.map((fee) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(fee['procedure'],
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87)),
                        Text(
                          currencyFormatter.format(fee['price']),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),

                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87)),
                    Text(
                      currencyFormatter
                          .format(double.parse(invoiceController.total.value)),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xff35693E)),
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),

                // =====================================
                // UI BARU: TOMBOL MIDTRANS
                // =====================================
                SizedBox(
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
                    onPressed: () {
                      // LANGSUNG BUKA WEBVIEW MIDTRANS
                      Get.to(() => MidtransPaymentView(
                            paymentUrl: invoiceController.redirectUrl,
                            appointmentId: invoiceController.appointmentId,
                          ));
                    },
                    child: const Text(
                      'Pay with Midtrans',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          );
        }
      }),
      bottomNavigationBar: Obx(() {
        if (invoiceController.isLoading.value) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          decoration: const BoxDecoration(
            color: Color(0xFFF7FBF2),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    invoiceController.downloadInvoicePDF(
                        invoiceController.appointmentId,
                        share: true);
                  },
                  icon: const Icon(Icons.share, color: Color(0xFF35693E)),
                  label: const Text('Share',
                      style: TextStyle(
                          color: Color(0xFF35693E),
                          fontWeight: FontWeight.w500)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF35693E)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    invoiceController
                        .downloadInvoicePDF(invoiceController.appointmentId);
                  },
                  icon: const Icon(Icons.file_download_outlined,
                      color: Color(0xFF35693E)),
                  label: const Text('Download',
                      style: TextStyle(
                          color: Color(0xFF35693E),
                          fontWeight: FontWeight.w500)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF35693E)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
 