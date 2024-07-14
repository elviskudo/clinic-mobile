import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  @JsonSerializable()
  const factory Profile({
    @JsonKey(name: 'fullname') required String fullName,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'profile_image') String? avatar,
    @JsonKey(name: 'no_identity') String? nik,
    @JsonKey(name: 'birth_date') DateTime? dateOfBirth,
    @JsonKey(name: 'birth_place') String? placeOfBirth,
    @JsonKey(name: 'work_in') String? workPlace,
    @JsonKey(name: 'blood_type') String? bloodType,
    @JsonKey(name: 'marital_status') String? maritalStatus,
    @JsonKey(name: 'responsible_for_costs') String? insurance,
    String? gender,
    String? address,
    String? nationality,
    String? religion,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}

List<String> profileToText({required Profile? profile}) {
  final List<String> profileKeys = [
    'no_identity',
    'birth_date',
    'birth_place',
    'work_in',
    'blood_type',
    'marital_status',
    'responsible_for_costs',
    'gender',
    'address',
    'nationality',
    'religion',
    'city_id'
  ];

  final Map<String, String> profileTextMap = {
    'no_identity': 'Identity Number (NIK)',
    'birth_date': 'Date of Birth',
    'birth_place': 'Place of Birth',
    'work_in': 'Work Location',
    'blood_type': 'Blood Type',
    'marital_status': 'Marital Status',
    'responsible_for_costs': 'Responsible Costs',
    'gender': 'Gender',
    'address': 'Street Address',
    'nationality': 'Nationality',
    'religion': 'Religion',
    'city_id': 'Hometown',
  };

  final profileMap = profile != null
      ? profile.toJson()
      : {for (var key in profileKeys) key: null};

  try {
    return profileMap.keys
        .where((key) => profileMap[key] == null && profileKeys.contains(key))
        .map((key) => profileTextMap[key] ?? '')
        .toList();
  } on Exception catch (e) {
    debugPrint(e.toString());
    return [];
  }
}
