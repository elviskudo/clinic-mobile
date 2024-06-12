import 'package:clinic/models/clinic/clinic.dart';
import 'package:clinic/services/http.dart';
import 'package:dio/dio.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';

Query<Clinic, DioException> useCurrentClinic() {
  final query = useQuery<Clinic, DioException>(
    'current_clinic',
    () async {
      final res = await dio.get('/api/clinics/9');
      return Clinic.fromJson(res.data['data']);
    },
    onError: (e) {
      debugPrint(
        '[current_clinic_query] ${e.response!.statusCode} - ${e.response!.data.toString()}',
      );
    },
  );

  return query;
}
