import 'package:clinic/widgets/auth/auth_view_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthViewLayout(
      body: Center(
        child: Text(
          context.tr('verification'),
        ),
      ),
    );
  }
}
