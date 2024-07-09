import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    super.key,
    required this.controller,
    this.textInputAction = TextInputAction.done,
    this.autofocus = false,
    this.enabled = true,
  });

  final TextEditingController controller;
  final TextInputAction textInputAction;
  final bool autofocus;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      enabled: enabled,
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: context.tr('email_field.placeholder'),
      ),
      validator: ValidationBuilder(localeName: context.locale.languageCode)
          .required(context.tr('email_field.empty'))
          .email(context.tr('email_field.invalid'))
          .build(),
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
    );
  }
}
