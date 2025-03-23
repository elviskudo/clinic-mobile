import 'dart:io';

import 'package:clinic_ai/app/modules/(home)/invoice/controllers/invoice_controller.dart';
import 'package:clinic_ai/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class InvoiceView extends StatefulWidget {
  const InvoiceView({Key? key}) : super(key: key);

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  final invoiceController = Get.find<InvoiceController>();
  Transaction? transaksi;

  @override
  void initState() {
    super.initState();
    transaksi = Get.arguments as Transaction?;
    if (transaksi != null && transaksi!.appointmentId != null) {
      invoiceController.getAppointmentData(
          transaksi!.appointmentId!, transaksi!.bankId!);
    } else {
      print('Transaction data or appointmentId is null');
    }
  }

  // Fungsi untuk menampilkan dialog pilihan sumber gambar
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pilih Sumber Gambar"),
          actions: [
            TextButton(
              child: const Text("Galeri"),
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            TextButton(
              child: const Text("Kamera"),
              onPressed: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk mengambil gambar dari sumber yang dipilih
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      invoiceController.pickImage(pickedFile, transaksi!.id!); // Pindahkan ke controller
    }
  }

  // Fungsi untuk membatalkan gambar yang dipilih
  void _cancelImage() {
    invoiceController.cancelImage(transaksi!.id!); // Pindahkan ke controller
  }

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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Invoice',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (invoiceController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
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

                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF35693E), width: 1),
                  ),
                  child: TextButton(
                    onPressed: !invoiceController.isUploadComplete.value
                        ? () {
                            _showImageSourceDialog();
                          }
                        : null,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF35693E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Upload Bukti Transfer",
                        style: TextStyle(color: Color(0xFF35693E), fontSize: 16),
                      ),
                    ),
                  ),
                ),

                Obx(() =>
                  invoiceController.selectedImage.value != null
                      ? Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  invoiceController.selectedImage.value!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _cancelImage,
                              child: const Text("Batalkan Upload"),
                            )
                          ],
                        ),
                      )
                      : SizedBox.shrink()
                ),

                const SizedBox(height: 20.0),

                Obx(() => Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: invoiceController.isUploadComplete.value
                            ? Colors.green[100]
                            : Colors.red[100],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            invoiceController.isUploadComplete.value
                                ? Icons.check_circle
                                : Icons.error_outline,
                            color: invoiceController.isUploadComplete.value
                                ? Colors.green
                                : Colors.red,
                            size: 24,
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  invoiceController.isUploadComplete.value
                                      ? 'Bukti transfer sudah di unggah!'
                                      : 'Belum',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: invoiceController.isUploadComplete.value
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                Text(
                                  invoiceController.isUploadComplete.value
                                      ? 'Menunggu persetujuan admin'
                                      : 'Menunggu pembayaran',
                                  style: TextStyle(
                                    color: invoiceController.isUploadComplete.value
                                        ? Colors.green[800]
                                        : Colors.red[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),

                const SizedBox(height: 20.0),

                // Kode Transaksi
                const Text('Kode Transaksi',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4.0),
                Text(transaksi?.transactionNumber ?? 'N/A',
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 16.0),

                // Transfer Via
                const Text('Transfer Via',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4.0),
                Obx(() => Text(
                    invoiceController.bank.value != null
                        ? '${invoiceController.bank.value?.accountNumber} - ${invoiceController.bank.value?.name}'
                        : 'N/A',
                    style: const TextStyle(fontSize: 14))),
                const SizedBox(height: 16.0),

                // Tanggal Transaksi
                const Text('Tanggal Transaksi',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4.0),
                Text(
                    transaksi?.createdAt != null
                        ? dateFormatter.format(
                            transaksi!.createdAt!.toLocal())
                        : 'N/A',
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 16.0),

                // Tanggal Berobat
                const Text('Tanggal Berobat',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4.0),
                Obx(() => Text(
                      invoiceController.scheduleDate.value != null &&
                              invoiceController.scheduleTime.value != null
                          ? dateFormatter.format(invoiceController
                              .scheduleDate.value!.scheduleDate
                              .toLocal()) +
                              ', ' +
                              invoiceController
                                  .scheduleTime.value!.scheduleTime
                          : 'N/A',
                      style: const TextStyle(fontSize: 14),
                    )),
                const SizedBox(height: 20.0),

                // Symptoms
                const Text('Symptoms',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4.0),
                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: invoiceController.symptoms
                          .map((symptom) => Text(symptom.idName,
                              style: const TextStyle(fontSize: 14)))
                          .toList(),
                    )),
                const SizedBox(height: 12.0),

                // Symptom Descriptions
                const Text('Symptom Descriptions',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4.0),
                Obx(() => Text(
                      invoiceController.appointment.value?.symptomDescription ??
                          'N/A',
                      style: const TextStyle(fontSize: 14),
                    )),
                const SizedBox(height: 20.0),

                // AI Response
                const Text('AI Response',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Obx(() => Text(
                        invoiceController.appointment.value?.aiResponse ??
                            'Belum ada response',
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.start,
                      )),
                ),
                const SizedBox(height: 16.0),

                //Redeem Drug
                const Text('Redeem Drug',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8.0),
                Obx(() => Column(
                      children:
                          invoiceController.medicines.map((medicine) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(medicine.name,
                            style: const TextStyle(fontSize: 14)),
                        Text(
                          currencyFormatter.format(medicine.sellPrice),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    );
                  }).toList(),
                    )),
                const SizedBox(height: 16.0),

                //Biaya
                const Text('Biaya',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8.0),
                Obx(() => Column(
                      children: invoiceController.fees.map((fee) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(fee.procedure,
                            style: const TextStyle(fontSize: 14)),
                        Text(
                          currencyFormatter.format(fee.price),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    );
                  }).toList(),
                    )),
                const SizedBox(height: 16.0),

                //Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    Obx(() => Text(
                        currencyFormatter.format(double.parse(
                            invoiceController.total.value)),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14))),
                  ],
                ),

                const SizedBox(height: 24.0),
              ],
            ),
          );
        }
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        decoration: const BoxDecoration(
          color: Color(0xFFF7FBF2),
        ),
        child: Row(
          children: [
           Expanded(
  child: OutlinedButton.icon(
    onPressed: () {
      invoiceController.downloadInvoicePDF(transaksi!.appointmentId!, share: true); // Aktifkan berbagi
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
                onPressed:  () {
                      invoiceController.downloadInvoicePDF(transaksi!.appointmentId!);
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
      ),
    );
  }
}