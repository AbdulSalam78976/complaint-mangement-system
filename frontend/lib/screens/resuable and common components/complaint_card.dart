import 'package:flutter/material.dart';
import 'package:frontend/resources/routes/routes_names.dart' show RouteName;
import 'package:frontend/resources/theme/colors.dart';
import 'package:get/get.dart';

class EnhancedComplaintCard extends StatelessWidget {
  final String title;
  final String department;
  final String priority;
  final String status;
  final String time;
  final String description;
  final VoidCallback? onTap;
  final double? width;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final double iconSize;
  final double titleFontSize;
  final double departmentFontSize;
  final double descriptionFontSize;
  final double statusFontSize;
  final double priorityFontSize;
  final double timeFontSize;
  final IconData? customIcon;

  EnhancedComplaintCard({
    Key? key,
    required this.title,
    required this.department,
    required this.priority,
    required this.status,
    required this.time,
    required this.description,
    this.onTap,
    this.width,
    this.padding,
    this.borderRadius,
    this.iconSize = 24,
    this.titleFontSize = 16,
    this.departmentFontSize = 14,
    this.descriptionFontSize = 14,
    this.statusFontSize = 12,
    this.priorityFontSize = 12,
    this.timeFontSize = 12,
    this.customIcon,
  }) : super(key: key);

  // Define categories with icons and colors
  final List<Map<String, dynamic>> categories = [
    {
      'value': 'IT Department',
      'icon': Icons.computer_outlined,
      'color': Colors.blue,
    },
    {
      'value': 'HR Department',
      'icon': Icons.people_outline,
      'color': Colors.purple,
    },
    {
      'value': 'Finance',
      'icon': Icons.account_balance_wallet_outlined,
      'color': Colors.green,
    },
    {
      'value': 'Facilities',
      'icon': Icons.business_outlined,
      'color': Colors.orange,
    },
    {'value': 'Security', 'icon': Icons.security_outlined, 'color': Colors.red},
    {'value': 'Other', 'icon': Icons.help_outline, 'color': Colors.grey},
  ];

  IconData _getDepartmentIcon(String department) {
    // Find the category that matches the department
    final category = categories.firstWhere(
      (cat) => cat['value'] == department,
      orElse: () => categories.last, // Default to 'Other' if not found
    );

    return category['icon'] as IconData;
  }

  Color _getDepartmentColor(String department) {
    // Find the category that matches the department
    final category = categories.firstWhere(
      (cat) => cat['value'] == department,
      orElse: () => categories.last, // Default to 'Other' if not found
    );

    return category['color'] as Color;
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.error_outline;
      case 'medium':
        return Icons.warning_outlined;
      case 'low':
        return Icons.info_outline;
      default:
        return Icons.flag_outlined;
    }
  }

  Color getStatusColor() {
    switch (status.toLowerCase()) {
      case 'open':
        return AppPalette.errorColor;
      case 'in progress':
        return AppPalette.accentColor;
      case 'resolved':
        return AppPalette.successColor;
      default:
        return AppPalette.greyColor;
    }
  }

  Color getStatusBackgroundColor() {
    switch (status.toLowerCase()) {
      case 'open':
        return AppPalette.errorColor.withOpacity(0.1);
      case 'in progress':
        return AppPalette.accentColor.withOpacity(0.1);
      case 'resolved':
        return AppPalette.successColor.withOpacity(0.1);
      default:
        return AppPalette.backgroundColor;
    }
  }

  Color getPriorityColor() {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppPalette.errorColor;
      case 'medium':
        return AppPalette.accentColor;
      case 'low':
        return AppPalette.successColor;
      default:
        return AppPalette.greyColor;
    }
  }

  Color getPriorityBackgroundColor() {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppPalette.errorColor.withOpacity(0.1);
      case 'medium':
        return AppPalette.accentColor.withOpacity(0.1);
      case 'low':
        return AppPalette.successColor.withOpacity(0.1);
      default:
        return AppPalette.backgroundColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor();
    final statusBgColor = getStatusBackgroundColor();
    final priorityColor = getPriorityColor();
    final priorityBgColor = getPriorityBackgroundColor();
    final departmentColor = _getDepartmentColor(department);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:
            onTap ??
            () => Get.toNamed(
              RouteName.complaintDetailsScreen,
              arguments: description,
            ),
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        child: Container(
          width: width,
          padding: padding ?? const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppPalette.whiteColor,
            borderRadius: borderRadius ?? BorderRadius.circular(20),
            border: Border.all(color: AppPalette.borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: departmentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      customIcon ?? _getDepartmentIcon(department),
                      size: iconSize,
                      color: departmentColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          department,
                          style: TextStyle(
                            fontSize: departmentFontSize,
                            color: AppPalette.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: statusFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: TextStyle(
                  fontSize: descriptionFontSize,
                  color: AppPalette.greyColor,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  // Priority Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: priorityBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getPriorityIcon(priority),
                          size: priorityFontSize + 2,
                          color: priorityColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          priority,
                          style: TextStyle(
                            color: priorityColor,
                            fontSize: priorityFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Time Created
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        size: timeFontSize + 2,
                        color: AppPalette.greyColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: timeFontSize,
                          color: AppPalette.greyColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
