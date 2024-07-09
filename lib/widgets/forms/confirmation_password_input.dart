import 'package:clinic/constants/regex.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ConfirmationPasswordInput extends HookWidget {
  const ConfirmationPasswordInput({
    super.key,
    required this.controller,
    this.textInputAction = TextInputAction.done,
    required this.relatedPasswordController,
    this.onSaved,
    this.autofocus = false,
    this.enabled = true,
  });

  final TextEditingController controller;
  final TextEditingController relatedPasswordController;
  final TextInputAction textInputAction;
  final void Function(String?)? onSaved;
  final bool autofocus;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final obscure = useState(true);

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: context.tr('confirmation_password_field.label'),
        hintText: context.tr('password_field.placeholder'),
        suffixIcon: GestureDetector(
          onTap: () {
            obscure.value = !obscure.value;
          },
          child: PhosphorIcon(
            obscure.value
                ? PhosphorIcons.eye(PhosphorIconsStyle.duotone)
                : PhosphorIcons.eyeClosed(PhosphorIconsStyle.duotone),
          ),
        ),
      ),
      obscureText: obscure.value,
      validator: ValidationBuilder(localeName: context.locale.languageCode)
          .required(context.tr('password_field.empty'))
          .minLength(8)
          .regExp(passwordRegex, context.tr('password_field.invalid'))
          .add((str) => str != relatedPasswordController.text
              ? context.tr('confirmation_password_field.invalid')
              : null)
          .build(),
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      onSaved: onSaved,
    );
  }
}
