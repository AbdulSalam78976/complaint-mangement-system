import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/widgets/appbar.dart';
import 'package:get/get.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  const ComplaintDetailsScreen({super.key});

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  final String complaintId = Get.arguments;
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    final complaintData = _getComplaintData();
    currentStatus = complaintData['status'] as String;
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Resolved':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  // Mock data based on complaint ID
  Map<String, dynamic> _getComplaintData() {
    final idNum =
        int.tryParse(complaintId.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;

    final statuses = ['Open', 'In Progress', 'Resolved'];
    final priorities = ['Low', 'Medium', 'High'];
    final departments = ['IT Department', 'Facilities', 'HR', 'Finance'];
    final titles = [
      'Network Issues in Department',
      'Air Conditioning Not Working',
      'Printers Not Functioning',
      'Software License Renewal',
      'Hardware Replacement Needed',
    ];
    final descriptions = [
      'The network in our department has been unstable for the past week. We are experiencing frequent disconnections and slow internet speeds, which is affecting our productivity. We have tried restarting the router but the issue persists.',
      'The air conditioning unit in the main conference room has stopped working. The temperature is uncomfortably warm during meetings.',
      'All printers on the 3rd floor are offline and unable to connect to the network. This is causing delays in document processing.',
      'Our department software licenses are expiring next week and need to be renewed urgently to avoid service interruption.',
      'Several computers in the marketing department need hardware upgrades as they are running very slowly and affecting work efficiency.',
    ];

    return {
      'status': statuses[idNum % statuses.length],
      'priority': priorities[idNum % priorities.length],
      'department': departments[idNum % departments.length],
      'title': titles[idNum % titles.length],
      'description': descriptions[idNum % descriptions.length],
      'submittedDaysAgo': (idNum % 5) + 1,
    };
  }

  void _showStatusChangeDialog() {
    final statuses = ['Open', 'In Progress', 'Resolved'];
    String selectedStatus = currentStatus;

    Get.dialog(
      Dialog(
        backgroundColor: AppPalette.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppPalette.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.update,
                      color: AppPalette.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Update Status',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Change complaint status',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppPalette.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              StatefulBuilder(
                builder: (context, setDialogState) {
                  return Column(
                    children: statuses.map((status) {
                      final isSelected = selectedStatus == status;
                      final color = _statusColor(status);

                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            selectedStatus = status;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withOpacity(0.1)
                                : AppPalette.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? color
                                  : AppPalette.borderColor,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  status == 'Resolved'
                                      ? Icons.check_circle_outline
                                      : status == 'In Progress'
                                      ? Icons.schedule_outlined
                                      : Icons.radio_button_unchecked,
                                  color: color,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? color
                                        : AppPalette.textColor,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: color,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppPalette.greyColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          currentStatus = selectedStatus;
                        });
                        Get.back();
                        Get.snackbar(
                          'Success',
                          'Status updated to $selectedStatus',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.shade100,
                          colorText: Colors.green.shade800,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                          icon: Icon(
                            Icons.check_circle,
                            color: Colors.green.shade600,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primaryColor,
                        foregroundColor: AppPalette.whiteColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final complaintData = _getComplaintData();

    return Scaffold(
      backgroundColor: AppPalette.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Complaint Details',
        showBack: true,
        showLogo: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header showing complaint ID
              Text(
                'Complaint #$complaintId',
                style: TextStyle(
                  fontSize: 14,
                  color: AppPalette.greyColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              // Header card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppPalette.whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppPalette.borderColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(
                              currentStatus,
                            ).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            currentStatus.toUpperCase(),
                            style: TextStyle(
                              color: _statusColor(currentStatus),
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppPalette.greyColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Created: ${complaintData['submittedDaysAgo']} days ago',
                          style: TextStyle(
                            color: AppPalette.greyColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      complaintData['title'] as String,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: complaintData['priority'] == 'High'
                            ? AppPalette.errorColor.withOpacity(0.12)
                            : complaintData['priority'] == 'Medium'
                            ? Colors.orange.withOpacity(0.12)
                            : Colors.blue.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${complaintData['priority']} Priority',
                        style: TextStyle(
                          color: complaintData['priority'] == 'High'
                              ? AppPalette.errorColor
                              : complaintData['priority'] == 'Medium'
                              ? Colors.orange
                              : Colors.blue,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Description
              _SectionHeader(title: 'Description'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppPalette.whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppPalette.borderColor, width: 1),
                ),
                child: Text(
                  complaintData['description'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppPalette.textColor,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Timeline
              _SectionHeader(title: 'Activity Timeline'),
              _TimelineItem(
                icon: Icons.assignment_turned_in_outlined,
                color: _statusColor(currentStatus),
                title: 'Status changed to ${currentStatus.toUpperCase()}',
                time: '${complaintData['submittedDaysAgo'] - 1} days ago',
              ),
              _TimelineItem(
                icon: Icons.send_outlined,
                color: AppPalette.primaryColor,
                title: 'Complaint submitted',
                time: '${complaintData['submittedDaysAgo']} days ago',
              ),

              const SizedBox(height: 16),

              // Comments
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionHeader(title: 'Comments'),
                  TextButton.icon(
                    onPressed: () {
                      Get.snackbar(
                        'Feature Coming Soon',
                        'Comment functionality will be available in the next update',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.blue.shade100,
                        colorText: Colors.blue.shade800,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                      );
                    },
                    icon: const Icon(Icons.add_comment_outlined, size: 18),
                    label: const Text('Add Comment'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppPalette.primaryColor,
                    ),
                  ),
                ],
              ),
              _CommentItem(
                name: 'Support Team',
                time: '${complaintData['submittedDaysAgo'] - 1} days ago',
                comment:
                    'We have received your complaint and are reviewing the details. We will get back to you soon with an update.',
                avatarUrl:
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=774&q=80',
              ),
              _CommentItem(
                name: 'You',
                time: '${complaintData['submittedDaysAgo']} days ago',
                comment:
                    'The issue started occurring suddenly without any changes to our setup. Please look into this urgently.',
                avatarUrl:
                    'https://images.unsplash.com/photo-1499714608240-22fc6ad53fb2?auto=format&fit=crop&w=2070&q=80',
              ),

              const SizedBox(height: 24),

              // Bottom action
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to List'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: AppPalette.primaryColor),
                    foregroundColor: AppPalette.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppPalette.textColor,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String time;
  const _TimelineItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPalette.borderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppPalette.textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppPalette.greyColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
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
    );
  }
}

class _CommentItem extends StatelessWidget {
  final String name;
  final String comment;
  final String time;
  final String avatarUrl;
  const _CommentItem({
    required this.name,
    required this.comment,
    required this.time,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPalette.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppPalette.textColor,
                ),
              ),
              const Spacer(),
              Text(
                time,
                style: TextStyle(color: AppPalette.greyColor, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: TextStyle(height: 1.4, color: AppPalette.textColor),
          ),
        ],
      ),
    );
  }
}
