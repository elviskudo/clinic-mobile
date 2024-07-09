// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoleImpl _$$RoleImplFromJson(Map<String, dynamic> json) => _$RoleImpl(
      name: json['name'] as String? ?? 'patient',
    );

Map<String, dynamic> _$$RoleImplToJson(_$RoleImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      fullName: json['fullname'] as String,
      phoneNumber: json['phone_number'] as String,
      avatar: json['profile_image'] as String?,
      nik: json['no_identity'] as String?,
      dateOfBirth: json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      placeOfBirth: json['birth_place'] as String?,
      workPlace: json['work_in'] as String?,
      bloodType: json['blood_type'] as String?,
      maritalStatus: json['marital_status'] as String?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      nationality: json['nationality'] as String?,
      religion: json['religion'] as String?,
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'fullname': instance.fullName,
      'phone_number': instance.phoneNumber,
      'profile_image': instance.avatar,
      'no_identity': instance.nik,
      'birth_date': instance.dateOfBirth?.toIso8601String(),
      'birth_place': instance.placeOfBirth,
      'work_in': instance.workPlace,
      'blood_type': instance.bloodType,
      'marital_status': instance.maritalStatus,
      'gender': instance.gender,
      'address': instance.address,
      'nationality': instance.nationality,
      'religion': instance.religion,
    };
