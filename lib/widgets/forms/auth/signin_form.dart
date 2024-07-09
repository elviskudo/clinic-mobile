import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/auth/auth_dto.dart';
import 'package:clinic/features/auth/hooks/use_signin.dart';
import 'package:clinic/widgets/forms/password_input.dart';
import 'package:clinic/widgets/submit_button.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../email_input.dart';

typedef SigninMutation = Mutation<AuthDTO, DioException, Map<String, dynamic>>;

class SigninForm extends HookWidget {
  const SigninForm({super.key});

  @override
  Widget build(BuildContext context) {
    final form = useSignin(context);

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
          PasswordInput(
            controller: form.passwordCtrl,
            onSaved: (_) => form.submit(),
          ),
          gapH24,
          SubmitButton(
            onSubmit: () => form.submit(),
            disabled: form.isLoading,
            loading: form.isLoading,
            child: Text(context.tr('signin')),
          ),
        ],
      ),
    );
  }
}
