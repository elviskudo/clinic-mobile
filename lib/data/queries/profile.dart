import 'package:clinic/models/profile/profile.dart';
import 'package:clinic/models/profile/profile_http_response.dart';
import 'package:clinic/providers/profile.dart';
import 'package:clinic/services/http.dart';
import 'package:clinic/services/kv.dart';
import 'package:dio/dio.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Query<Profile?, DioException> useProfile(
  WidgetRef ref, {
  void Function(Profile?)? onData,
  void Function(DioException)? onError,
}) {
  return useQuery<Profile?, DioException>(
    'profile',
    () async {
      final res = await dio.get('/api/users/profiles');

      if (res.statusCode == 200) {
        final result = ProfileHttpResponse.fromJson(res.data);
        final token = result.data?.token ?? '';
        final profile = result.data?.user;

        if (token.isNotEmpty && profile != null) {
          await KV.tokens.put('access_token', token);
        }

        if (!profile!.isVerified) {
          throw DioException.badResponse(
            statusCode: 400,
            requestOptions: RequestOptions(),
            response: Response(requestOptions: RequestOptions()),
          );
        }

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
        return onData(profile);
      }
    },
    onError: onError,
  );
}
