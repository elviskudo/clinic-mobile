import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    super.key,
    this.controller,
    this.textInputAction = TextInputAction.done,
    this.autofocus = false,
    this.readOnly = false,
    this.initialValue,
    this.enabled = true,
  });

  final TextEditingController? controller;

  final TextInputAction textInputAction;

  final String? initialValue;

  final bool autofocus;
  final bool enabled;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      enabled: enabled,
      readOnly: readOnly,
      initialValue: initialValue,
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'Your email address',
      ),
      validator: ValidationBuilder(requiredMessage: 'Email cannot be empty')
          .email('Please use a valid email')
          .build(),
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
    );
  }
}
