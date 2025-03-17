import 'package:clinic_ai/app/modules/invoice/controllers/invoice_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:clinic_ai/models/fee_model.dart'; // Import model Fee
import 'package:clinic_ai/app/modules/(home)/redeemMedicine/controllers/redeem_medicine_controller.dart';

class InvoiceView extends StatelessWidget {
  const InvoiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      RedeemMedicineController controller = Get.find();
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
Get.put(InvoiceController());
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
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Belum Menunggu Pembayaran
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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

                  // Tujuan Transfer
                  const Text('Kode Transaksi',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4.0),
                  const Text('CMV0004', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 16.0),

                  // Transfer Via
                  const Text('Transfer Via',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4.0),
                  const Text('1441234512 - Bank Mandiri', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 16.0),

                  // Tanggal Transaksi
                  const Text('Tanggal Transaksi',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4.0),
                  const Text('27 Juni 2024', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 20.0),

                  // Waiting for Approval Button
                  Container(
                    width: double.infinity,
                    height: 48,
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFF35693E), width: 1),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF35693E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.file_download_outlined, color: Color(0xFF35693E)),
                          const SizedBox(width: 8),
                          const Text('Waiting for Approval ...',
                              style: TextStyle(color: Color(0xFF35693E), fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Symptoms
                  const Text('Symptoms',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4.0),
                  const Text('Lorem, ipsum, dolor, sit amet, consectetur, Egestas urna vitae',
                      style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 12.0),

                  // Symptom Descriptions
                  const Text('Symptom Descriptions',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4.0),
                  const Text(
                    'Lorem ipsum dolor sit amet consectetur. Egestas urna vitae in at posuere tellus ullamcorper bibendum. Volutpat varius velit augue vitae tellus risus.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20.0),

                  // AI Response
                  const Text('AI Response',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      'Lorem ipsum dolor sit amet consectetur. Gravida sit semper faucibus accumsan consequat et volutpat urna. Adipiscing eget aenean vitae rhoncus. Felis nullam tempor orci at purus lorem id quis at. Quam viverra lobortis gravida in in nulla nibh quis sit.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  //Redeem Drug
                  const Text('Redeem Drug', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8.0),

                  //Medication list with prices
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Paramex - 500gr', style: TextStyle(fontSize: 14)),
                      Text('Rp96.000', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Oskadon - 24 Strip', style: TextStyle(fontSize: 14)),
                      Text('Rp96.000', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  //Biaya
                  const Text('Biaya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8.0),

                  //Consultation Fee
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Consultation Fee', style: TextStyle(fontSize: 14)),
                      Text('Rp150.000', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  //Handling Fee
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Handling Fee', style: TextStyle(fontSize: 14)),
                      Text('Rp30.000', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  //Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('Rp372.000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),

                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
         
          Container(
        
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
                    label: const Text('Share', style: TextStyle(color: Color(0xFF35693E), fontWeight: FontWeight.w500)),
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
                    icon: const Icon(Icons.file_download_outlined, color: Color(0xFF35693E)),
                    label: const Text('Download', style: TextStyle(color: Color(0xFF35693E), fontWeight: FontWeight.w500)),
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
        ],
      ),
    );
  }
}