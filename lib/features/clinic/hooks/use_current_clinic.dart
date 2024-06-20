import 'package:dio/dio.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/clinic.dart';
import '../services/clinic.dart';

Query<Clinic, DioException> useCurrentClinic(WidgetRef ref) {
  final query = useQuery<Clinic, DioException>(
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

  return query;
}
