class Polies {
  String id;
  String name;
  String description;
  int status;
  String clinicId;
  DateTime createdAt;
  DateTime updatedAt;

  Polies({
    this.id = '',
    this.name = '',
    this.description = '',
    this.status = 0,
    this.clinicId = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Polies.fromJson(Map<String, dynamic> json) {
    return Polies(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as int? ?? 0,
      clinicId: json['clinic_id'] as String? ?? '',
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
      'status': status,
      'clinic_id': clinicId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}