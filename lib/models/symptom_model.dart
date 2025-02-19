// To parse this JSON data, do
//
//     final symptom = symptomFromJson(jsonString);

import 'dart:convert';

Symptom symptomFromJson(String str) => Symptom.fromJson(json.decode(str));

String symptomToJson(Symptom data) => json.encode(data.toJson());

class Symptom {
    String id;
    String polyId;
    String enName;
    String idName;
    String createdAt;
    DateTime updatedAt;

    Symptom({
        required this.id,
        required this.polyId,
        required this.enName,
        required this.idName,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Symptom.fromJson(Map<String, dynamic> json) => Symptom(
        id: json["id"],
        polyId: json["poly_id"],
        enName: json["en_name"],
        idName: json["id_name"],
        createdAt: json["created_at"],
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "poly_id": polyId,
        "en_name": enName,
        "id_name": idName,
        "created_at": createdAt,
        "updated_at": updatedAt.toIso8601String(),
    };
}
