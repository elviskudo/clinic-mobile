// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      id: (json['id'] as num?)?.toInt(),
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      imageUrl: json['image'] as String?,
      phoneNumber: json['phone_number'] as String?,
      isVerified: json['verifikasi'] as bool? ?? false,
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.fullName,
      'image': instance.imageUrl,
      'phone_number': instance.phoneNumber,
      'verifikasi': instance.isVerified,
    };
