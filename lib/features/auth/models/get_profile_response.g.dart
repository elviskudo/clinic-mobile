// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GetProfileResponseImpl _$$GetProfileResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GetProfileResponseImpl(
      status: (json['status'] as num).toInt(),
      success: json['success'] as bool,
      errors: json['errors'],
      meta: json['meta'],
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : GetProfileResponseData.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GetProfileResponseImplToJson(
        _$GetProfileResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'success': instance.success,
      'errors': instance.errors,
      'meta': instance.meta,
      'message': instance.message,
      'data': instance.data,
    };

_$GetProfileResponseDataImpl _$$GetProfileResponseDataImplFromJson(
        Map<String, dynamic> json) =>
    _$GetProfileResponseDataImpl(
      user: json['user'] == null
          ? null
          : GetProfileResponseDataUser.fromJson(
              json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GetProfileResponseDataImplToJson(
        _$GetProfileResponseDataImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
    };

_$GetProfileResponseDataUserImpl _$$GetProfileResponseDataUserImplFromJson(
        Map<String, dynamic> json) =>
    _$GetProfileResponseDataUserImpl(
      id: (json['id'] as num).toInt(),
      fullName: json['full_name'] as String,
      image: json['image'] as String?,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      verifikasi: json['verifikasi'] as bool,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$$GetProfileResponseDataUserImplToJson(
        _$GetProfileResponseDataUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'image': instance.image,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'verifikasi': instance.verifikasi,
      'token': instance.token,
    };
