import 'package:clinic/constants/regex.dart';
import 'package:clinic/services/toast.dart';
import 'package:clinic/widgets/modals/modal_dialog_busy.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/account.dart';
import '../services/auth.dart';

typedef SignInMutationFn
    = Mutation<Account, DioException, Map<String, dynamic>>;

UseSignInForm useSignIn(BuildContext context, WidgetRef ref) {
  final formKey = useMemoized(() => GlobalKey<FormState>());
  final emailController = useTextEditingController();
  final passwordController = useTextEditingController();
  final passwordObscure = useState(true);

  final mutation =
      useMutation<Account, DioException, Map<String, dynamic>, dynamic>(
    'auth/signin',
    (data) async => ref.read(authServiceProvider).signIn(data),
    refreshQueries: ['account'],
    onMutate: (_) async {
      await showBusyDialog(context);
    },
    onData: (data, _) {
      if (context.canPop()) context.pop();
      context.go('/');
    },
    onError: (e, _) {
      if (context.canPop()) context.pop();
      context.replace('/signin');
      toast(context.tr('signin_error'));
    },
  );

  return UseSignInForm(
    context,
    formKey: formKey,
    emailController: emailController,
    passwordController: passwordController,
    passwordObscure: passwordObscure,
    mutation: mutation,
  );
}

class UseSignInForm {
  const UseSignInForm(
    this.context, {
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required ValueNotifier<bool> passwordObscure,
    required SignInMutationFn mutation,
  })  : _mutation = mutation,
        _passwordObscure = passwordObscure;

  final BuildContext context;

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueNotifier<bool> _passwordObscure;

  final SignInMutationFn _mutation;

  bool get isObscuredPassword => _passwordObscure.value;

  String? handleEmailValidation(String? val) {
    if ((val ?? '').isEmpty) {
      return context.tr('email_field.empty');
    } else if (!emailRegex.hasMatch(val ?? '')) {
      return context.tr('email_field.invalid');
    }
    return null;
  }

  String? handlePasswordValidation(String? val) {
    if ((val ?? '').isEmpty) {
      return context.tr('password_field.empty');
    }
    return null;
  }

  void handlePasswordObscure() {
    _passwordObscure.value = !isObscuredPassword;
  }

  bool get isValid => formKey.currentState!.validate();

  void reset() {
    formKey.currentState!.reset();
  }

  void handleSubmit() async {
    if (isValid) {
      await _mutation.mutate(
        {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );
      reset();
    }
  }

  bool get isLoading => _mutation.isMutating;
}
