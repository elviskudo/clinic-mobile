import 'package:clinic/constants/sizes.dart';
import 'package:clinic/widgets/forms/auth/change_password_form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AccountCredentialPage extends StatelessWidget {
  const AccountCredentialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('account'))),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Sizes.p24),
          child: ChangePasswordForm(),
        ),
      ),
    );
  }
}
