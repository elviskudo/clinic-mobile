import 'package:flutter/material.dart';

class AccountPersonalDataScreen extends StatelessWidget {
  const AccountPersonalDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Data'),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('Personal Data'),
        ),
      ),
    );
  }
}
