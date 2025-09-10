import 'package:frontend/models/user_model.dart';

class Complaint {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String status;
  final String phone;
  final String email;
  final UserModel createdBy; // replaced CreatedBy with User model
  final String? resolvedBy;
  final String? lastUpdatedBy;
  final List<String> attachments;
  final List<dynamic> comments; // can later convert to Comment model
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
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      priority: json['priority'],
      status: json['status'],
      phone: json['phone'],
      email: json['email'],
      createdBy: UserModel.fromJson(json['createdBy']), // use User model
      resolvedBy: json['resolvedBy'],
      lastUpdatedBy: json['lastUpdatedBy'],
      attachments: List<String>.from(json['attachments'] ?? []),
      comments: List<dynamic>.from(json['comments'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      'createdBy': createdBy.toJson(), // use User model
      'resolvedBy': resolvedBy,
      'lastUpdatedBy': lastUpdatedBy,
      'attachments': attachments,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
