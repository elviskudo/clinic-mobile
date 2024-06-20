import 'package:clinic/widgets/modals/modal_dialog_busy.dart';
import 'package:dio/dio.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../services/auth.dart';

Mutation<void, DioException, dynamic> useSignOut(
  BuildContext context,
  WidgetRef ref,
) {
  final mutation = useMutation<void, DioException, void, dynamic>(
    'auth/signout',
    (_) async => await ref.read(authServiceProvider).signOut(),
    refreshQueries: ['account'],
    onMutate: (_) async {
      await showBusyDialog(context);
    },
    onData: (data, recoveryData) {
      if (context.canPop()) context.pop();
      context.go('/onboarding');
    },
    onError: (e, _) {
      if (context.canPop()) context.pop();
    },
  );

  return mutation;
}
