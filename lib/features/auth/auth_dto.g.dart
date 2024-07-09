// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthDTOImpl _$$AuthDTOImplFromJson(Map<String, dynamic> json) =>
    _$AuthDTOImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      role: json['role'] == null
          ? const Role(name: 'patient')
          : Role.fromJson(json['role'] as Map<String, dynamic>),
      isVerified: json['is_verified'] as bool? ?? false,
    );

Map<String, dynamic> _$$AuthDTOImplToJson(_$AuthDTOImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'role': instance.role,
      'is_verified': instance.isVerified,
    };
