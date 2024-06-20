import 'package:clinic/features/clinic/clinic.dart';
import 'package:clinic/features/clinic/services/clinic.dart';
import 'package:dio/dio.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/account.dart';
import '../services/auth.dart';

Query<Account?, DioException> useAccountQuery(
  BuildContext context,
  WidgetRef ref, {
  void Function(Account?)? onData,
}) {
  return useQuery<Account?, DioException>(
    'account',
    () async {
      final account = ref.read(authServiceProvider).getAccount();
      if (account != null) await _getCurrentClinic(context, ref);
      return account;
    },
    refreshConfig: RefreshConfig.withConstantDefaults(
      refreshOnMount: true,
      staleDuration: const Duration(minutes: 15),
    ),
    jsonConfig: JsonConfig(
      toJson: (account) => account?.toJson() ?? {},
      fromJson: Account.fromJson,
    ),
    onData: (account) {
      if (onData != null) {
        onData(account);
      }
    },
    onError: (e) {
      context.go('/onboarding');
    },
  );
}

Future<void> _getCurrentClinic(BuildContext context, WidgetRef ref) async {
  await QueryClient.of(context).fetchQuery(
    'clinic/current_active',
    () async => ref.read(clinicServiceProvider).getCurrentClinic(),
    refreshConfig: RefreshConfig.withConstantDefaults(
      refreshOnMount: true,
      staleDuration: const Duration(minutes: 30),
    ),
    jsonConfig: JsonConfig(
      toJson: (clinic) => clinic.toJson(),
      fromJson: Clinic.fromJson,
    ),
  );
}
