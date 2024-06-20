// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClinicImpl _$$ClinicImplFromJson(Map<String, dynamic> json) => _$ClinicImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['clinic_name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String?,
      zipCode: json['post_code'] as String?,
    );

Map<String, dynamic> _$$ClinicImplToJson(_$ClinicImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clinic_name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'post_code': instance.zipCode,
    };
