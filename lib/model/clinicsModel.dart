class Clinics {
  String id;
  String name;
  String address;
  String accreditation;
  String contactName;
  String? imageUrl; // Add this field to store image URL

  String contactPhone;
  String contactEmail;
  DateTime createdAt;
  DateTime updatedAt;

  Clinics({
    this.id = '',
    this.name = '',
    this.address = '',
    this.accreditation = '',
    this.imageUrl,
    this.contactName = '',
    this.contactPhone = '',
    this.contactEmail = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Clinics.fromJson(Map<String, dynamic> json) {
    return Clinics(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      accreditation: json['accreditation'] as String? ?? '',
      contactName: json['contact_name'] as String? ?? '',
      contactPhone: json['contact_phone'] as String? ?? '',
      contactEmail: json['contact_email'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'accreditation': accreditation,
      'contact_name': contactName,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
