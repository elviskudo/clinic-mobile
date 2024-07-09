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

UseSignin useSignin(BuildContext context) {
  final formKey = useMemoized(() => GlobalKey<FormState>());

  final emailCtrl = useTextEditingController();
  final passwordCtrl = useTextEditingController();

  final mutation =
      useMutation<AuthDTO, DioException, Map<String, dynamic>, dynamic>(
    'signin',
    (json) async => await AuthRepository().signUp(json),
    refreshQueries: ['auth_cred'],
    onData: (data, _) {
      context.go('/home');
    },
    onError: (e, _) {
      context.replace('/signin');
      toast(context.tr('signin_error'));
    },
  );

  return UseSignin(
    formKey: formKey,
    emailCtrl: emailCtrl,
    passwordCtrl: passwordCtrl,
    mutation: mutation,
  );
}

class UseSignin {
  const UseSignin({
    required this.formKey,
    required this.emailCtrl,
    required this.passwordCtrl,
    required Mutation<AuthDTO, DioException, Map<String, dynamic>> mutation,
  }) : _mutation = mutation;

  final GlobalKey<FormState> formKey;

  final Mutation<AuthDTO, DioException, Map<String, dynamic>> _mutation;

  final TextEditingController emailCtrl, passwordCtrl;

  bool get isLoading => _mutation.isMutating;

  void submit() async {
    if (formKey.currentState!.validate()) {
      await _mutation.mutate(
        {
          'email': emailCtrl.text,
          'password': passwordCtrl.text,
        },
      );
      formKey.currentState!.reset();
    }
  }
}
