import 'package:clinic/constants/sizes.dart';
import 'package:flutter/material.dart';

class AppointmentSymptomScreen extends StatelessWidget {
  const AppointmentSymptomScreen({super.key});

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
    );
  }
}
