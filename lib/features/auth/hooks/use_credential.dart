import 'dart:async';

import 'package:clinic/features/auth/auth_dto.dart';
import 'package:dio/dio.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth_repo.dart';

Query<AuthDTO?, DioException> useCredential(
  BuildContext context, {
  FutureOr<void> Function(AuthDTO?)? onData,
}) {
  return useQuery<AuthDTO?, DioException>(
    'auth_cred',
    () async => await AuthRepository().getCredential(),
    onData: onData,
    onError: (e) {
      context.go('/onboarding');
    },
  );
}
