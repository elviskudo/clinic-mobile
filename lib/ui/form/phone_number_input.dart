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
      inputDecoration: const InputDecoration(
        labelText: 'Phone Number',
        hintText: 'Your phone number',
      ),
      validator:
          ValidationBuilder(requiredMessage: 'Phone number cannot be empty')
              .phone('Phone number is not valid')
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
