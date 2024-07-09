import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberInput extends HookWidget {
  const PhoneNumberInput({
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
    return InternationalPhoneNumberInput(
      countries: const ['ID'],
      autoFocus: autofocus,
      isEnabled: enabled,
      onInputChanged: (val) {},
      ignoreBlank: false,
      textFieldController: controller,
      formatInput: true,
      inputDecoration: InputDecoration(
        labelText: context.tr('phone_field.label'),
        hintText: context.tr('phone_field.placeholder'),
      ),
      validator: ValidationBuilder(localeName: context.locale.languageCode)
          .phone(context.tr('phone_field.invalid'))
          .required(context.tr('phone_field.empty'))
          .build(),
      keyboardType: const TextInputType.numberWithOptions(
        signed: true,
        decimal: true,
      ),
      inputBorder: const OutlineInputBorder(),
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        useBottomSheetSafeArea: true,
      ),
      keyboardAction: textInputAction,
    );
  }
}
