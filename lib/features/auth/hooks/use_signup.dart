import 'package:clinic/constants/regex.dart';
import 'package:clinic/services/toast.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../models/account.dart';
import '../services/auth.dart';

typedef SignUpMutationFn
    = Mutation<Account, DioException, Map<String, dynamic>>;

UseSignUp useSignUp(BuildContext context, WidgetRef ref) {
  final formKey = useMemoized(() => GlobalKey<FormState>());
  final nameCtrl = useTextEditingController();
  final emailCtrl = useTextEditingController();
  final phoneCtrl = useTextEditingController();
  final passwordCtrl = useTextEditingController();
  final confirmPassCtrl = useTextEditingController();

  final phone = useState(PhoneNumber(isoCode: 'ID'));
  final phoneError = useState<String?>(null);
  final passwordObscure = useState(true);
  final confirmPassObscure = useState(true);

  final mutation =
      useMutation<Account, DioException, Map<String, dynamic>, dynamic>(
    'auth/signup',
    ref.read(authServiceProvider).signUp,
    refreshQueries: ['account'],
    onMutate: (_) async {
      // await showBusyDialog(context);
    },
    onData: (data, _) {
      // if (context.canPop()) context.pop();
      context.go('/verification');
    },
    onError: (e, _) {
      // if (context.canPop()) context.pop();
      context.replace('/signup');
      toast(context.tr('signup_error'));
    },
  );

  return UseSignUp(
    context: context,
    formKey: formKey,
    nameCtrl: nameCtrl,
    emailCtrl: emailCtrl,
    phoneCtrl: phoneCtrl,
    passwordCtrl: passwordCtrl,
    confirmPassCtrl: confirmPassCtrl,
    passwordObscure: passwordObscure,
    confirmPassObscure: confirmPassObscure,
    phone: phone,
    phoneError: phoneError,
    mutation: mutation,
  );
}

class UseSignUp {
  const UseSignUp({
    required this.context,
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.passwordCtrl,
    required this.confirmPassCtrl,
    required ValueNotifier<bool> passwordObscure,
    required ValueNotifier<bool> confirmPassObscure,
    required ValueNotifier<PhoneNumber> phone,
    required ValueNotifier<String?> phoneError,
    required SignUpMutationFn mutation,
  })  : _passwordObscure = passwordObscure,
        _confirmPassObscure = confirmPassObscure,
        _phone = phone,
        _phoneError = phoneError,
        _mutation = mutation;

  final BuildContext context;

  final GlobalKey<FormState> formKey;

  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController confirmPassCtrl;

  final ValueNotifier<bool> _passwordObscure;
  final ValueNotifier<bool> _confirmPassObscure;
  final ValueNotifier<PhoneNumber> _phone;
  final ValueNotifier<String?> _phoneError;

  final SignUpMutationFn _mutation;

  String? handleNameValidation(String? value) {
    return (value ?? '').isEmpty ? context.tr('name_field.empty') : null;
  }

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
    } else if ((val ?? '').length < 8 || !passwordRegex.hasMatch(val ?? '')) {
      return context.tr('password_field.invalid');
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

  PhoneNumber get phone => _phone.value;
  String get _phoneStr => _phone.value.parseNumber();
  String? get phoneErr => _phoneError.value;

  void handlePhoneChange(PhoneNumber val) {
    if (val.parseNumber().isEmpty) {
      _phoneError.value = context.tr('phone_field.empty');
    } else {
      _phoneError.value = null;
    }
    _phone.value = val;
  }

  void handlePhoneValidation(bool isValidated) {
    if (!isValidated) {
      _phoneError.value = context.tr('phone_field.invalid');
    } else {
      _phoneError.value = null;
    }
  }

  bool get isValid =>
      formKey.currentState!.validate() && (_phoneError.value ?? '').isEmpty;

  void reset() {
    formKey.currentState!.reset();
  }

  void handleSubmit() async {
    if (isValid) {
      await _mutation.mutate(
        {
          'fullname': nameCtrl.text,
          'email': emailCtrl.text,
          'phone_number': '+62$_phoneStr',
          'password': passwordCtrl.text,
        },
      );
      reset();
    }
  }

  bool get isLoading => _mutation.isMutating;
}
