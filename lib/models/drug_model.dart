// To parse this JSON data, do
//
//     final drug = drugFromJson(jsonString);

import 'dart:convert';

Drug drugFromJson(String str) => Drug.fromJson(json.decode(str));

String drugToJson(Drug data) => json.encode(data.toJson());

class Drug {
  String id;
  String name;
  String description;
  String companyName;
  int stock;
  int buyPrice;
  int sellPrice;
  String dosis;
  String kind;
  bool isHalal;
  String createdAt;
  DateTime updatedAt;

  Drug({
    required this.id,
    required this.name,
    required this.description,
    required this.companyName,
    required this.stock,
    required this.buyPrice,
    required this.sellPrice,
    required this.dosis,
    required this.kind,
    required this.isHalal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Drug.fromJson(Map<String, dynamic> json) => Drug(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        companyName: json["company_name"],
        stock: json["stock"],
        buyPrice: json["buy_price"],
        sellPrice: json["sell_price"],
        dosis: json["dosis"],
        kind: json["kind"],
        isHalal: json["is_halal"],
        createdAt: json["created_at"],
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "company_name": companyName,
        "stock": stock,
        "buy_price": buyPrice,
        "sell_price": sellPrice,
        "dosis": dosis,
        "kind": kind,
        "is_halal": isHalal,
        "created_at": createdAt,
        "updated_at": updatedAt.toIso8601String(),
      };
}
