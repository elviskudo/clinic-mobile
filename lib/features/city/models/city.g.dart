// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CityImpl _$$CityImplFromJson(Map<String, dynamic> json) => _$CityImpl(
      id: (json['id'] as num).toInt(),
      name: json['kabupaten'] as String,
      district: json['kecamatan'] as String,
      regency: json['kelurahan'] as String,
    );

Map<String, dynamic> _$$CityImplToJson(_$CityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kabupaten': instance.name,
      'kecamatan': instance.district,
      'kelurahan': instance.regency,
    };
