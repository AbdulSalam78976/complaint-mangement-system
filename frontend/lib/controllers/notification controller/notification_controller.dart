import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/data/api_service.dart';
import 'package:frontend/models/complaint_model.dart';

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;
  final bool unread;
  final String priority;
  final String? complaintId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
    required this.unread,
    required this.priority,
    this.complaintId,
  });

  factory NotificationModel.fromComplaint(Complaint complaint) {
    String title;
    String description;
    IconData icon;
    Color color;
    String priority;

    switch (complaint.status) {
      case 'open':
        title = 'New Complaint Submitted';
        description = '${complaint.title} - Status: Open';
        icon = Icons.add_circle_outline;
        color = Colors.blue;
        priority = 'medium';
        break;
      case 'in_progress':
        title = 'Complaint In Progress';
        description = '${complaint.title} - Status: In Progress';
        icon = Icons.trending_up_outlined;
        color = Colors.orange;
        priority = 'high';
        break;
      case 'resolved':
        title = 'Complaint Resolved';
        description = '${complaint.title} - Status: Resolved';
        icon = Icons.check_circle_outline;
        color = Colors.green;
        priority = 'medium';
        break;
      case 'closed':
        title = 'Complaint Closed';
        description = '${complaint.title} - Status: Closed';
        icon = Icons.cancel_outlined;
        color = Colors.grey;
        priority = 'low';
        break;
      default:
        title = 'Complaint Updated';
        description = '${complaint.title} - Status: ${complaint.status}';
        icon = Icons.update;
        color = Colors.purple;
        priority = 'medium';
    }

    return NotificationModel(
      id: complaint.id,
      title: title,
      description: description,
      time: _formatTimeAgo(complaint.updatedAt),
      icon: icon,
      color: color,
      unread: true, // You can implement logic to track read status
      priority: priority,
      complaintId: complaint.id,
    );
  }

  static String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

class NotificationController extends GetxController {
  final api = ApiService();

  // All notifications
  final notifications = <NotificationModel>[].obs;

  // Loading states
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  // Fetch notifications based on user's complaints
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await api.get('/complaints');
      if (response.isSuccess) {
        final complaints = (response.data['items'] as List)
            .map((c) => Complaint.fromJson(c))
            .toList();

        // Convert complaints to notifications
        notifications.value = complaints
            .map((complaint) => NotificationModel.fromComplaint(complaint))
            .toList();
      } else {
        debugPrint('Failed to fetch notifications: ${response.errorMessage}');
      }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get unread notifications count
  int get unreadCount => notifications.where((n) => n.unread).length;

  // Mark notification as read
  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = NotificationModel(
        id: notifications[index].id,
        title: notifications[index].title,
        description: notifications[index].description,
        time: notifications[index].time,
        icon: notifications[index].icon,
        color: notifications[index].color,
        unread: false,
        priority: notifications[index].priority,
        complaintId: notifications[index].complaintId,
      );
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    notifications.value = notifications.map((notification) {
      return NotificationModel(
        id: notification.id,
        title: notification.title,
        description: notification.description,
        time: notification.time,
        icon: notification.icon,
        color: notification.color,
        unread: false,
        priority: notification.priority,
        complaintId: notification.complaintId,
      );
    }).toList();
  }

  // Refresh notifications
  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }
}
