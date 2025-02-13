// To parse this JSON data, do
//
//     final poly = polyFromJson(jsonString);

import 'dart:convert';

Poly polyFromJson(String str) => Poly.fromJson(json.decode(str));

String polyToJson(Poly data) => json.encode(data.toJson());

class Poly {
    String id;
    String name;
    String description;
    int status;
    String createdAt;
    String updatedAt;
    String clinicId;

    Poly({
        required this.id,
        required this.name,
        required this.description,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.clinicId,
    });

    factory Poly.fromJson(Map<String, dynamic> json) => Poly(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        clinicId: json["clinic_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "clinic_id": clinicId,
    };
}
