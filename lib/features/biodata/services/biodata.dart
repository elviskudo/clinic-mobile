// ignore_for_file: use_build_context_synchronously

import 'package:clinic/services/http.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/biodata.dart';

part 'biodata.g.dart';

class BiodataService {
  Future<Biodata> getBiodata() async {
    final res = await dio.get('/api/users/personal-data');
    return Biodata.fromJson(res.data!['data']['user']);
  }

  Future<Biodata> updateBiodata(Biodata bio) async {
    final res = await dio.put('/api/users/personal-data', data: {
      'fullname': bio.fullName,
      'birth_place': bio.placeOfBirth,
      'birth_date': bio.dateOfBirth?.toIso8601String(),
      'gender': bio.gender,
      'no_identity': bio.nik,
      'address': bio.address,
      'area_code': bio.postalCode,
      'responsible_for_costs': bio.responsibleForCosts,
      'blood_type': bio.bloodType,
      'city_id': bio.city?.id,
    });
    return Biodata.fromJson(res.data!['data']['user']);
  }

  Future<List<String>> getUncompleteBiodata(BuildContext context) async {
    final res = (await getBiodata()).toJson();

    final List<String> keys = [
      'fullname',
      'birth_place',
      'birth_date',
      'gender',
      'no_identity',
      'address',
      'area_code',
      'responsible_for_costs',
      'blood_type',
      'city_id'
    ];

    final Map<String, String> mapped = {
      'fullname': context.tr('name_field.label'),
      'birth_place': context.tr('place_of_birth_field.label'),
      'birth_date': context.tr('date_of_birth_field.label'),
      'gender': context.tr('gender_field.label'),
      'no_identity': context.tr('nik_field.label'),
      'address': context.tr('address_field.label'),
      'area_code': context.tr('postal_code_field.label'),
      'responsible_for_costs': context.tr('responsible_costs_field.label'),
      'blood_type': context.tr('blood_type_field.label'),
      'city_id': context.tr('city_field.label')
    };

    return res.keys
        .where((key) => res[key] == null && keys.contains(key))
        .map((key) => mapped[key]!)
        .toList();
  }
}

@riverpod
BiodataService biodataService(BiodataServiceRef ref) => BiodataService();
