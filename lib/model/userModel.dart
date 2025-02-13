class Users {
  String id;
  String name;
  String email;
  String phoneNumber;
  String role;
  String? accessToken;
  DateTime createdAt;
  DateTime updatedAt;
  String? imageUrl;

  Users({
    this.id = '',
    this.name = '',
    this.email = '',
    this.role = '',
    this.phoneNumber = '',
    this.accessToken,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.imageUrl,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      accessToken: json['access_token'] != null && json['access_token'] != ''
          ? json['access_token'] as String?
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}
