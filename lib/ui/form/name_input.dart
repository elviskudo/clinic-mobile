import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class NameInput extends StatelessWidget {
  const NameInput({
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
      controller: controller,
      autofocus: autofocus,
      decoration: const InputDecoration(
        labelText: 'Full Name',
        hintText: 'Your full name',
      ),
      textInputAction: textInputAction,
      keyboardType: TextInputType.name,
      validator: ValidationBuilder(requiredMessage: 'Full name cannot be empty')
          .build(),
    );
  }
}
