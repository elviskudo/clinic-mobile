import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/auth/hooks/use_change_password.dart';
import 'package:clinic/features/auth/hooks/use_credential.dart';
import 'package:clinic/widgets/forms/confirmation_password_input.dart';
import 'package:clinic/widgets/forms/email_input.dart';
import 'package:clinic/widgets/forms/password_input.dart';
import 'package:clinic/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChangePasswordForm extends HookWidget {
  const ChangePasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final form = useChangePassword(context);
    final cred = useCredential(context);

    if (cred.isLoading) return const Center(child: CircularProgressIndicator());

    return Form(
      key: form.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EmailInput(
            enabled: false,
            initialValue: cred.data?.email ?? 'john@acme.inc',
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
            child: const Text('Submit'),
          )
        ],
      ),
    );
  }
}
