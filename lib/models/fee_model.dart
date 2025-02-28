// To parse this JSON data, do
//
//     final fee = feeFromJson(jsonString);

import 'dart:convert';

Fee feeFromJson(String str) => Fee.fromJson(json.decode(str));

String feeToJson(Fee data) => json.encode(data.toJson());

class Fee {
  String id;
  String procedure;
  int price;
  bool status;

  Fee({
    required this.id,
    required this.procedure,
    required this.price,
    required this.status,
  });

  factory Fee.fromJson(Map<String, dynamic> json) => Fee(
        id: json["id"],
        procedure: json["procedure"],
        price: json["price"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "procedure": procedure,
        "price": price,
        "status": status,
      };
}
