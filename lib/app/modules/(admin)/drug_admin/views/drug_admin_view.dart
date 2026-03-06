import 'package:clinic_ai/models/drug_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../controllers/drug_admin_controller.dart';

class DrugAdminView extends GetView<DrugAdminController> {
  const DrugAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            Colors.green.shade200, // Warna hijau muda seperti di foto
        onPressed: () => _showDrugDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Drugs',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.only(
                    bottom: 80), // Jarak bawah agar tidak tertutup FAB
                itemCount: controller.drugs.length,
                itemBuilder: (context, index) {
                  final drug = controller.drugs[index];
                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1), // Border abu-abu
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Theme(
                      // Menghilangkan garis atas/bawah bawaan saat ExpansionTile terbuka
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        title: Text(
                          drug.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        subtitle: Text(
                          drug.kind,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 14),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          foregroundColor: Colors.white,
                          child: Text(
                            drug.name.isNotEmpty
                                ? drug.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Garis pemisah halus antara header dan detail
                                Divider(color: Colors.grey.shade200),
                                const SizedBox(height: 8),
                                _buildDetailItem(
                                    'Description', drug.description),
                                _buildDetailItem('Company', drug.companyName),
                                _buildDetailItem('Dosis', drug.dosis),
                                _buildDetailItem(
                                    'Stock', drug.stock.toString()),
                                _buildDetailItem(
                                    'Buy Price', 'Rp ${drug.buyPrice}'),
                                _buildDetailItem(
                                    'Sell Price', 'Rp ${drug.sellPrice}'),
                                _buildDetailItem(
                                    'Halal', drug.isHalal ? 'Yes' : 'No'),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      tooltip: 'edit',
                                      onPressed: () =>
                                          _showDrugDialog(context, drug: drug),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      tooltip: 'delete',
                                      onPressed: () =>
                                          _showDeleteConfirmation(drug.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  // Widget kecil untuk merapikan baris teks detail
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                  color: Colors.grey.shade700, fontWeight: FontWeight.w500),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _showDrugDialog(BuildContext context, {Drug? drug}) {
    // ... [Isi fungsi _showDrugDialog sama dengan kode kamu sebelumnya] ...
    final nameController = TextEditingController(text: drug?.name);
    final descriptionController =
        TextEditingController(text: drug?.description);
    final companyNameController =
        TextEditingController(text: drug?.companyName);
    final stockController =
        TextEditingController(text: drug?.stock.toString() ?? '0');
    final buyPriceController =
        TextEditingController(text: drug?.buyPrice.toString() ?? '0');
    final sellPriceController =
        TextEditingController(text: drug?.sellPrice.toString() ?? '0');
    final dosisController = TextEditingController(text: drug?.dosis);
    final kindController = TextEditingController(text: drug?.kind);
    final isHalalController = RxBool(drug?.isHalal ?? true);

    final isFormValid = RxBool(false);

    void validateForm() {
      isFormValid.value = nameController.text.trim().isNotEmpty &&
          descriptionController.text.trim().isNotEmpty &&
          companyNameController.text.trim().isNotEmpty &&
          stockController.text.trim().isNotEmpty &&
          buyPriceController.text.trim().isNotEmpty &&
          sellPriceController.text.trim().isNotEmpty &&
          dosisController.text.trim().isNotEmpty &&
          kindController.text.trim().isNotEmpty;
    }

    nameController.addListener(validateForm);
    descriptionController.addListener(validateForm);
    companyNameController.addListener(validateForm);
    stockController.addListener(validateForm);
    buyPriceController.addListener(validateForm);
    sellPriceController.addListener(validateForm);
    dosisController.addListener(validateForm);
    kindController.addListener(validateForm);

    Get.dialog(
      AlertDialog(
        title: Text(drug == null ? 'Add Drug' : 'Edit Drug'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Drug Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              TextField(
                controller: companyNameController,
                decoration: const InputDecoration(labelText: 'Company Name'),
              ),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: buyPriceController,
                decoration: const InputDecoration(labelText: 'Buy Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: sellPriceController,
                decoration: const InputDecoration(labelText: 'Sell Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: dosisController,
                decoration: const InputDecoration(labelText: 'Dosis'),
              ),
              TextField(
                controller: kindController,
                decoration: const InputDecoration(labelText: 'Kind'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Is Halal: '),
                  Obx(() => Switch(
                        value: isHalalController.value,
                        onChanged: (value) {
                          isHalalController.value = value;
                        },
                      )),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => TextButton(
                onPressed: isFormValid.value
                    ? () {
                        final DateTime now = DateTime.now();
                        final stockVal =
                            int.tryParse(stockController.text.trim()) ?? 0;
                        final buyPriceVal =
                            double.tryParse(buyPriceController.text.trim()) ??
                                0.0;
                        final sellPriceVal =
                            double.tryParse(sellPriceController.text.trim()) ??
                                0.0;

                        if (drug == null) {
                          final newDrug = Drug(
                            id: const Uuid().v4(),
                            name: nameController.text.trim(),
                            description: descriptionController.text.trim(),
                            companyName: companyNameController.text.trim(),
                            stock: stockVal,
                            buyPrice: buyPriceVal,
                            sellPrice: sellPriceVal,
                            dosis: dosisController.text.trim(),
                            kind: kindController.text.trim(),
                            isHalal: isHalalController.value,
                            createdAt: now.toIso8601String(),
                            updatedAt: now,
                          );
                          controller.addDrug(newDrug);
                        } else {
                          drug.name = nameController.text.trim();
                          drug.description = descriptionController.text.trim();
                          drug.companyName = companyNameController.text.trim();
                          drug.stock = stockVal;
                          drug.buyPrice = buyPriceVal;
                          drug.sellPrice = sellPriceVal;
                          drug.dosis = dosisController.text.trim();
                          drug.kind = kindController.text.trim();
                          drug.isHalal = isHalalController.value;
                          drug.updatedAt = now;

                          controller.updateDrug(drug);
                        }
                        Get.back();
                      }
                    : null,
                child: const Text('Save'),
              )),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String id) {
    // ... [Isi fungsi _showDeleteConfirmation sama dengan kode kamu sebelumnya] ...
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Drug'),
        content: const Text('Are you sure you want to delete this drug?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteDrug(id);
              Get.back();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
