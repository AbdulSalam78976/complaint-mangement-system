class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool active;
  final bool verified;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.active,
    required this.verified,
  });

  // Factory constructor to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      active: json['active'] ?? false,
      verified: json['verified'] ?? false,
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'active': active,
      'verified': verified,
    };
  }
}
