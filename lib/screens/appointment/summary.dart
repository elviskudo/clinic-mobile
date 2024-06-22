import 'package:clinic/constants/sizes.dart';
import 'package:flutter/material.dart';

class AppointmentSummaryScreen extends StatelessWidget {
  const AppointmentSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(Sizes.p24),
        shrinkWrap: true,
        children: const [
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [],
            ),
          )
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p24,
              vertical: Sizes.p8,
            ),
            child: FilledButton(
              onPressed: () {},
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
