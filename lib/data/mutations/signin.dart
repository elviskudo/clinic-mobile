import 'package:clinic/models/profile/profile_http_response.dart';
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

typedef SignInMutationFn = Mutation<void, DioException, Map<String, dynamic>>;

SignInMutationProps useSignIn<RecoveryType>(BuildContext context) {
  final key = useMemoized(() => GlobalKey<FormState>());

  final email = useTextEditingController.fromValue(TextEditingValue.empty);

  final password = useTextEditingController.fromValue(TextEditingValue.empty);
  final passwordObscure = useState(true);

  final mutation =
      useMutation<void, DioException, Map<String, dynamic>, RecoveryType>(
    'auth/signin',
    (reqBody) async {
      final res = await dio.post('/api/auth/signin', data: reqBody);

      if (res.statusCode == 201 || res.statusCode == 200) {
        final result = ProfileHttpResponse.fromJson(res.data).data;
        final token = result?.token ?? '';
        final profile = result?.user;

        if (token.isNotEmpty && profile != null) {
          await KV.tokens.put('access_token', token);
          return;
        }
      }
    },
    refreshQueries: ['profile'],
    onData: (data, recoveryData) {
      context.go('/');
    },
    onError: (e, recoveryData) {
      debugPrint(
        '[signin_mutation] ${e.response!.statusCode} - ${e.response!.data.toString()}',
      );
      context.replace('/signin');
      toast(context.tr('signin_error'));
    },
  );

  return SignInMutationProps(
      key: key,
      email: email,
      password: password,
      passwordObscure: passwordObscure,
      mutation: mutation);
}

class SignInMutationProps {
  SignInMutationProps({
    required this.key,
    required this.email,
    required this.password,
    required this.passwordObscure,
    required this.mutation,
  });

  final GlobalKey<FormState> key;

  final TextEditingController email;
  final TextEditingController password;
  final ValueNotifier<bool> passwordObscure;

  final SignInMutationFn mutation;

  bool get isLoading => mutation.isMutating;

  void handleSubmit() async {
    if (key.currentState!.validate()) {
      await mutation.mutate(
        {
          'email': email.text,
          'password': password.text,
        },
      );
    }

    key.currentState!.reset();
  }
}
