// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      data: json['data'] == null
          ? null
          : LoginResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$LoginResponseDataImpl _$$LoginResponseDataImplFromJson(
        Map<String, dynamic> json) =>
    _$LoginResponseDataImpl(
      token: json['token'] as String,
      userId: (json['user_id'] as num?)?.toInt(),
      isVerified: json['verifikasi'] as bool,
      fullName: json['fullname'] as String,
    );

Map<String, dynamic> _$$LoginResponseDataImplToJson(
        _$LoginResponseDataImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'user_id': instance.userId,
      'verifikasi': instance.isVerified,
      'fullname': instance.fullName,
    };
