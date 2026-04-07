import 'dart:async';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentSuccessController extends GetxController {
  final supabase = Supabase.instance.client;
  Timer? _timer;
  String appointmentIdPart = '';

  @override
  void onInit() {
    super.onInit();

    // 1. Ambil data dari arguments
    final args = Get.arguments;

    // 2. Lakukan pengecekan yang lebih aman agar tidak gagal
    if (args != null &&
        args is Map<String, dynamic> &&
        args.containsKey('qr_code')) {
      // Ambil teks asli dari qr_code (Misal: "BA7F29F9")
      String rawQr = args['qr_code'].toString();

      // Konversi ke huruf kecil untuk dicocokkan dengan ID database
      appointmentIdPart = rawQr.toLowerCase();

      print(
          "🚀 [PASIEN] Inisialisasi Mata-mata untuk ID berawalan: '$appointmentIdPart'");

      // 3. Langsung nyalakan fungsi pengintai!
      _startListeningForDoctorScan();
    } else {
      print(
          "⚠️ [PASIEN] Argumen QR Code tidak ditemukan, mata-mata dibatalkan.");
    }
  }

  void _startListeningForDoctorScan() {
    print("🔍 [PASIEN] Timer dimulai: Menunggu dokter mengubah status ke 8...");

    // Mengecek database setiap 2 detik
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        // ==============================================================
        // FIX SAKTI: BYPASS ERROR UUID POSTGRESQL!
        // Kita hanya tarik data yang statusnya >= 7, lalu filter di Dart
        // ==============================================================
        final response = await supabase
            .from('appointments')
            .select('id, status')
            .gte('status', 7); // Tarik yang statusnya 7 atau 8

        if (response != null) {
          for (var data in response) {
            String fullId = data['id'].toString().toLowerCase();

            // Cocokkan apakah ID dari database ini berawalan sama dengan QR Code di layar
            if (fullId.startsWith(appointmentIdPart)) {
              int status = int.tryParse(data['status'].toString()) ?? 0;

              // Tampilkan progress di log
              print("📊 [PASIEN] Status DB Saat Ini: $status");

              // ✨ JIKA DOKTER SUDAH SCAN DAN MENGUBAH STATUS KE 8 (COMPLETED) ✨
              if (status == 8) {
                timer.cancel(); // Matikan mata-mata agar tidak jalan terus
                print(
                    "✅ [PASIEN] DOKTER TELAH SCAN! HP Pasien pindah otomatis ke Grab Medicine...");

                // Jeda sedikit agar tidak terlalu kaget
                await Future.delayed(const Duration(milliseconds: 500));

                // Pindahkan layar HP Pasien secara otomatis ke Layar Biru!
                Get.offAllNamed(Routes.GRAB_MEDICINE, arguments: data['id']);
                return; // Hentikan loop
              }
            }
          }
        }
      } catch (e) {
        // Abaikan error internet agar tetap mencoba lagi
        print("📡 [PASIEN] Pengecekan database gagal: $e");
      }
    });
  }

  @override
  void onClose() {
    print("🛑 [PASIEN] Layar ditutup, Timer mata-mata dimatikan.");
    _timer?.cancel();
    super.onClose();
  }
}
