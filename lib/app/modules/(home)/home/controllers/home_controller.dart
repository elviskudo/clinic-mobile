import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class HomeController extends GetxController {
  static const String LANGUAGE_KEY = 'selected_language';
  final translator = GoogleTranslator();
  var currentLanguage = 'id'.obs;
  var isLoading = false.obs;
  final isLoggedIn = false.obs;

  final translations = {
    'createAccount': 'Create an Account'.obs,
    'startDescription':
        'Start with make an account and then you can start to check your health anytime, anywhere!'
            .obs,
    'apple': 'Apple'.obs,
    'google': 'Google'.obs,
    'orByEmail': 'Or by email'.obs,
    'name': 'Name'.obs,
    'fullName': 'Your full name'.obs,
    'email': 'E-mail'.obs,
    'enterEmail': 'Enter your email'.obs,
    'phone': 'No. Telp'.obs,
    'enterPhone': 'Enter a phone number'.obs,
    'password': 'Password'.obs,
    'confirmPassword': 'Confirm Password'.obs,
    'agreeToTerms': 'I agree to the '.obs,
    'termsAndConditions': ' terms and conditions'.obs,
    'register': 'Register'.obs,
    'haveAccount': 'have an account yet? '.obs,
    // 'login': 'Login'.obs,
  };

  // Instance SharedPreferences

  @override
  void onInit() async {
    super.onInit();
    // Inisialisasi SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    // Mengambil bahasa yang tersimpan, default ke 'id' jika belum ada
    currentLanguage.value = prefs.getString(LANGUAGE_KEY) ?? 'id';
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
  }

  // Menyimpan bahasa yang dipilih
  Future<void> _saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(LANGUAGE_KEY, languageCode);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', false);
    isLoggedIn.value = false;
    await GoogleSignIn().signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

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

      await _saveLanguage(targetLanguage);
      currentLanguage.value = targetLanguage;
    } catch (e) {
      print('Error updating translations: $e');
      currentLanguage.value = previousLanguage;
    } finally {
      isLoading.value = false;
    }
  }
}