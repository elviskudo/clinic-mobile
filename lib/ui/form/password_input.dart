import 'package:clinic/utils/regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PasswordInput extends HookWidget {
  const PasswordInput({
    super.key,
    required this.controller,
    this.textInputAction = TextInputAction.done,
    this.autofocus = false,
    this.enabled = true,
    this.onSaved,
  });

  final TextEditingController controller;
  final TextInputAction textInputAction;
  final bool autofocus;
  final bool enabled;
  final void Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    final obscure = useState(true);

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Your password',
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
      validator: ValidationBuilder(requiredMessage: 'Password cannot be empty')
          .minLength(8, 'Password must be at least 8 characters')
          .regExp(
            passwordRegex,
            'Password must be at least containing 1 lowercase, uppercase, number, and special character',
          )
          .build(),
      keyboardType: TextInputType.visiblePassword,
      textInputAction: textInputAction,
      onSaved: onSaved,
    );
  }
}
