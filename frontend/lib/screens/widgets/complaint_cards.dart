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
  final IconData icon;
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

  const EnhancedComplaintCard({
    Key? key,
    required this.title,
    required this.department,
    required this.priority,
    required this.status,
    required this.time,
    required this.icon,
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
  }) : super(key: key);

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
        onTap: onTap ?? () => Get.toNamed(RouteName.complaintDetailsScreen),
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
                      icon,
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
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: priorityBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      priority,
                      style: TextStyle(
                        color: priorityColor,
                        fontSize: priorityFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        size: 16,
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
