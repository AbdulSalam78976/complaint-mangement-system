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

  const EnhancedComplaintCard({
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

  IconData _getDepartmentIcon(String department) {
    final dept = department.toLowerCase();

    if (dept.contains('it') ||
        dept.contains('tech') ||
        dept.contains('computer')) {
      return Icons.computer;
    } else if (dept.contains('hr') || dept.contains('human')) {
      return Icons.people;
    } else if (dept.contains('finance') || dept.contains('account')) {
      return Icons.attach_money;
    } else if (dept.contains('maintenance') || dept.contains('facility')) {
      return Icons.build;
    } else if (dept.contains('admin') || dept.contains('administration')) {
      return Icons.business_center;
    } else if (dept.contains('security')) {
      return Icons.security;
    } else if (dept.contains('clean') || dept.contains('housekeeping')) {
      return Icons.cleaning_services;
    } else if (dept.contains('electr') || dept.contains('power')) {
      return Icons.electrical_services;
    } else if (dept.contains('plumb') || dept.contains('water')) {
      return Icons.plumbing;
    } else if (dept.contains('network') ||
        dept.contains('wifi') ||
        dept.contains('internet')) {
      return Icons.wifi;
    } else if (dept.contains('medical') || dept.contains('health')) {
      return Icons.local_hospital;
    } else if (dept.contains('transport') || dept.contains('vehicle')) {
      return Icons.directions_car;
    } else if (dept.contains('garden') || dept.contains('landscape')) {
      return Icons.nature;
    } else if (dept.contains('cafeteria') || dept.contains('food')) {
      return Icons.restaurant;
    } else {
      return Icons.business;
    }
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
                      color: AppPalette.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      customIcon ?? _getDepartmentIcon(department),
                      size: iconSize,
                      color: AppPalette.greyColor,
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
