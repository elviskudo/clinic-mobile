import 'package:clinic/models/profile/profile.dart';
import 'package:clinic/models/profile/profile_http_response.dart';
import 'package:clinic/providers/profile.dart';
import 'package:clinic/services/http.dart';
import 'package:dio/dio.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Query<Profile?, DioException> useProfile(
  BuildContext context, {
  required WidgetRef ref,
  void Function(Profile?)? onData,
}) {
  return useQuery<Profile?, DioException>(
    'profile',
    () async {
      final res = await dio.get('/api/users/profiles');

      if (res.statusCode == 200) {
        final result = ProfileHttpResponse.fromJson(res.data);
        final profile = result.data?.user;
        return profile;
      }

      return null;
    },
    refreshConfig: RefreshConfig.withConstantDefaults(
      refreshOnMount: true,
      staleDuration: const Duration(minutes: 15),
    ),
    jsonConfig: JsonConfig(
      toJson: (profile) => profile?.toJson() ?? {},
      fromJson: Profile.fromJson,
    ),
    initial: ref.watch(profileNotifierProvider),
    onData: (profile) {
      ref.read(profileNotifierProvider.notifier).set(profile);
      if (onData != null) {
        onData(profile);
      }
    },
    onError: (e) {
      debugPrint(
        '[profile_query] ${e.response!.statusCode} - ${e.response!.data.toString()}',
      );
      ref.read(profileNotifierProvider.notifier).set(null);
      context.go('/onboarding');
    },
  );
}
