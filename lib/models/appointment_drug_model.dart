import 'dart:convert';

AppointmentDrug appointmentDrugFromJson(String str) => AppointmentDrug.fromJson(json.decode(str));

String appointmentDrugToJson(AppointmentDrug data) => json.encode(data.toJson());

class AppointmentDrug {
  String id;
  String appointmentId;
  String drugId;
  bool status;
  DateTime createdAt;
  DateTime updatedAt;
  int price;

  AppointmentDrug({
    required this.id,
    required this.appointmentId,
    required this.drugId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.price,
  });

  factory AppointmentDrug.fromJson(Map<String, dynamic> json) => AppointmentDrug(
    id: json["id"],
    appointmentId: json["appointment_id"],
    drugId: json["drug_id"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "appointment_id": appointmentId,
    "drug_id": drugId,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "price": price,
  };
}