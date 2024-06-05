// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VerificationRequestBodyImpl _$$VerificationRequestBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationRequestBodyImpl(
      otpCode: json['kode_otp'] as String,
    );

Map<String, dynamic> _$$VerificationRequestBodyImplToJson(
        _$VerificationRequestBodyImpl instance) =>
    <String, dynamic>{
      'kode_otp': instance.otpCode,
    };
