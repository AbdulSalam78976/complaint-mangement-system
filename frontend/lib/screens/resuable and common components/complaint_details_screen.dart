import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/appbar.dart';
import 'package:get/get.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  const ComplaintDetailsScreen({super.key});

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  late Map<String, dynamic> complaintData;
  late bool isAdminView;
  late String currentStatus;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Get arguments passed from navigation
    final Map<String, dynamic> arguments =
        Get.arguments as Map<String, dynamic>;
    complaintData = arguments['complaint'] as Map<String, dynamic>;
    isAdminView = arguments['isAdminView'] as bool;

    currentStatus = complaintData['status'] as String;
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Resolved':
        return Colors.green;
      case 'In Progress':
        return Colors.blue;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Resolved':
        return Icons.check_circle;
      case 'In Progress':
        return Icons.sync;
      case 'Rejected':
        return Icons.cancel;
      case 'Pending':
        return Icons.pending;
      default:
        return Icons.help_outline;
    }
  }

  void _showStatusChangeDialog() {
    final statuses = isAdminView
        ? ['Pending', 'In Progress', 'Resolved', 'Rejected']
        : ['Open', 'In Progress', 'Resolved'];

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
                                  _statusIcon(status),
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

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    // Add comment logic here
    final newComment = {
      'text': _commentController.text,
      'author': isAdminView ? 'Admin' : 'You',
      'time': 'Just now',
      'avatar': isAdminView
          ? 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=500&q=80'
          : 'https://images.unsplash.com/photo-1499714608240-22fc6ad53fb2?auto=format&fit=crop&w=500&q=80',
    };

    setState(() {
      if (complaintData['comments'] == null) {
        complaintData['comments'] = [];
      }
      (complaintData['comments'] as List).insert(0, newComment);
    });

    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.backgroundColor,
      appBar: CustomAppBar(
        title: 'Complaint Details',
        showBack: true,
        showLogo: false,
        isAdmin: isAdminView,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header showing complaint ID
              Text(
                'Complaint #${complaintData['id'] ?? 'N/A'}',
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
                          child: Row(
                            children: [
                              Icon(
                                _statusIcon(currentStatus),
                                size: 14,
                                color: _statusColor(currentStatus),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                currentStatus.toUpperCase(),
                                style: TextStyle(
                                  color: _statusColor(currentStatus),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            ],
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
                          'Created: ${complaintData['submittedDaysAgo'] ?? 0} days ago',
                          style: TextStyle(
                            color: AppPalette.greyColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      complaintData['title'] as String? ?? 'No Title',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildTag(
                          '${complaintData['priority'] ?? 'Unknown'} Priority',
                          _getPriorityColor(complaintData['priority'] ?? ''),
                        ),
                        const SizedBox(width: 8),
                        _buildTag(
                          complaintData['department'] as String? ?? 'Unknown',
                          AppPalette.primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Status update button for admin
              if (isAdminView)
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showStatusChangeDialog,
                        icon: const Icon(Icons.update),
                        label: const Text('Update Status'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPalette.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

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
                  complaintData['description'] as String? ??
                      'No description provided',
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
                icon: _statusIcon(currentStatus),
                color: _statusColor(currentStatus),
                title: 'Status changed to ${currentStatus.toUpperCase()}',
                time:
                    '${(complaintData['submittedDaysAgo'] ?? 1) - 1} days ago',
              ),
              _TimelineItem(
                icon: Icons.send_outlined,
                color: AppPalette.primaryColor,
                title: 'Complaint submitted',
                time: '${complaintData['submittedDaysAgo'] ?? 0} days ago',
              ),

              const SizedBox(height: 16),

              // Comments section
              _SectionHeader(title: 'Comments'),

              // Add comment input
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppPalette.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppPalette.borderColor, width: 1),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _addComment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPalette.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                        ),
                        child: const Text('Post Comment'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Comments list
              if (complaintData['comments'] != null &&
                  (complaintData['comments'] as List).isNotEmpty)
                Column(
                  children: (complaintData['comments'] as List)
                      .map<Widget>(
                        (comment) => _CommentItem(
                          name: comment['author'] ?? 'Unknown',
                          time: comment['time'] ?? '',
                          comment: comment['text'] ?? '',
                          avatarUrl: comment['avatar'] ?? '',
                        ),
                      )
                      .toList(),
                )
              else
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppPalette.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppPalette.borderColor, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      'No comments yet',
                      style: TextStyle(
                        color: AppPalette.greyColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
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

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return AppPalette.greyColor;
    }
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
