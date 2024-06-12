import 'package:clinic/providers/profile.dart';
import 'package:clinic/services/http.dart';
import 'package:clinic/services/kv.dart';
import 'package:clinic/widgets/modal_dialog_busy.dart';
import 'package:dio/dio.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Mutation<void, DioException, dynamic> useSignOut(
  BuildContext context, {
  required WidgetRef ref,
}) {
  final mutation = useMutation<void, DioException, void, dynamic>(
    'auth/signin',
    (_) async {
      final res = await dio.post('/api/users/logout');
      if (res.statusCode == 201 || res.statusCode == 200) {
        await KV.tokens.delete('access_token');
      }
    },
    refreshQueries: ['profile'],
    onMutate: (_) async {
      await showBusyDialog(context);
    },
    onData: (data, recoveryData) {
      context.go('/onboarding');
      if (context.canPop()) {
        context.pop();
      }
      ref.read(profileNotifierProvider.notifier).set(null);
    },
  );

  return mutation;
}
