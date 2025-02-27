import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/redeem_medicine_controller.dart';

class RedeemMedicineView extends GetView<RedeemMedicineController> {
  const RedeemMedicineView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RedeemMedicineView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RedeemMedicineView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
