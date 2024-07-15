import 'dart:math';

import 'package:faker_dart/faker_dart.dart';
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

List<Appointment> appointmentsSeed({int n = 10}) {
  final polies = ['vision', 'face', 'tongue', 'mouth'];
  final statuses = [
    'waiting',
    'diagnosed',
    'checkout',
    'completed',
    'rejected'
  ];

  List<Appointment> items = [];

  for (int index = 0; index < n; index++) {
    final random = Random();
    items.add(
      Appointment(
        doctor: Faker.instance.name.fullName(),
        clinic: Faker.instance.company.companyName(),
        createdAt: Faker.instance.datatype.dateTime(min: 2023, max: 2024),
        poly: polies[random.nextInt(polies.length)],
        status: statuses[random.nextInt(statuses.length)],
      ),
    );
  }

  return items;
}
