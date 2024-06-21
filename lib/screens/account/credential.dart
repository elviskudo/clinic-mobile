import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/auth/auth.dart';
import 'package:clinic/widgets/submit_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AccountCredentialScreen extends StatelessWidget {
  const AccountCredentialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('account'))),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Sizes.p24),
          child: _ChangePasswordForm(),
        ),
      ),
    );
  }
}

class _ChangePasswordForm extends HookConsumerWidget {
  const _ChangePasswordForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useChangePassword(context, ref);
    final account = useAccountQuery(context, ref);

    return Form(
      key: form.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            readOnly: false,
            enableInteractiveSelection: false,
            enabled: false,
            initialValue: account.data?.email,
            autofocus: false,
            decoration: InputDecoration(
              label: const Text('Email*'),
              hintText: context.tr('email_field.placeholder'),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          gapH16,
          TextFormField(
            autofocus: false,
            controller: form.passwordCtrl,
            decoration: InputDecoration(
              label: Text('${context.tr("new_password_field.label")}*'),
              helperMaxLines: 5,
              helperText: context.tr('new_password_field.criteria'),
              hintText: context.tr('new_password_field.placeholder'),
              suffixIcon: GestureDetector(
                onTap: form.handlePasswordObscure,
                child: PhosphorIcon(
                  form.isObscuredPassword
                      ? PhosphorIcons.eye(PhosphorIconsStyle.duotone)
                      : PhosphorIcons.eyeClosed(
                          PhosphorIconsStyle.duotone,
                        ),
                ),
              ),
            ),
            obscureText: form.isObscuredPassword,
            validator: form.handlePasswordValidation,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          TextFormField(
            controller: form.confirmPassCtrl,
            obscureText: form.isObscuredConfirmPass,
            decoration: InputDecoration(
              label: Text(
                '${context.tr('confirmation_password_field.label')}*',
              ),
              hintText: context.tr('password_field.placeholder'),
              suffixIcon: GestureDetector(
                onTap: form.handleConfirmPassObscure,
                child: PhosphorIcon(
                  form.isObscuredConfirmPass
                      ? PhosphorIcons.eye(PhosphorIconsStyle.duotone)
                      : PhosphorIcons.eyeClosed(
                          PhosphorIconsStyle.duotone,
                        ),
                ),
              ),
            ),
            validator: form.handleConfirmPassValidation,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => form.handleSubmit(),
          ),
          gapH24,
          SubmitButton(
            onSubmit: form.handleSubmit,
            disabled: form.isLoading,
            loading: form.isLoading,
            child: const Text('Submit'),
          )
        ],
      ),
    );
  }
}
