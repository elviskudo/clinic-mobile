// To parse this JSON data, do
//
//     final scheduleDate = scheduleDateFromJson(jsonString);

import 'dart:convert';

ScheduleDate scheduleDateFromJson(String str) => ScheduleDate.fromJson(json.decode(str));

String scheduleDateToJson(ScheduleDate data) => json.encode(data.toJson());

class ScheduleDate {
    String id;
    String polyId;
    String doctorId;
    DateTime scheduleDate;
    DateTime createdAt;
    DateTime updatedAt;

    ScheduleDate({
        required this.id,
        required this.polyId,
        required this.doctorId,
        required this.scheduleDate,
        required this.createdAt,
        required this.updatedAt,
    });

    factory ScheduleDate.fromJson(Map<String, dynamic> json) => ScheduleDate(
        id: json["id"],
        polyId: json["poly_id"],
        doctorId: json["doctor_id"],
        scheduleDate: DateTime.parse(json["schedule_date"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "poly_id": polyId,
        "doctor_id": doctorId,
        "schedule_date": "${scheduleDate.year.toString().padLeft(4, '0')}-${scheduleDate.month.toString().padLeft(2, '0')}-${scheduleDate.day.toString().padLeft(2, '0')}",
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
