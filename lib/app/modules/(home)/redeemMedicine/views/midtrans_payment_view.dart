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

    // =================================================================
    // SOLUSI ABSOLUT: KITA SADAP URL DARI WEBVIEW LANGSUNG
    // =================================================================
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print("🌐 [WEBVIEW URL] Membuka: $url");
            _checkUrlForSuccess(url);
          },
          onUrlChange: (UrlChange change) {
            final url = change.url ?? '';
            _checkUrlForSuccess(url);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));

    // Timer hanya dijadikan cadangan darurat (Fallback)
    _startBackupPolling();
  }

  // FUNGSI SADAP: Jika ada kata "settlement" atau "capture", langsung tutup!
  void _checkUrlForSuccess(String url) {
    if (url.contains('transaction_status=settlement') ||
        url.contains('transaction_status=capture')) {
      print("🎯 [WEBVIEW] URL LUNAS TERDETEKSI! MENGHANCURKAN WEBVIEW...");
      _triggerSuccessRedirect();
    }
  }

  // FUNGSI EKSEKUTOR (Hanya bisa dipanggil 1x)
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
      print("Error saat redirect: $e");
    }
  }

  // TIMER CADANGAN (Diperlambat agar tidak membebani Emulator)
  void _startBackupPolling() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      if (_isRedirecting) return;

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('accessToken') ?? '';

        // Hapus timeout yang bikin crash, biarkan http berjalan normal
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
            print("🚀 [BACKUP] STATUS 7 DITEMUKAN DARI API!");
            _triggerSuccessRedirect();
          }
        }
      } catch (e) {
        // Abaikan jika emulator gagal connect internet
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
            _timer?.cancel();
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
