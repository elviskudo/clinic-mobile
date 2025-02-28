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
        onPressed: () => _showDrugDialog(context),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Drugs'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: controller.drugs.length,
                itemBuilder: (context, index) {
                  final drug = controller.drugs[index];
                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ExpansionTile(
                      title: Text(drug.name),
                      subtitle: Text(drug.kind),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Text(drug.name[0]),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Description: ${drug.description}'),
                              SizedBox(height: 8),
                              Text('Company: ${drug.companyName}'),
                              SizedBox(height: 8),
                              Text('Dosis: ${drug.dosis}'),
                              SizedBox(height: 8),
                              Text('Stock: ${drug.stock}'),
                              SizedBox(height: 8),
                              Text('Buy Price: ${drug.buyPrice}'),
                              SizedBox(height: 8),
                              Text('Sell Price: ${drug.sellPrice}'),
                              SizedBox(height: 8),
                              Text('Is Halal: ${drug.isHalal ? 'Yes' : 'No'}'),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
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
                  );
                },
              ),
      ),
    );
  }

  void _showDrugDialog(BuildContext context, {Drug? drug}) {
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
                decoration: InputDecoration(labelText: 'Drug Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              TextField(
                controller: companyNameController,
                decoration: InputDecoration(labelText: 'Company Name'),
              ),
              TextField(
                controller: stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: buyPriceController,
                decoration: InputDecoration(labelText: 'Buy Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: sellPriceController,
                decoration: InputDecoration(labelText: 'Sell Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: dosisController,
                decoration: InputDecoration(labelText: 'Dosis'),
              ),
              TextField(
                controller: kindController,
                decoration: InputDecoration(labelText: 'Kind'),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Is Halal: '),
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
            child: Text('Cancel'),
          ),
          Obx(() => TextButton(
                onPressed: isFormValid.value
                    ? () {
                        final DateTime now = DateTime.now();
                        if (drug == null) {
                          final newDrug = Drug(
                            id: Uuid().v4(),
                            name: nameController.text.trim(),
                            description: descriptionController.text.trim(),
                            companyName: companyNameController.text.trim(),
                            stock: int.parse(stockController.text.trim()),
                            buyPrice: int.parse(buyPriceController.text.trim()),
                            sellPrice:
                                int.parse(sellPriceController.text.trim()),
                            dosis: dosisController.text.trim(),
                            kind: kindController.text.trim(),
                            isHalal: isHalalController.value,
                            createdAt: now.toIso8601String(),
                            updatedAt: now,
                          );
                          Get.find<DrugAdminController>().addDrug(newDrug);
                        } else {
                          drug.name = nameController.text.trim();
                          drug.description = descriptionController.text.trim();
                          drug.companyName = companyNameController.text.trim();
                          drug.stock = int.parse(stockController.text.trim());
                          drug.buyPrice =
                              int.parse(buyPriceController.text.trim());
                          drug.sellPrice =
                              int.parse(sellPriceController.text.trim());
                          drug.dosis = dosisController.text.trim();
                          drug.kind = kindController.text.trim();
                          drug.isHalal = isHalalController.value;
                          drug.updatedAt = now;
                          Get.find<DrugAdminController>().updateDrug(drug);
                        }
                        Get.back();
                      }
                    : null,
                child: Text('Save'),
              )),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(String id) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Drug'),
        content: Text('Are you sure you want to delete this drug?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteDrug(id);
              Get.back();
            },
            child: Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}
