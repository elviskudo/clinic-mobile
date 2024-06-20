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

import '../services/auth.dart';

typedef ChangePasswordMutationFn
    = Mutation<void, DioException, Map<String, dynamic>>;

UseChangePassword useChangePassword(BuildContext context, WidgetRef ref) {
  final formKey = useMemoized(() => GlobalKey<FormState>());
  final passwordCtrl = useTextEditingController();
  final confirmPassCtrl = useTextEditingController();

  final passwordObscure = useState(true);
  final confirmPassObscure = useState(true);

  final mutation =
      useMutation<void, DioException, Map<String, dynamic>, dynamic>(
    'account/update_password',
    (data) async => ref.read(authServiceProvider).updatePassword(data),
    refreshQueries: ['account'],
    onMutate: (_) async {
      await showBusyDialog(context);
    },
    onData: (data, _) {
      if (context.canPop()) context.pop();
      context.go('/onboarding');
    },
    onError: (e, _) {
      if (context.canPop()) context.pop();
      context.replace('/account/credential');
      toast(context.tr('change_password_error'));
    },
  );

  return UseChangePassword(
    context: context,
    formKey: formKey,
    passwordCtrl: passwordCtrl,
    confirmPassCtrl: confirmPassCtrl,
    passwordObscure: passwordObscure,
    confirmPassObscure: confirmPassObscure,
    mutation: mutation,
  );
}

class UseChangePassword {
  const UseChangePassword({
    required this.context,
    required this.formKey,
    required this.passwordCtrl,
    required this.confirmPassCtrl,
    required ValueNotifier<bool> passwordObscure,
    required ValueNotifier<bool> confirmPassObscure,
    required ChangePasswordMutationFn mutation,
  })  : _passwordObscure = passwordObscure,
        _confirmPassObscure = confirmPassObscure,
        _mutation = mutation;

  final BuildContext context;

  final GlobalKey<FormState> formKey;

  final TextEditingController passwordCtrl;
  final TextEditingController confirmPassCtrl;

  final ValueNotifier<bool> _passwordObscure;
  final ValueNotifier<bool> _confirmPassObscure;

  final ChangePasswordMutationFn _mutation;

  String? handlePasswordValidation(String? val) {
    if ((val ?? '').isEmpty) {
      return context.tr('new_password_field.empty');
    } else if ((val ?? '').length < 8 || !passwordRegex.hasMatch(val ?? '')) {
      return context.tr('new_password_field.invalid');
    }
    return null;
  }

  String? handleConfirmPassValidation(String? val) {
    if ((val ?? '').isEmpty) {
      return context.tr('password_field.empty');
    } else if ((val ?? '').length < 8 || !passwordRegex.hasMatch(val ?? '')) {
      return context.tr('password_field.invalid');
    } else if ((val ?? '') != passwordCtrl.text) {
      return context.tr('confirmation_password_field.invalid');
    }
    return null;
  }

  bool get isObscuredPassword => _passwordObscure.value;
  bool get isObscuredConfirmPass => _confirmPassObscure.value;

  void handlePasswordObscure() {
    _passwordObscure.value = !isObscuredPassword;
  }

  void handleConfirmPassObscure() {
    _confirmPassObscure.value = !isObscuredConfirmPass;
  }

  bool get isValid => formKey.currentState!.validate();

  void reset() {
    formKey.currentState!.reset();
  }

  void handleSubmit() async {
    if (isValid) {
      await _mutation.mutate(
        {
          'password': passwordCtrl.text,
          'confirmPassword': confirmPassCtrl.text,
        },
      );
      reset();
    }
  }

  bool get isLoading => _mutation.isMutating;
}
