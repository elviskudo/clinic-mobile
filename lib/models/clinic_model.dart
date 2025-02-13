// To parse this JSON data, do
//
//     final clinic = clinicFromJson(jsonString);

import 'dart:convert';

Clinic clinicFromJson(String str) => Clinic.fromJson(json.decode(str));

String clinicToJson(Clinic data) => json.encode(data.toJson());

class Clinic {
    String id;
    String name;
    String address;
    String accreditation;
    String? imageUrl;
    String contactName;
    String contactPhone;
    String contactEmail;
    DateTime createdAt;
    DateTime updatedAt;

    Clinic({
        required this.id,
        required this.name,
        required this.address,
        this.imageUrl,
        required this.accreditation,
        required this.contactName,
        required this.contactPhone,
        required this.contactEmail,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Clinic.fromJson(Map<String, dynamic> json) => Clinic(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        accreditation: json["accreditation"],
        contactName: json["contact_name"],
        contactPhone: json["contact_phone"],
        contactEmail: json["contact_email"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "accreditation": accreditation,
        "contact_name": contactName,
        "contact_phone": contactPhone,
        "contact_email": contactEmail,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
