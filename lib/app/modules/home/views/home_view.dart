import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  // Data translations ada di view
  final translations = {
    'welcome': 'Selamat Datang'.obs,
    'description': 'Ini adalah aplikasi penerjemah'.obs,
    'buttonText': 'Tekan Disini'.obs,
    'footer': 'Dibuat dengan Flutter'.obs,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(translations['welcome']!.value)),
        centerTitle: true,
        actions: [
          Obx(
            () => controller.isLoading.value
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  )
                : PopupMenuButton(
                    icon: const Icon(Icons.language),
                    onSelected: (String language) {
                      // Memanggil fungsi update di controller dengan mengirim translations
                      controller.updateAllTranslations(translations, language);
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem(
                          value: 'en',
                          child: Text('English'),
                        ),
                        const PopupMenuItem(
                          value: 'es',
                          child: Text('Español'),
                        ),
                        const PopupMenuItem(
                          value: 'id',
                          child: Text('Indonesia'),
                        ),
                      ];
                    },
                  ),
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
              onPressed: () {},
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