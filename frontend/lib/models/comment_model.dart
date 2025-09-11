import 'package:frontend/models/user_model.dart';

class Comment {
  final String id;
  final String body;
  final bool admin;
  final String visibility;
  final DateTime createdAt;
  final UserModel user;

  Comment({
    required this.id,
    required this.body,
    required this.admin,
    required this.visibility,
    required this.createdAt,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id']?.toString() ?? '',
      body: json['body'] ?? '',
      admin: json['admin'] ?? false,
      visibility: json['visibility'] ?? 'public',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'admin': admin,
      'visibility': visibility,
      'createdAt': createdAt.toIso8601String(),
      'user': user.toJson(),
    };
  }

  // Helper for list conversion
  static List<Comment> fromJsonList(List<dynamic> list) {
    return list.map((e) => Comment.fromJson(e)).toList();
  }
}
