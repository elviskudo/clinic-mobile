import 'package:clinic/services/toast.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../auth_dto.dart';
import '../auth_repo.dart';

UseSignup useSignup(BuildContext context) {
  final formKey = useMemoized(() => GlobalKey<FormState>());

  final emailCtrl = useTextEditingController();
  final nameCtrl = useTextEditingController();
  final phoneCtrl = useTextEditingController();
  final passwordCtrl = useTextEditingController();
  final confirmPassCtrl = useTextEditingController();

  final mutation =
      useMutation<AuthDTO, DioException, Map<String, dynamic>, dynamic>(
    'signup',
    (json) async => await AuthRepository().signUp(json),
    refreshQueries: ['auth_cred'],
    onData: (data, _) {
      context.go('/verification');
    },
    onError: (e, _) {
      context.replace('/signup');
      toast(context.tr('signup_error'));
    },
  );

  return UseSignup(
    formKey: formKey,
    confirmPassCtrl: confirmPassCtrl,
    emailCtrl: emailCtrl,
    nameCtrl: nameCtrl,
    passwordCtrl: passwordCtrl,
    phoneCtrl: phoneCtrl,
    mutation: mutation,
  );
}

class UseSignup {
  const UseSignup({
    required this.formKey,
    required this.confirmPassCtrl,
    required this.emailCtrl,
    required this.nameCtrl,
    required this.passwordCtrl,
    required this.phoneCtrl,
    required Mutation<AuthDTO, DioException, Map<String, dynamic>> mutation,
  }) : _mutation = mutation;

  final GlobalKey<FormState> formKey;

  final Mutation<AuthDTO, DioException, Map<String, dynamic>> _mutation;

  final TextEditingController confirmPassCtrl,
      emailCtrl,
      nameCtrl,
      passwordCtrl,
      phoneCtrl;

  bool get isLoading => _mutation.isMutating;

  void submit() async {
    if (formKey.currentState!.validate()) {
      await _mutation.mutate(
        {
          'fullname': nameCtrl.text,
          'email': emailCtrl.text,
          'phone_number': '+62${phoneCtrl.text}'.replaceAll('-', ''),
          'password': passwordCtrl.text,
        },
      );
      formKey.currentState!.reset();
    }
  }
}
