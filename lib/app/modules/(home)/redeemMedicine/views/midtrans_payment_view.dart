import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';

class MidtransPaymentView extends StatefulWidget {
  final String paymentUrl;
  final String appointmentId;

  const MidtransPaymentView({
    Key? key,
    required this.paymentUrl,
    required this.appointmentId,
  }) : super(key: key);

  @override
  State<MidtransPaymentView> createState() => _MidtransPaymentViewState();
}

class _MidtransPaymentViewState extends State<MidtransPaymentView> {
  late WebViewController _controller;
  Timer? _timer;
  bool _isRedirecting = false; // Kunci gembok absolut
  final String baseUrl = 'https://be-clinic-rx7y.vercel.app';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print("🌐 [WEBVIEW URL] Membuka: $url");
            _checkUrlStatus(url);
          },
          onUrlChange: (UrlChange change) {
            final url = change.url ?? '';
            _checkUrlStatus(url);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));

    // Timer hanya dijadikan cadangan darurat (Fallback) untuk mengecek status lunas
    _startBackupPolling();
  }

  // FUNGSI SADAP: Mengecek URL apakah Lunas atau Gagal
  void _checkUrlStatus(String url) {
    if (_isRedirecting) return; // Cegah pemanggilan berulang

    // 1. CEK JIKA PEMBAYARAN SUKSES
    if (url.contains('transaction_status=settlement') ||
        url.contains('transaction_status=capture')) {
      print("🎯 [WEBVIEW] URL LUNAS TERDETEKSI! MENGHANCURKAN WEBVIEW...");
      _triggerSuccessRedirect();
    }
    // 2. CEK JIKA PEMBAYARAN GAGAL ATAU DI-CANCEL
    // Menangkap berbagai kemungkinan url gagal dari Midtrans
    else if (url.contains('transaction_status=deny') ||
            url.contains('transaction_status=cancel') ||
            url.contains('transaction_status=expire') ||
            url.contains(
                'error') || // Biasanya muncul bila terjadi error midtrans
            url.contains('/v2/error') // URL error spesifik snap midtrans
        ) {
      print("⚠️ [WEBVIEW] PEMBAYARAN GAGAL / CANCEL TERDETEKSI!");
      _triggerFailedRedirect();
    }
  }

  // FUNGSI EKSEKUTOR JIKA SUKSES
  Future<void> _triggerSuccessRedirect() async {
    if (_isRedirecting) return;
    _isRedirecting = true;
    _timer?.cancel();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('userName') ?? 'Pasien Clinic AI';

      if (mounted) {
        Get.offAllNamed(Routes.PAYMENT_SUCCESS, arguments: {
          'qr_code': widget.appointmentId.substring(0, 8).toUpperCase(),
          'patient_name': userName,
        });
      }
    } catch (e) {
      print("Error saat redirect sukses: $e");
    }
  }

  // FUNGSI EKSEKUTOR JIKA GAGAL / CANCEL
  void _triggerFailedRedirect() {
    if (_isRedirecting) return;
    _isRedirecting = true;
    _timer?.cancel();

    print("↩️ [WEBVIEW] KEMBALI KE REDEEM MEDICINE...");

    if (mounted) {
      // Menutup WebView dan kembali ke halaman Redeem Medicine (atau Invoice)
      Get.back();

      // Tampilkan Notifikasi Gagal
      Get.snackbar(
        "Pembayaran Dibatalkan",
        "Pembayaran gagal atau dibatalkan. Silakan pilih metode pembayaran lain.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        duration: const Duration(seconds: 4),
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red[900]),
      );
    }
  }

  // TIMER CADANGAN (Hanya untuk mengecek apakah tiba-tiba lunas di database)
  void _startBackupPolling() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      if (_isRedirecting) return;

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('accessToken') ?? '';

        final response = await http.get(
          Uri.parse(
              '$baseUrl/appointments/${widget.appointmentId}/medical-report'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);
          var rawData = decoded['data'] ?? decoded;
          int status = int.tryParse(rawData['status'].toString()) ?? 0;

          if (status == 7) {
            // 7 = Get Medicine (Artinya pembayaran dianggap sah oleh backend)
            print("🚀 [BACKUP] STATUS 7 DITEMUKAN DARI API!");
            _triggerSuccessRedirect();
          }
        }
      } catch (e) {
        // Abaikan
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran"),
        backgroundColor: const Color(0xff35693E),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Jika tombol X manual ditekan, kita anggap itu cancel
            _triggerFailedRedirect();
          },
        ),
      ),
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
