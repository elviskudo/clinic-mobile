import 'package:clinic/utils/regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:form_validator/form_validator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rearch/rearch.dart';

class ConfirmationPasswordInput extends RearchConsumer {
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
  Widget build(BuildContext context, WidgetHandle use) {
    final (obscure, setObscure) = use.state(true);

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Confirmation Password',
        hintText: 'Re-enter password',
        suffixIcon: GestureDetector(
          onTap: () {
            setObscure(!obscure);
          },
          child: PhosphorIcon(
            obscure
                ? PhosphorIcons.eye(PhosphorIconsStyle.duotone)
                : PhosphorIcons.eyeClosed(PhosphorIconsStyle.duotone),
          ),
        ),
      ),
      obscureText: obscure,
      validator: ValidationBuilder(
              requiredMessage: 'Confirmation Password cannot be empty')
          .minLength(8, 'Password must be at least 8 characters')
          .regExp(
            passwordRegex,
            'Password must be at least containing 1 lowercase, uppercase, number, and special character',
          )
          .add((str) => str != relatedPasswordController.text
              ? 'Confirmation password is not valid'
              : null)
          .build(),
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      onSaved: onSaved,
    );
  }
}
