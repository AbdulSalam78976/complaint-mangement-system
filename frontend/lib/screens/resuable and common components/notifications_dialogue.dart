import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:get/get.dart';

void showNotificationsDialog() {
  final notifications = [
    {
      'title': 'Complaint Status Updated',
      'description':
          'Network Infrastructure Issue - Status changed to IN PROGRESS',
      'time': '2 hours ago',
      'icon': Icons.trending_up_outlined,
      'color': AppPalette.accentColor,
      'unread': true,
      'priority': 'high',
    },
    {
      'title': 'New Response Received',
      'description':
          'IT Team: We\'ve identified the root cause and are implementing a fix.',
      'time': '4 hours ago',
      'icon': Icons.chat_bubble_outline,
      'color': AppPalette.primaryColor,
      'unread': true,
      'priority': 'medium',
    },
    {
      'title': 'Complaint Assigned',
      'description':
          'Your complaint has been assigned to Sarah Wilson from IT Department',
      'time': '1 day ago',
      'icon': Icons.person_add_alt_outlined,
      'color': AppPalette.successColor,
      'unread': false,
      'priority': 'medium',
    },
    {
      'title': 'Submission Confirmed',
      'description':
          'Your complaint "Network Infrastructure Issue" has been successfully submitted',
      'time': '2 days ago',
      'icon': Icons.check_circle_outline,
      'color': AppPalette.successColor,
      'unread': false,
      'priority': 'low',
    },
    {
      'title': 'Welcome to CMS',
      'description':
          'Thank you for joining! You can now submit and track complaints seamlessly.',
      'time': '1 week ago',
      'icon': Icons.celebration_outlined,
      'color': AppPalette.secondaryColor,
      'unread': false,
      'priority': 'low',
    },
  ];

  Get.dialog(
    barrierColor: AppPalette.textColor.withOpacity(0.6),
    barrierDismissible: true,
    Dialog(
      backgroundColor: AppPalette.transparentColor,
      insetPadding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          final isDesktop = screenWidth > 768;
          final isTablet = screenWidth > 480 && screenWidth <= 768;
          final isMobile = screenWidth <= 480;

          // Responsive sizing
          double dialogWidth;
          double maxHeight;
          EdgeInsets margin;
          Alignment alignment;

          if (isDesktop) {
            dialogWidth = 400;
            maxHeight = screenHeight * 0.7;
            margin = EdgeInsets.only(
              top: 60,
              right: 20,
              left: screenWidth - 420,
            );
            alignment = Alignment.topRight;
          } else if (isTablet) {
            dialogWidth = screenWidth * 0.7;
            maxHeight = screenHeight * 0.75;
            margin = const EdgeInsets.symmetric(horizontal: 20, vertical: 50);
            alignment = Alignment.center;
          } else {
            dialogWidth = screenWidth - 32;
            maxHeight = screenHeight * 0.8;
            margin = const EdgeInsets.all(16);
            alignment = Alignment.center;
          }

          return Align(
            alignment: alignment,
            child: Container(
              margin: margin,
              width: dialogWidth,
              constraints: BoxConstraints(maxHeight: maxHeight),
              decoration: BoxDecoration(
                color: AppPalette.whiteColor,
                borderRadius: BorderRadius.circular(isDesktop ? 16 : 20),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.textColor.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close button only
                  _buildCloseButton(isMobile),

                  // Notifications List
                  Flexible(
                    child: notifications.isEmpty
                        ? _buildEmptyState(isMobile)
                        : _buildSimpleNotificationsList(
                            notifications,
                            isDesktop,
                            isMobile,
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

Widget _buildCloseButton(bool isMobile) {
  return Align(
    alignment: Alignment.topRight,
    child: Padding(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(
          Icons.close_rounded,
          color: AppPalette.greyColor,
          size: isMobile ? 20 : 24,
        ),
      ),
    ),
  );
}

Widget _buildEmptyState(bool isMobile) {
  return Container(
    padding: EdgeInsets.all(isMobile ? 32 : 48),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.notifications_off_outlined,
          size: isMobile ? 40 : 48,
          color: AppPalette.greyColor,
        ),
        SizedBox(height: isMobile ? 16 : 20),
        Text(
          'No notifications',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            color: AppPalette.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'You\'re all caught up!',
          style: TextStyle(fontSize: 14, color: AppPalette.greyColor),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildSimpleNotificationsList(
  List<Map<String, dynamic>> notifications,
  bool isDesktop,
  bool isMobile,
) {
  return ListView.builder(
    shrinkWrap: true,
    padding: EdgeInsets.all(isMobile ? 12 : 16),
    itemCount: notifications.length,
    itemBuilder: (context, index) {
      final notification = notifications[index];
      final isUnread = notification['unread'] == true;

      return Container(
        margin: EdgeInsets.only(bottom: isMobile ? 10 : 12),
        decoration: BoxDecoration(
          color: isUnread
              ? AppPalette.primaryColor.withOpacity(0.03)
              : AppPalette.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: AppPalette.transparentColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _handleNotificationTap(notification),
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (notification['color'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      notification['icon'] as IconData,
                      color: notification['color'] as Color,
                      size: isMobile ? 18 : 20,
                    ),
                  ),
                  SizedBox(width: isMobile ? 12 : 16),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification['title'] as String,
                                style: TextStyle(
                                  fontSize: isMobile ? 14 : 15,
                                  fontWeight: isUnread
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: AppPalette.textColor,
                                ),
                              ),
                            ),
                            if (isUnread) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppPalette.accentColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notification['description'] as String,
                          style: TextStyle(
                            fontSize: isMobile ? 12 : 13,
                            color: AppPalette.greyColor,
                            height: 1.4,
                          ),
                          maxLines: isMobile ? 2 : 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_outlined,
                              size: 14,
                              color: AppPalette.greyColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              notification['time'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppPalette.greyColor,
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
  );
}

void _handleNotificationTap(Map<String, dynamic> notification) {
  Get.back();
  Get.snackbar(
    'Notification',
    'Opening: ${notification['title']}',
    backgroundColor: AppPalette.primaryColor,
    colorText: AppPalette.whiteColor,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
  );
}
