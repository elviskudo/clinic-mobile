import 'package:flutter/material.dart';

class PlaceholderScaffold extends StatelessWidget {
  const PlaceholderScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/clinic_ai.png',
          width: 80,
          height: 80,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
