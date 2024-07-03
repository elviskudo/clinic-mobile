import 'package:dio/dio.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/biodata.dart';
import '../services/biodata.dart';

Query<Biodata, DioException> useBiodataQuery(WidgetRef ref) {
  return useQuery<Biodata, DioException>(
    'user/biodata',
    ref.read(biodataServiceProvider).getBiodata,
    jsonConfig: JsonConfig(
      toJson: (bio) => bio.toJson(),
      fromJson: Biodata.fromJson,
    ),
  );
}
