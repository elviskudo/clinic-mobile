// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SigninRequestBodyImpl _$$SigninRequestBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$SigninRequestBodyImpl(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$SigninRequestBodyImplToJson(
        _$SigninRequestBodyImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

_$SignupRequestBodyImpl _$$SignupRequestBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$SignupRequestBodyImpl(
      email: json['email'] as String,
      password: json['password'] as String,
      fullName: json['fullname'] as String,
      phoneNumber: json['phone_number'] as String,
    );

Map<String, dynamic> _$$SignupRequestBodyImplToJson(
        _$SignupRequestBodyImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'fullname': instance.fullName,
      'phone_number': instance.phoneNumber,
    };

_$VerificationRequestBodyImpl _$$VerificationRequestBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationRequestBodyImpl(
      code: json['kode_otp'] as String,
    );

Map<String, dynamic> _$$VerificationRequestBodyImplToJson(
        _$VerificationRequestBodyImpl instance) =>
    <String, dynamic>{
      'kode_otp': instance.code,
    };
