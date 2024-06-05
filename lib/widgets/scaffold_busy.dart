import 'package:flutter/material.dart';

class ScaffoldBusy extends StatelessWidget {
  const ScaffoldBusy({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
