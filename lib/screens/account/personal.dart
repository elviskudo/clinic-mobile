import 'package:flutter/material.dart';

class AccountPersonalDataScreen extends StatelessWidget {
  const AccountPersonalDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Personal Data'),
        ),
      ),
    );
  }
}
