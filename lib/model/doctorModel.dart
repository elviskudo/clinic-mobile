class Doctor {
  String id;
  String name;
  String description;
  String clinicId;
  String polyId;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Doctor({
    this.id = '',
    this.name = '',
    this.description = '',
    this.clinicId = '',
    this.polyId = '',
    this.status = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      clinicId: json['clinic_id'] as String? ?? '',
      polyId: json['poly_id'] as String? ?? '',
      status: json['status'] as int? ?? 0,
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
      'description': description,
      'clinic_id': clinicId,
      'poly_id': polyId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
