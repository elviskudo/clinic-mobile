// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VerificationResponseImpl _$$VerificationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationResponseImpl(
      data: json['data'] == null
          ? null
          : VerificationResponseData.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$VerificationResponseImplToJson(
        _$VerificationResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$VerificationResponseDataImpl _$$VerificationResponseDataImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationResponseDataImpl(
      user: VerificationResponseDataUser.fromJson(
          json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$VerificationResponseDataImplToJson(
        _$VerificationResponseDataImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
    };

_$VerificationResponseDataUserImpl _$$VerificationResponseDataUserImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationResponseDataUserImpl(
      token: json['token'] as String,
    );

Map<String, dynamic> _$$VerificationResponseDataUserImplToJson(
        _$VerificationResponseDataUserImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
    };
