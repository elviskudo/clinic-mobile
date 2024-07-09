// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'user_dto.dart';

class UserRepository {
  Future<Profile> getProfile() async {
    return const Profile(fullName: 'John Doe');
  }

  Future<Profile> updateProfile(Map<String, dynamic> json) async {
    return const Profile(fullName: 'John Doe');
  }

  Future<List<String>> getUncompleteProfile(BuildContext context) async {
    final res = (await getProfile()).toJson();

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
