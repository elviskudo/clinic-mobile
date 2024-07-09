import 'package:clinic/features/user/user_repo.dart';
import 'package:dio/dio.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';

Query<List<String>, DioException> useUncompleteProfile(BuildContext context) {
  return useQuery<List<String>, DioException>(
    'uncomplete_profile',
    () async => await UserRepository().getUncompleteProfile(context),
  );
}
