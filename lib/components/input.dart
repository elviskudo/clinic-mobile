// custom_input.dart
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool isPassword;
  final bool isPhoneNumber;
  final VoidCallback? onToggleVisibility;
  final bool? passwordVisible;
  final String? prefixText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomInput({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.isPassword = false,
    this.isPhoneNumber = false,
    this.onToggleVisibility,
    this.passwordVisible,
    this.prefixText,
    this.keyboardType,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? (passwordVisible ?? true) : false,
      keyboardType: keyboardType ?? TextInputType.text,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixText: prefixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  passwordVisible ?? true
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
      ),
    );
  }
}
