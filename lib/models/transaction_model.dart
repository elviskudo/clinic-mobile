class Transaction {
  String? id;
  String? bankId;
  String? appointmentId;
  String? userId;
  String? transactionNumber;
  double? totalPrice;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? status;
Transaction({
    this.id,
    this.bankId,
    this.appointmentId,
    this.userId,
    this.transactionNumber,
    this.totalPrice,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        bankId: json["bank_id"],
        appointmentId: json["appointment_id"],
        userId: json["user_id"],
        transactionNumber: json["transaction_number"],
         totalPrice: (json["total_price"] is int)
            ? (json["total_price"] as int).toDouble() // konversi ke double jika int
            : json["total_price"], // langsung ambil jika double,
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]): null,
        updatedAt: json["updated_at"]!= null ? DateTime.parse(json["updated_at"]): null,
        status: json["status"],
    );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bank_id": bankId,
        "appointment_id": appointmentId,
        "user_id": userId,
        "transaction_number": transactionNumber,
        "total_price": totalPrice,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "status": status,
      };
}