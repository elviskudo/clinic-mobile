import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment.freezed.dart';
part 'appointment.g.dart';

@freezed
class Appointment with _$Appointment {
  @JsonSerializable()
  const factory Appointment({
    String? id,
    required String doctor,
    required String clinic,
    required String poly,
    required String status,
    required DateTime createdAt,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
}
