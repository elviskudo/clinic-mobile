// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biodata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BiodataImpl _$$BiodataImplFromJson(Map<String, dynamic> json) =>
    _$BiodataImpl(
      id: (json['id'] as num?)?.toInt(),
      fullName: json['fullname'] as String?,
      placeOfBirth: json['birth_place'] as String?,
      dateOfBirth: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      gender: json['gender'] as String?,
      nik: json['no_identity'] as String?,
      address: json['address'] as String?,
      postalCode: (json['area_code'] as num?)?.toInt(),
      responsibleForCosts: json['responsible_for_costs'] as String?,
      bloodType: json['blood_type'] as String?,
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BiodataImplToJson(_$BiodataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullName,
      'birth_place': instance.placeOfBirth,
      'birth_date': instance.dateOfBirth?.toIso8601String(),
      'gender': instance.gender,
      'no_identity': instance.nik,
      'address': instance.address,
      'area_code': instance.postalCode,
      'responsible_for_costs': instance.responsibleForCosts,
      'blood_type': instance.bloodType,
      'city': instance.city,
    };
