// To parse this JSON data, do
//
//     final scheduleTime = scheduleTimeFromJson(jsonString);

import 'dart:convert';

ScheduleTime scheduleTimeFromJson(String str) => ScheduleTime.fromJson(json.decode(str));

String scheduleTimeToJson(ScheduleTime data) => json.encode(data.toJson());

class ScheduleTime {
    String id;
    String dateId;
    String scheduleTime;
    String createdAt;
    String updatedAt;

    ScheduleTime({
        required this.id,
        required this.dateId,
        required this.scheduleTime,
        required this.createdAt,
        required this.updatedAt,
    });

    factory ScheduleTime.fromJson(Map<String, dynamic> json) => ScheduleTime(
        id: json["id"],
        dateId: json["date_id"],
        scheduleTime: json["schedule_time"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date_id": dateId,
        "schedule_time": scheduleTime,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
