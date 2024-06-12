import 'package:clinic/models/profile/profile.dart';
import 'package:clinic/services/http.dart';
import 'package:clinic/services/kv.dart';
import 'package:clinic/services/toast.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

typedef SignUpMutationFn
    = Mutation<Profile?, DioException, Map<String, dynamic>>;

SignUpMutationProps useSignUp<RecoveryType>(BuildContext context) {
  final key = useMemoized(() => GlobalKey<FormState>());

  final name = useTextEditingController.fromValue(TextEditingValue.empty);

  final email = useTextEditingController.fromValue(TextEditingValue.empty);

  final phone = useTextEditingController.fromValue(TextEditingValue.empty);
  final phoneNumber = useState(PhoneNumber(isoCode: 'ID'));
  final phoneErrorMessage = useState<String?>(null);

  final password = useTextEditingController.fromValue(TextEditingValue.empty);
  final passwordObscure = useState(true);

  final confirmationPassword = useTextEditingController.fromValue(
    TextEditingValue.empty,
  );
  final confirmationPasswordObscure = useState(true);

  final mutation =
      useMutation<Profile?, DioException, Map<String, dynamic>, RecoveryType>(
    'auth/signup',
    (reqBody) async {
      final res = await dio.post('/api/auth/register', data: reqBody);

      if (res.statusCode == 201 || res.statusCode == 200) {
        final token = res.data['data']['token'] ?? '';

        if (token.isNotEmpty) {
          await KV.tokens.put('access_token', token);
          return Profile.fromJson(res.data['data']['user']);
        }
      }

      return null;
    },
    refreshQueries: ['profile'],
    onData: (data, recoveryData) {
      context.go('/verification');
    },
    onError: (e, recoveryData) {
      debugPrint(
        '[signup_mutation] ${e.response!.statusCode} - ${e.response!.data.toString()}',
      );
      toast(context.tr('signup_error'));
      context.replace('/signup');
    },
  );

  return SignUpMutationProps(
    key: key,
    name: name,
    email: email,
    phone: phone,
    phoneNumber: phoneNumber,
    phoneErrorMessage: phoneErrorMessage,
    password: password,
    passwordObscure: passwordObscure,
    confirmationPassword: confirmationPassword,
    confirmationPasswordObscure: confirmationPasswordObscure,
    mutation: mutation,
  );
}

class SignUpMutationProps {
  SignUpMutationProps({
    required this.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.phoneNumber,
    required this.phoneErrorMessage,
    required this.password,
    required this.passwordObscure,
    required this.confirmationPassword,
    required this.confirmationPasswordObscure,
    required SignUpMutationFn mutation,
  }) : _mutation = mutation;

  final GlobalKey<FormState> key;

  final TextEditingController name;
  final TextEditingController email;

  final TextEditingController phone;
  final ValueNotifier<PhoneNumber> phoneNumber;
  final ValueNotifier<String?> phoneErrorMessage;

  final TextEditingController password;
  final ValueNotifier<bool> passwordObscure;
  final TextEditingController confirmationPassword;
  final ValueNotifier<bool> confirmationPasswordObscure;

  final SignUpMutationFn _mutation;

  bool get isLoading => _mutation.isMutating;

  String get phoneError => phoneErrorMessage.value ?? '';
  bool get isValidPhone => phoneError.isEmpty;

  Future<Profile?> handleSubmit() async {
    if (key.currentState!.validate() && isValidPhone) {
      await _mutation.mutate(
        {
          'fullname': name.text,
          'email': email.text,
          'phone_number': '+62${phoneNumber.value.parseNumber()}',
          'password': password.text,
        },
      );
    }

    key.currentState!.reset();
    return null;
  }
}
