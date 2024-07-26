import 'package:clinic/services/http.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rearch/rearch.dart';

import '../domain/clinic.dart';

class ClinicRepository {
  Future<Clinic?> getClinicById(String id) async {
    try {
      final json = await dio.get('/clinics/$id');
      return Clinic.fromJson(json.data['data']);
    } on DioException catch (ex) {
      if (ex.response?.statusCode == 500) rethrow;
      return null;
    } catch (ex) {
      debugPrint(
        ex is DioException ? ex.response!.data.toString() : ex.toString(),
      );
      return null;
    }
  }
}

ClinicRepository clinicRepo(CapsuleHandle use) => ClinicRepository();
