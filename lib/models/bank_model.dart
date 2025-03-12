// To parse this JSON data, do
//
//     final bank = bankFromJson(jsonString);

import 'dart:convert';

Bank bankFromJson(String str) => Bank.fromJson(json.decode(str));

String bankToJson(Bank data) => json.encode(data.toJson());

class Bank {
  String? id;
  String? name;
  String? accountNumber;
  DateTime? createdAt;
  DateTime? updatedAt;

  Bank({
    this.id,
    this.name,
    this.accountNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        id: json["id"],
        name: json["name"],
        accountNumber: json["account_number"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "account_number": accountNumber,
        "created_at":
            createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
