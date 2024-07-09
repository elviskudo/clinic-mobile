import 'package:clinic/features/auth/auth_repo.dart';
import 'package:clinic/services/toast.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

typedef ChangePasswordMutationFn
    = Mutation<void, DioException, Map<String, dynamic>>;

UseChangePassword useChangePassword(BuildContext context) {
  final formKey = useMemoized(() => GlobalKey<FormState>());
  final passwordCtrl = useTextEditingController();
  final confirmPassCtrl = useTextEditingController();

  final mutation =
      useMutation<void, DioException, Map<String, dynamic>, dynamic>(
    'change_password',
    (json) async => await AuthRepository().changePassword(json),
    refreshQueries: ['account'],
    onData: (data, _) {
      toast(context.tr('new_password_succeed'));
      context.go('/onboarding');
    },
    onError: (e, _) {
      toast(context.tr('new_password_error'));
      context.replace('/account/credential');
      toast(context.tr('change_password_error'));
    },
  );

  return UseChangePassword(
    context: context,
    formKey: formKey,
    passwordCtrl: passwordCtrl,
    confirmPassCtrl: confirmPassCtrl,
    mutation: mutation,
  );
}

class UseChangePassword {
  const UseChangePassword({
    required this.context,
    required this.formKey,
    required this.passwordCtrl,
    required this.confirmPassCtrl,
    required ChangePasswordMutationFn mutation,
  }) : _mutation = mutation;

  final BuildContext context;

  final GlobalKey<FormState> formKey;

  final TextEditingController passwordCtrl, confirmPassCtrl;

  final ChangePasswordMutationFn _mutation;

  void submit() async {
    if (formKey.currentState!.validate()) {
      await _mutation.mutate(
        {
          'password': passwordCtrl.text,
          'confirmPassword': confirmPassCtrl.text,
        },
      );
      formKey.currentState!.reset();
    }
  }

  bool get isLoading => _mutation.isMutating;
}
