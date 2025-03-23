import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_denied_controller.dart';

class PaymentDeniedView extends GetView<PaymentDeniedController> {
  const PaymentDeniedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEF5350),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Prohibited/rejected icon with animation
                    const AnimatedRotateIcon(),
                    const SizedBox(height: 16),
                    FadeInItem(
                      delay: 200,
                      child: const Text(
                        "Payment Rejected",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeInItem(
                      delay: 400,
                      child: const Text(
                        "Your redeemed is rejected",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom action area
            GestureDetector(
              onTap: () {
                Get.back(); // Kembali ke halaman invoice
              },
              child: FadeInItem(
                delay: 600,
                child: Column(
                  children: [
                    const Text(
                      "Upload Ulang Bukti Transfer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Animasi Icon
class AnimatedRotateIcon extends StatefulWidget {
  const AnimatedRotateIcon({Key? key}) : super(key: key);

  @override
  State<AnimatedRotateIcon> createState() => _AnimatedRotateIconState();
}

class _AnimatedRotateIconState extends State<AnimatedRotateIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Durasi rotasi
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.repeat(); // Membuat animasi berulang
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Icon(
          Icons.not_interested,
          color: Color(0xFFEF5350),
          size: 40,
        ),
      ),
    );
  }
}


// Custom widget for delayed fade-in animations
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

class _FadeInItemState extends State<FadeInItem> with SingleTickerProviderStateMixin {
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

    // Add delay before starting the animation
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