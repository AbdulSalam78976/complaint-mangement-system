import 'package:frontend/models/user_model.dart';
import 'package:frontend/models/comment_model.dart';

class Complaint {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String status;
  final String phone;
  final String email;
  final UserModel createdBy; // replaced CreatedBy with UserModel
  final String? resolvedBy;
  final String? lastUpdatedBy;
  final List<String> attachments;
  final List<Comment> comments; // now strongly typed
  final DateTime createdAt;
  final DateTime updatedAt;

  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.phone,
    required this.email,
    required this.createdBy,
    this.resolvedBy,
    this.lastUpdatedBy,
    required this.attachments,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      createdBy: UserModel.fromJson(json['createdBy'] ?? {}),
      resolvedBy: json['resolvedBy'],
      lastUpdatedBy: json['lastUpdatedBy'],
      attachments: List<String>.from(json['attachments'] ?? []),
      comments: (json['comments'] as List<dynamic>? ?? [])
          .map((c) => Comment.fromJson(c))
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'status': status,
      'phone': phone,
      'email': email,
      'createdBy': createdBy.toJson(),
      'resolvedBy': resolvedBy,
      'lastUpdatedBy': lastUpdatedBy,
      'attachments': attachments,
      'comments': comments.map((c) => c.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
