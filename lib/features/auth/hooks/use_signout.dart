import 'package:clinic/features/auth/auth_repo.dart';
import 'package:clinic/widgets/modals/modal_dialog_busy.dart';
import 'package:dio/dio.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Mutation<void, DioException, dynamic> useSignout(BuildContext context) {
  final mutation = useMutation<void, DioException, void, dynamic>(
    'signout',
    (_) async => await AuthRepository().signOut(),
    refreshQueries: ['auth_cred'],
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
