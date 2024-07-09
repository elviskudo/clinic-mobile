import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/auth/hooks/use_signup.dart';
import 'package:clinic/widgets/forms/password_input.dart';
import 'package:clinic/widgets/submit_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../confirmation_password_input.dart';
import '../email_input.dart';
import '../name_input.dart';
import '../phone_number_input.dart';

class SignupForm extends HookWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final form = useSignup(context);

    return Form(
      key: form.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EmailInput(
            controller: form.emailCtrl,
            autofocus: true,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          NameInput(
            controller: form.nameCtrl,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          PhoneNumberInput(
            controller: form.phoneCtrl,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          PasswordInput(
            controller: form.passwordCtrl,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          ConfirmationPasswordInput(
            controller: form.confirmPassCtrl,
            relatedPasswordController: form.passwordCtrl,
            onSaved: (_) => form.submit(),
          ),
          gapH24,
          SubmitButton(
            onSubmit: form.submit,
            disabled: form.isLoading,
            loading: form.isLoading,
            child: Text(context.tr('signup')),
          ),
        ],
      ),
    );
  }
}
