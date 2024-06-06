// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_http_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileHttpResponseImpl _$$ProfileHttpResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileHttpResponseImpl(
      data: json['data'] == null
          ? null
          : ProfileHttpResponseData.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ProfileHttpResponseImplToJson(
        _$ProfileHttpResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$ProfileHttpResponseDataImpl _$$ProfileHttpResponseDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileHttpResponseDataImpl(
      user: Profile.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$$ProfileHttpResponseDataImplToJson(
        _$ProfileHttpResponseDataImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
    };
