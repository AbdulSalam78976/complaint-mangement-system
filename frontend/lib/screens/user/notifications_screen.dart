// Add this function anywhere in your code and call it directly
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showNotificationsOverlay() {
  final notifications = [
    {
      'title': 'Your complaint has been updated',
      'description':
          'Network Issues in Department - Status changed to IN PROGRESS',
      'time': '2 hours ago',
      'icon': Icons.update,
      'color': Colors.orange,
      'unread': true,
    },
    {
      'title': 'New comment on your complaint',
      'description':
          'John Smith: We are looking into the issue. Have you tried connecting to the backup network?',
      'time': '1 day ago',
      'icon': Icons.comment,
      'color': Colors.blue,
      'unread': true,
    },
    {
      'title': 'Complaint assigned',
      'description':
          'Your complaint "Network Issues in Department" has been assigned to John Smith',
      'time': '2 days ago',
      'icon': Icons.person_add,
      'color': Colors.green,
      'unread': false,
    },
    {
      'title': 'Complaint submitted successfully',
      'description':
          'Your complaint "Network Issues in Department" has been submitted successfully',
      'time': '2 days ago',
      'icon': Icons.check_circle,
      'color': Colors.green,
      'unread': false,
    },
    {
      'title': 'Welcome to CMS',
      'description':
          'Thank you for registering. You can now submit and track your complaints.',
      'time': '1 week ago',
      'icon': Icons.celebration,
      'color': Colors.purple,
      'unread': false,
    },
  ];

  final unreadCount = notifications.where((n) => n['unread'] == true).length;

  Get.dialog(
    barrierColor: Colors.black.withOpacity(0.3),
    Dialog(
      alignment: Alignment.topRight,
      insetPadding: const EdgeInsets.only(top: 100, right: 20, left: 20),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$unreadCount new notifications',
                          style: const TextStyle(
                            color: Color(0xFFBFDBFE),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Mark all as read
                  TextButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        'Success',
                        'All notifications marked as read',
                        backgroundColor: const Color(0xFF10B981),
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 2),
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                        icon: const Icon(Icons.done_all, color: Colors.white),
                      );
                    },
                    icon: const Icon(
                      Icons.done_all,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: const Text(
                      'Mark All Read',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      minimumSize: const Size(32, 32),
                    ),
                  ),
                ],
              ),
            ),

            // Notifications List
            Flexible(
              child: notifications.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No notifications yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You\'ll see updates about your complaints here',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: notification['unread'] == true
                                ? const Color(0xFFF0F7FF)
                                : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: notification['unread'] == true
                                  ? const Color(0xFFE0EFFF)
                                  : const Color(0xFFF1F5F9),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Get.back();
                                // Handle notification tap - navigate to relevant screen
                                Get.snackbar(
                                  'Notification',
                                  'Opening: ${notification['title']}',
                                  backgroundColor: const Color(0xFF3B82F6),
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 2),
                                  margin: const EdgeInsets.all(16),
                                  borderRadius: 12,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Icon
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: (notification['color'] as Color)
                                            .withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        notification['icon'] as IconData,
                                        color: notification['color'] as Color,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Content
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  notification['title']
                                                      as String,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        notification['unread'] ==
                                                            true
                                                        ? FontWeight.bold
                                                        : FontWeight.w600,
                                                    color: const Color(
                                                      0xFF0F172A,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (notification['unread'] ==
                                                  true)
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Color(
                                                          0xFF3B82F6,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            notification['description']
                                                as String,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF64748B),
                                              height: 1.4,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.schedule,
                                                size: 12,
                                                color: Colors.grey[500],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                notification['time'] as String,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Footer
            if (notifications.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  border: Border(
                    top: BorderSide(color: const Color(0xFFE2E8F0)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Get.back();
                        // Navigate to full notifications screen if needed
                        Get.snackbar(
                          'Info',
                          'View all notifications feature',
                          backgroundColor: const Color(0xFF64748B),
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                        );
                      },
                      icon: const Icon(Icons.list_alt, size: 16),
                      label: const Text('View All Notifications'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
