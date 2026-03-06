import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/grab_medicine_controller.dart';

class GrabMedicineView extends GetView<GrabMedicineController> {
  const GrabMedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller jika belum ada
    Get.put(GrabMedicineController());

    return Scaffold(
      // Warna background biru persis seperti desain
      backgroundColor: const Color(0xFF3498DB), 
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ==============================
                    // ANIMASI CENTANG (Diambil dari Payment Success)
                    // ==============================
                    const AnimatedCheckmarkBlue(),

                    const SizedBox(height: 24),

                    // ==============================
                    // TEKS JUDUL (Pake animasi FadeInItem)
                    // ==============================
                    FadeInItem(
                      delay: 200,
                      child: Text(
                        "Your Medicine ready to\nconsume",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.2, // Jarak antar baris
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ==============================
                    // TEKS DESKRIPSI (Pake animasi FadeInItem)
                    // ==============================
                    FadeInItem(
                      delay: 400,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "You have successfully grabbed your medicine,\nPlease consume it and get well soon!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.9), // Agak transparan dikit
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ==============================
            // TOMBOL HOME DI BAWAH
            // ==============================
            FadeInItem(
              delay: 600,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => controller.goToHome(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Home",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Garis indikator swipe khas iOS
                  const SizedBox(height: 8),
                  Container(
                    width: 130,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
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

// ==============================================================
// KOMPONEN ANIMASI (Digabung di sini agar tidak perlu import ribet)
// ==============================================================

// Animasi Centang Versi Biru
class AnimatedCheckmarkBlue extends StatefulWidget {
  const AnimatedCheckmarkBlue({Key? key}) : super(key: key);

  @override
  State<AnimatedCheckmarkBlue> createState() => _AnimatedCheckmarkBlueState();
}

class _AnimatedCheckmarkBlueState extends State<AnimatedCheckmarkBlue>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _moveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Durasi Animasi
    );

    // Animasi Scale (Membuat Ikon Membesar)
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut, // Efek memantul
      ),
    );

    // Animasi Move (Membuat Ikon Naik)
    _moveAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
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
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ]
              ),
              child: const Icon(
                Icons.check,
                color: Color(0xFF3498DB), // Ikon centang warnanya biru
                size: 50,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Widget FadeInItem (Untuk Teks yang muncul perlahan)
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
  late Animation<double> _moveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _moveAnimation = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutQuad,
      ),
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Transform.translate(
            offset: Offset(0, _moveAnimation.value),
            child: widget.child,
          ),
        );
      },
    );
  }
}