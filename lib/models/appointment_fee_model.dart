// To parse this JSON data, do
//
//     final appointmentFee = appointmentFeeFromJson(jsonString);

import 'dart:convert';

AppointmentFee appointmentFeeFromJson(String str) => AppointmentFee.fromJson(json.decode(str));

String appointmentFeeToJson(AppointmentFee data) => json.encode(data.toJson());

class AppointmentFee {
    String id;
    String appointmentId;
    String feeId;
    bool status;
    DateTime createdAt;
    DateTime updatedAt;
    int price;

    AppointmentFee({
        required this.id,
        required this.appointmentId,
        required this.feeId,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.price,
    });

    factory AppointmentFee.fromJson(Map<String, dynamic> json) => AppointmentFee(
        id: json["id"],
        appointmentId: json["appointment_id"],
        feeId: json["fee_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "appointment_id": appointmentId,
        "fee_id": feeId,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "price": price,
    };
}
