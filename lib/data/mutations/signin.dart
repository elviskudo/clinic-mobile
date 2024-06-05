import 'package:clinic/models/profile/profile_http_response.dart';
import 'package:clinic/services/http.dart';
import 'package:clinic/services/kv.dart';
import 'package:clinic/services/toast.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef SignInMutationFn = Mutation<void, DioException, Map<String, dynamic>>;

SignInMutationFn useSignIn<RecoveryType>(
  BuildContext context,
) {
  return useMutation<void, DioException, Map<String, dynamic>, RecoveryType>(
    'auth/signin',
    (reqBody) async {
      final res = await dio.post('/api/auth/signin', data: reqBody);

      if (res.statusCode == 201) {
        final result = ProfileHttpResponse.fromJson(res.data).data;
        final token = result?.token ?? '';
        final profile = result?.user;

        if (token.isNotEmpty && profile != null) {
          await KV.tokens.put('access_token', token);
          return;
        }
      }

      final errorCode = res.statusCode ?? 500;
      throw DioException(
        requestOptions: RequestOptions(),
        message: '[$errorCode] Failed to sign in!',
      );
    },
    refreshQueries: ['profile'],
    onData: (data, recoveryData) {
      context.go('/home');
    },
    onError: (error, recoveryData) {
      debugPrint(error.message);
      toast(context.tr('signin_error'));
    },
  );
}
