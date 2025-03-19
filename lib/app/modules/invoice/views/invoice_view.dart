import 'package:clinic_ai/app/modules/invoice/controllers/invoice_controller.dart';
import 'package:clinic_ai/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:clinic_ai/models/fee_model.dart';
import 'package:clinic_ai/models/bank_model.dart';
import 'package:image_picker/image_picker.dart';
// Import library Supabase
import 'package:supabase_flutter/supabase_flutter.dart';

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
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      // Panggil fungsi upload dari invoiceController
      invoiceController.uploadFileToCloudinary(image, transaksi!.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final DateFormat dateFormatter = DateFormat('dd MMMM yyyy');
    final DateFormat timeFormatter = DateFormat('HH:mm');

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
        } else if (invoiceController.appointment.value != null) {
          final appointment = invoiceController.appointment.value!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 24),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Belum',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'Menunggu pembayaran',
                              style: TextStyle(color: Colors.red[800]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                Text(
                    invoiceController.bank.value != null
                        ? '${invoiceController.bank.value?.accountNumber} - ${invoiceController.bank.value?.name}'
                        : 'N/A',
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 16.0),

                // Tanggal Transaksi
                const Text('Tanggal Transaksi',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4.0),
                Text(
                    transaksi?.createdAt != null
                        ? dateFormatter
                            .format(transaksi!.createdAt!.toLocal())
                        : 'N/A',
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 16.0),

                // Tanggal Berobat
                const Text('Tanggal Berobat',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4.0),
                Text(
                  invoiceController.scheduleDate.value != null &&
                          invoiceController.scheduleTime.value != null
                      ? dateFormatter.format(invoiceController
                              .scheduleDate.value!.scheduleDate
                              .toLocal()) +
                          ', ' +
                          invoiceController.scheduleTime.value!.scheduleTime
                      : 'N/A',
                  style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 20.0),
                Obx(() {
                  return Container(
                    width: double.infinity,
                    height: 48,
                    // margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border:
                          Border.all(color: const Color(0xFF35693E), width: 1),
                    ),
                    child: TextButton(
                      onPressed: invoiceController.isUploadComplete.value ||
                              invoiceController.isLoading.value
                          ? null
                          :  () {
                              // Panggil fungsi untuk menyimpan catatan dokter
                              _showImageSourceDialog();
                            },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF35693E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          invoiceController.isLoading.value
                              ? Container(
                                  width: 24,
                                  height: 24,
                                  padding: const EdgeInsets.all(2.0),
                                  child: const CircularProgressIndicator(
                                    color: Color(0xFF35693E),
                                    strokeWidth: 3,
                                  ))
                              : const Icon(Icons.file_upload_outlined,
                                  color: Color(0xFF35693E)),
                           SizedBox(width: 8),
                          Text(
                              invoiceController.isUploadComplete.value
                                  ? 'Menunggu Persetujuan'
                                  : 'Upload Bukti Transfer',
                              style: TextStyle(
                                  color: Color(0xFF35693E), fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                }),
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
                Text(appointment.symptomDescription ?? 'N/A',
                    style: const TextStyle(fontSize: 14)),
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
                  child: Text(
                    appointment.aiResponse ?? 'Belum ada response',
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.start, // Tambahkan ini
                  ),
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
                              style: const TextStyle(fontSize: 14)),
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
                              style: const TextStyle(fontSize: 14)),
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
                        currencyFormatter.format(
                            double.parse(invoiceController.total.value)),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14))),
                  ],
                ),

                const SizedBox(height: 24.0),
                // Submit Button
                // Container(
                //   width: double.infinity,
                //   height: 48,
                //   // margin: const EdgeInsets.symmetric(horizontal: 16.0),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(24),
                //     color: const Color(0xFF35693E),
                //   ),
                //   child: TextButton(
                //     onPressed:invoiceController.isLoading.value ? null :  () {
                //       // Panggil fungsi untuk menyimpan catatan dokter
                //      print("data id transc $transaksi?.id");
                //      invoiceController.setLoading(true);
                //       invoiceController.saveFileInfo(transaksi!.id!);
                //      Future.delayed(const Duration(seconds: 3), () {
                //       invoiceController.setLoading(false);
                //      });
                      
                //       print("submit ya");
                //     },
                //     style: TextButton.styleFrom(
                //       foregroundColor: Colors.white,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(24),
                //       ),
                //     ),
                //     child:  invoiceController.isLoading.value ? const SizedBox(
                //                     width: 24,
                //                     height: 24,
                //                     // padding: EdgeInsets.all(2.0),
                //                     child: CircularProgressIndicator(
                //                       color: Colors.white,
                //                       strokeWidth: 3,
                //                     ))
                //                   :const Text(
                //       'Submit',
                //       style: TextStyle(fontSize: 16),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 24.0),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('Data tidak ditemukan'),
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
                onPressed: () {},
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
                onPressed: () {},
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