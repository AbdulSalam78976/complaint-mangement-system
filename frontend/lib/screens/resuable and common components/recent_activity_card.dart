import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';

class RecentActivityList extends StatelessWidget {
  final List<Map<String, dynamic>> activities;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final double iconSize;
  final double titleFontSize;
  final double descriptionFontSize;
  final double timeFontSize;

  const RecentActivityList({
    Key? key,
    required this.activities,
    this.padding,
    this.borderRadius,
    this.iconSize = 24,
    this.titleFontSize = 16,
    this.descriptionFontSize = 14,
    this.timeFontSize = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        final color = activity['color'] as Color;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: borderRadius ?? BorderRadius.circular(20),
            onTap: activity['onTap'] as VoidCallback?,
            child: Container(
              width: double.infinity,
              padding: padding ?? const EdgeInsets.all(24),
              margin: const EdgeInsets.only(bottom: 16),
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
                  // Header row with time in top right
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          activity['icon'] as IconData,
                          size: iconSize,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Title (expanded to take available space)
                      Expanded(
                        child: Text(
                          activity['title'] as String,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.textColor,
                          ),
                        ),
                      ),
                      // Time in top right corner
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            size: timeFontSize + 2,
                            color: AppPalette.greyColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            activity['time'] as String,
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
                  const SizedBox(height: 12),
                  // Description
                  Text(
                    activity['description'] as String,
                    style: TextStyle(
                      fontSize: descriptionFontSize,
                      color: AppPalette.greyColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Usage example:
Widget _buildRecentActivityList() {
  final activities = [
    {
      'title': 'Complaint #1234 resolved',
      'description': 'Resolved by Admin',
      'time': '2 hours ago',
      'icon': Icons.check_circle,
      'color': Colors.green,
    },
    {
      'title': 'New user registered',
      'description': 'John Doe joined the system',
      'time': '3 hours ago',
      'icon': Icons.person_add,
      'color': Colors.blue,
    },
    {
      'title': 'Complaint #1235 assigned',
      'description': 'Assigned to Technical Team',
      'time': '5 hours ago',
      'icon': Icons.assignment_ind,
      'color': Colors.orange,
    },
    {
      'title': 'System maintenance',
      'description': 'Scheduled for tomorrow',
      'time': '1 day ago',
      'icon': Icons.build,
      'color': Colors.purple,
    },
  ];

  return RecentActivityList(activities: activities);
}
