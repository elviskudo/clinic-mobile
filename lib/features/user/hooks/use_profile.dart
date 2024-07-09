import 'package:clinic/features/user/user_dto.dart';
import 'package:clinic/features/user/user_repo.dart';
import 'package:dio/dio.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';

Query<Profile, DioException> useProfile() {
  return useQuery<Profile, DioException>(
    'profile',
    () async => await UserRepository().getProfile(),
  );
}
