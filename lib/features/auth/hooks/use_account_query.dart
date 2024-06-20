import 'dart:async';

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
  FutureOr<void> Function(Account?)? onData,
}) {
  return useQuery<Account?, DioException>(
    'account',
    ref.read(authServiceProvider).getAccount,
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
