import 'package:get/get.dart';
import 'package:translator/translator.dart';

class HomeController extends GetxController {
  final translator = GoogleTranslator();
  var currentLanguage = 'id'.obs;
  var isLoading = false.obs;

  Future<String> translateText(String text, String targetLanguage) async {
    try {
      if (targetLanguage == currentLanguage.value) {
        return text;
      }

      var translation = await translator.translate(
        text,
        from: currentLanguage.value,
        to: targetLanguage,
      );
      return translation.text;
    } catch (e) {
      print('Error translating: $e');
      return text;
    }
  }

  Future<void> updateAllTranslations(
      Map<String, RxString> translations, String targetLanguage) async {
    var previousLanguage = currentLanguage.value;
    isLoading.value = true;

    try {
      // Membuat list of futures untuk semua terjemahan
      final futures = translations.entries
          .map((entry) => translateText(entry.value.value, targetLanguage))
          .toList();

      // Menjalankan semua terjemahan secara bersamaan
      final translatedTexts = await Future.wait(futures);

      // Mengupdate nilai setelah semua terjemahan selesai
      var index = 0;
      for (var entry in translations.entries) {
        translations[entry.key]?.value = translatedTexts[index];
        index++;
      }
      currentLanguage.value.toUpperCase();
      currentLanguage.value = targetLanguage;
    } catch (e) {
      print('Error updating translations: $e');
      currentLanguage.value = previousLanguage;
    } finally {
      isLoading.value = false;
    }
  }
}
