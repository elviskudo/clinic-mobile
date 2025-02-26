// To parse this JSON data, do
//
//     final doctor = doctorFromJson(jsonString);

import 'dart:convert';

Doctor doctorFromJson(String str) => Doctor.fromJson(json.decode(str));

String doctorToJson(Doctor data) => json.encode(data.toJson());

class Doctor {
  String id;
  String degree;
  String specialize;
  String description;
  String name;
  String clinicId;
  String polyId;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Doctor({
    required this.id,
    required this.degree,
    required this.name,
    required this.specialize,
    required this.description,
    required this.clinicId,
    required this.polyId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["id"],
        degree: json["degree"],
        description: json["description"],
        clinicId: json["clinic_id"],
        specialize: json["specialize"],
        name: json["name"],
        polyId: json["poly_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "degree": degree,
        "specialize": specialize,
        "description": description,
        "clinic_id": clinicId,
        "name": name,
        "poly_id": polyId,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
