// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegistrationRequestBodyImpl _$$RegistrationRequestBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationRequestBodyImpl(
      email: json['email'] as String,
      password: json['password'] as String,
      fullName: json['fullname'] as String,
      phoneNumber: json['phone_number'] as String,
    );

Map<String, dynamic> _$$RegistrationRequestBodyImplToJson(
        _$RegistrationRequestBodyImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'fullname': instance.fullName,
      'phone_number': instance.phoneNumber,
    };
