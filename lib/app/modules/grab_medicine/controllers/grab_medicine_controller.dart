import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:get/get.dart';

class GrabMedicineController extends GetxController {
  late String appointmentId;

  @override
  void onInit() {
    super.onInit();
    // Mengambil argumen (jika dikirim dari halaman sebelumnya)
    appointmentId = Get.arguments as String? ?? 'Unknown';
  }

  void goToHome() {
    // Pindah ke Home dan bersihkan semua rute sebelumnya
    Get.offAllNamed(Routes.HOME);
  }
}