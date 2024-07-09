import 'package:easy_localization/easy_localization.dart';
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
      decoration: InputDecoration(
        labelText: context.tr('name_field.label'),
        hintText: context.tr('name_field.placeholder'),
      ),
      textInputAction: textInputAction,
      keyboardType: TextInputType.name,
      validator: ValidationBuilder(localeName: context.locale.languageCode)
          .required(context.tr('name_field.empty'))
          .build(),
    );
  }
}
