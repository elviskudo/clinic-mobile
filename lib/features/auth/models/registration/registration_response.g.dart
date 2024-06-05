// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistrationResponseImpl _$$RegistrationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationResponseImpl(
      data: json['data'] == null
          ? null
          : RegistrationResponseData.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RegistrationResponseImplToJson(
        _$RegistrationResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$RegistrationResponseDataImpl _$$RegistrationResponseDataImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationResponseDataImpl(
      user: RegistrationResponseDataUser.fromJson(
          json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RegistrationResponseDataImplToJson(
        _$RegistrationResponseDataImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
    };

_$RegistrationResponseDataUserImpl _$$RegistrationResponseDataUserImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationResponseDataUserImpl(
      id: (json['id'] as num).toInt(),
      fullName: json['fullname'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$$RegistrationResponseDataUserImplToJson(
        _$RegistrationResponseDataUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullName,
      'token': instance.token,
    };
