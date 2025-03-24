import 'package:clinic_ai/app/modules/(home)/(appoinment)/appointment/controllers/appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/captureAppointment/controllers/capture_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/scheduleAppointment/controllers/schedule_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/symptomAppointment/controllers/symptom_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/invoice/controllers/invoice_controller.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/payment_success_controller.dart';

class PaymentSuccessView extends GetView<PaymentSuccessController> {
  const PaymentSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ambil data dari Get.arguments
    final Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
    final String qrCodeData = args['qr_code'] ?? 'Data QR Code Kosong';
    final String patientName =
        args['patient_name'] ?? 'Nama Pasien Tidak Tersedia';
    final scheduleController = Get.put(ScheduleAppointmentController());
    final appointmentController = Get.find<AppointmentController>();
    Get.put(BarcodeAppointmentController());
    final barcodeController = Get.find<BarcodeAppointmentController>();
    final captureController = Get.find<CaptureAppointmentController>();
    final symptompController = Get.find<SymptomAppointmentController>();

    return Scaffold(
      backgroundColor: const Color(0xFF2E7D41),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animasi Centang
                    AnimatedCheckmark(),

                    const SizedBox(height: 16),

                    FadeInItem(
                      delay: 200,
                      child: const Text(
                        "Payment Successfully",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeInItem(
                      delay: 400,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "You have successfully redeemed your medicine, don't forget to pick up your medicine at the pharmacy, get well soon!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Tampilkan QR Code dan Nama Pasien dalam FadeInItem yang sama
                    FadeInItem(
                      delay: 600,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Container untuk membatasi ukuran QR Code dan memberikan padding
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: QrImageView(
                              data: qrCodeData,
                              version: QrVersions.auto,
                              size: 120,
                              foregroundColor: const Color(0xFF2E7D41),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Tampilkan Nama Pasien dengan gaya yang lebih baik
                          Text(
                            "$qrCodeData - $patientName", // Format yang BENAR
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FadeInItem(
              delay: 900,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      appointmentController.resetAppointmentCreated();
                      scheduleController.resetForm();
                      barcodeController.reset();
                      captureController.reset();
                      symptompController.reset();
                      Get.find<InvoiceController>()
                          .clearDataTambahan(); // Tambahkan ini
                      Get.find<InvoiceController>().isUploadComplete.value =
                          false;
                      Get.find<InvoiceController>().clearUploadState();
                      Get.offAllNamed(Routes.HOME);
                    },
                    child: const Text(
                      "Home",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Animasi Centang yang Lebih Dinamis
class AnimatedCheckmark extends StatefulWidget {
  const AnimatedCheckmark({Key? key}) : super(key: key);

  @override
  State<AnimatedCheckmark> createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _moveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Durasi Animasi
    );

    // Animasi Scale (Membuat Ikon Membesar)
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutBack,
      ),
    );

    // Animasi Move (Membuat Ikon Naik)
    _moveAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuint,
      ),
    );

    _controller.forward(); // Mulai Animasi
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_moveAnimation.value), // Efek Naik
          child: Transform.scale(
            scale: _scaleAnimation.value, // Efek Membesar
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Color(0xFF2E7D41),
                size: 40,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Widget FadeInItem (Tidak Perlu Diubah)
class FadeInItem extends StatefulWidget {
  final Widget child;
  final int delay;

  const FadeInItem({
    Key? key,
    required this.child,
    required this.delay,
  }) : super(key: key);

  @override
  State<FadeInItem> createState() => _FadeInItemState();
}

class _FadeInItemState extends State<FadeInItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }
}
