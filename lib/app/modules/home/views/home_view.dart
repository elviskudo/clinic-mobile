import 'package:clinic_ai/components/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  // Data translations ada di view
  final translations = {
    'welcome': 'Selamat Datang'.obs,
    'description': 'Ini adalah aplikasi penerjemah'.obs,
    'buttonText': 'logout'.obs,
    'footer': 'Dibuat dengan Flutter'.obs,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(translations['welcome']!.value)),
        centerTitle: true,
        actions: [
          LanguageSelector(
            controller: controller,
            translationData: translations,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  translations['description']!.value,
                  style: const TextStyle(fontSize: 20),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async => await controller.logout(),
              child: Obx(() => Text(translations['buttonText']!.value)),
            ),
            const SizedBox(height: 20),
            Obx(() => Text(translations['footer']!.value)),
          ],
        ),
      ),
    );
  }
}
