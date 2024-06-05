// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      id: (json['id'] as num?)?.toInt(),
      email: json['email'] as String?,
      fullName: json['fullname'] as String,
      phoneNumber: json['phone_number'] as String?,
      imageUrl: json['image'] as String?,
      isVerified: json['verifikasi'] as bool? ?? false,
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullname': instance.fullName,
      'phone_number': instance.phoneNumber,
      'image': instance.imageUrl,
      'verifikasi': instance.isVerified,
    };
