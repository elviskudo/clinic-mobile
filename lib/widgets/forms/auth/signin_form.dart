import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/auth/auth_dto.dart';
import 'package:clinic/features/auth/auth_repo.dart';
import 'package:clinic/services/toast.dart';
import 'package:clinic/widgets/forms/password_input.dart';
import 'package:clinic/widgets/submit_button.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../email_input.dart';

typedef SigninMutation = Mutation<AuthDTO, DioException, Map<String, dynamic>>;

class SigninForm extends HookWidget {
  const SigninForm({super.key});

  void submit(GlobalKey<FormState> formKey, SigninMutation mutation) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      await mutation.mutate({});
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final signin =
        useMutation<AuthDTO, DioException, Map<String, dynamic>, dynamic>(
      'signin',
      (json) async => await AuthRepository().signIn(json),
      refreshQueries: ['auth_cred'],
      onData: (data, _) {
        context.go('/');
      },
      onError: (e, _) {
        context.replace('/signin');
        toast(context.tr('signin_error'));
      },
    );

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EmailInput(
            controller: emailController,
            autofocus: true,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          PasswordInput(
            controller: passwordController,
            onSaved: (_) => submit(formKey, signin),
          ),
          gapH24,
          SubmitButton(
            onSubmit: () => submit(formKey, signin),
            disabled: signin.isMutating,
            loading: signin.isMutating,
            child: Text(context.tr('signin')),
          ),
        ],
      ),
    );
  }
}
