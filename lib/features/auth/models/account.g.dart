// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountImpl _$$AccountImplFromJson(Map<String, dynamic> json) =>
    _$AccountImpl(
      id: (json['id'] as num?)?.toInt(),
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      imageUrl: json['image'] as String?,
      phoneNumber: json['phone_number'] as String?,
      isVerified: json['verifikasi'] as bool? ?? false,
    );

Map<String, dynamic> _$$AccountImplToJson(_$AccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.fullName,
      'image': instance.imageUrl,
      'phone_number': instance.phoneNumber,
      'verifikasi': instance.isVerified,
    };
