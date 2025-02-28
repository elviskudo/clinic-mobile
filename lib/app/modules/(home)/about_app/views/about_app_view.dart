import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/about_app_controller.dart';

class AboutAppView extends GetView<AboutAppController> {
  const AboutAppView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AboutAppView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AboutAppView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
