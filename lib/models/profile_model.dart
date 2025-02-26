// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
    String id;
    String userId;
    String name;
    String placeOfBirth;
    DateTime dateOfBirth;
    int gender;
    String cardNumber;
    String address;
    int rt;
    int rw;
    String cityId;
    int postalCode;
    String responsibleForCosts;
    String bloodGroup;
    String createdAt;
    DateTime updatedAt;

    Profile({
        required this.id,
        required this.userId,
        required this.name,
        required this.placeOfBirth,
        required this.dateOfBirth,
        required this.gender,
        required this.cardNumber,
        required this.address,
        required this.rt,
        required this.rw,
        required this.cityId,
        required this.postalCode,
        required this.responsibleForCosts,
        required this.bloodGroup,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        placeOfBirth: json["place_of_birth"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        gender: json["gender"],
        cardNumber: json["card_number"],
        address: json["address"],
        rt: json["rt"],
        rw: json["rw"],
        cityId: json["city_id"],
        postalCode: json["postal_code"],
        responsibleForCosts: json["responsible_for_costs"],
        bloodGroup: json["blood_group"],
        createdAt: json["created_at"],
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "place_of_birth": placeOfBirth,
        "date_of_birth": "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "card_number": cardNumber,
        "address": address,
        "rt": rt,
        "rw": rw,
        "city_id": cityId,
        "postal_code": postalCode,
        "responsible_for_costs": responsibleForCosts,
        "blood_group": bloodGroup,
        "created_at": createdAt,
        "updated_at": updatedAt.toIso8601String(),
    };
}
