import 'package:clinic_ai/app/modules/(home)/redeemMedicine/controllers/redeem_medicine_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RedeemMedicineView extends GetView<RedeemMedicineController> {
  const RedeemMedicineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already (for preview purposes)
    if (!Get.isRegistered<RedeemMedicineController>()) {
      Get.put(RedeemMedicineController());
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
          'Reedem Medicine',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Response
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
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Obx(() => Text(
                  controller.aiResponse.value,
                  style: TextStyle(fontSize: 14),
                ),
                ),
              ),
            ),

            // Divider
            Container(
              height: 4,
              color: Colors.grey.shade200,
            ),

            // Medicine
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

            // Payment Method
            GestureDetector(
              onTap: () {
                _showBankBottomSheet(context, controller);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text( // Gunakan Text widget untuk icon dompet
                      '\u{1F4B3}', // Dompet
                      style: const TextStyle(
                        fontSize: 20, // Sesuaikan ukuran dengan teks
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const Spacer(),
                    Obx(() => Text(
                      controller.selectedBankName.value, // Tampilkan nama bank yang dipilih
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),
                    )),
                    Icon( // Gunakan Icon widget untuk icon panah
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),

            // Divider
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.shade200,
            ),

            // Payment Details
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
                      _buildPaymentRow('Product Subtotal', controller.productSubtotal.value),
                      _buildPaymentRow('Consultation Fee', controller.consultationFee.value),
                      _buildPaymentRow('Handling Fee', controller.handlingFee.value),
                      const SizedBox(height: 4),
                      _buildPaymentRow('Total', controller.total.value, isTotal: true),
                    ],
                  )),
                ],
              ),
            ),

            // Pay Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF35693E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Action when Pay button is pressed
                  },
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

            // Bottom indicator line
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
    );
  }

  // Widget for medicine card
  Widget _buildMedicineCard(Map<String, String> medicine) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFD4E8D1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: NetworkImage(medicine['image']!),
            child: ClipOval(
              child: Image.network(
                medicine['image']!,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.medical_services, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine['name']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${medicine['category']!}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  '${medicine['detail']!}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Rp${medicine['price']!}',
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

  // Widget for payment details row
  Widget _buildPaymentRow(String label, String value, {bool isTotal = false}) {
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
            'Rp$value',
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFF2E7D32) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Function to show the bank list bottom sheet
  void _showBankBottomSheet(BuildContext context, RedeemMedicineController controller) {
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
                        subtitle: Text('Account Number: ${bank.accountNumber ?? 'N/A'}'),
                        trailing: Radio<String>(
                          value: bank.id ?? '',
                          groupValue: controller.selectedBankId.value,
                          onChanged: (String? value) {
                            controller.selectBank(value ?? '', bank.name ?? '');
                            Get.back(); // Tutup BottomSheet setelah memilih bank
                          },
                          activeColor: Colors.green, // Warna saat terpilih
                        ),
                        onTap: (){
                           controller.selectBank(bank.id ?? '', bank.name ?? '');
                            Get.back();
                        },
                      ));
                    }
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