// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentImpl _$$AppointmentImplFromJson(Map<String, dynamic> json) =>
    _$AppointmentImpl(
      id: json['id'] as String?,
      doctor: json['doctor'] as String,
      clinic: json['clinic'] as String,
      poly: json['poly'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AppointmentImplToJson(_$AppointmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'doctor': instance.doctor,
      'clinic': instance.clinic,
      'poly': instance.poly,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };
