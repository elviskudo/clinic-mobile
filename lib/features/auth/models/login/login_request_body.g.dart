// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestBodyImpl _$$LoginRequestBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$LoginRequestBodyImpl(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestBodyImplToJson(
        _$LoginRequestBodyImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };
