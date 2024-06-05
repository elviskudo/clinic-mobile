import 'package:clinic/models/profile/profile.dart';
import 'package:clinic/services/http.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';

Query<Profile?, dynamic> useProfileQuery({
  void Function(Profile?)? onData,
}) {
  return useQuery<Profile?, dynamic>(
    'profile',
    () async {
      final res = await dio.get('/api/users/profiles');
      if (res.statusCode != 200) return null;
      return null;
    },
    refreshConfig: RefreshConfig.withConstantDefaults(
      refreshOnMount: true,
      staleDuration: const Duration(minutes: 15),
    ),
    onData: onData,
  );
}
