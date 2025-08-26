import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/widgets/appbar.dart';
import 'package:get/get.dart';

class ComplaintDetailsScreen extends StatelessWidget {
  const ComplaintDetailsScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    const status = 'In Progress';
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
                            color: _statusColor(status).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              color: _statusColor(status),
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
                          'Submitted: 2 days ago',
                          style: TextStyle(
                            color: AppPalette.greyColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildTag('Complaint', AppPalette.primaryColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Network Issues in Department',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppPalette.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildTag('IT Department', AppPalette.secondaryColor),
                        const SizedBox(width: 8),
                        _buildTag('High Priority', AppPalette.errorColor),
                      ],
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
                  'The network in our department has been unstable for the past week. We are experiencing frequent disconnections and slow internet speeds, which is affecting our productivity. We have tried restarting the router but the issue persists.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppPalette.textColor,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Assignee
              _SectionHeader(title: 'Assigned To'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppPalette.whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppPalette.borderColor, width: 1),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=774&q=80',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Smith',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppPalette.textColor,
                          ),
                        ),
                        Text(
                          'IT Support Staff',
                          style: TextStyle(
                            color: AppPalette.greyColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.chat_bubble_outline, size: 16),
                      label: const Text('Message'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppPalette.primaryColor),
                        foregroundColor: AppPalette.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Timeline
              _SectionHeader(title: 'Activity Timeline'),
              _TimelineItem(
                icon: Icons.assignment_turned_in_outlined,
                color: Colors.green,
                title: 'Status changed to IN PROGRESS',
                time: '2 hours ago',
              ),
              _TimelineItem(
                icon: Icons.person_add_alt_1_outlined,
                color: AppPalette.secondaryColor,
                title: 'Assigned to John Smith (IT Support)',
                time: '1 day ago',
              ),
              _TimelineItem(
                icon: Icons.send_outlined,
                color: AppPalette.primaryColor,
                title: 'Complaint submitted',
                time: '2 days ago',
              ),

              const SizedBox(height: 16),

              // Comments
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionHeader(title: 'Comments'),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_comment_outlined, size: 18),
                    label: const Text('Add Comment'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppPalette.primaryColor,
                    ),
                  ),
                ],
              ),
              _CommentItem(
                name: 'John Smith',
                time: '1 day ago',
                comment:
                    'We are looking into the issue. Have you tried connecting to the backup network?',
                avatarUrl:
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=774&q=80',
              ),
              _CommentItem(
                name: 'You',
                time: '12 hours ago',
                comment:
                    'Yes, we tried the backup network but it\'s also unstable. The issue seems to be affecting the entire floor.',
                avatarUrl:
                    'https://images.unsplash.com/photo-1499714608240-22fc6ad53fb2?auto=format&fit=crop&w=2070&q=80',
              ),

              const SizedBox(height: 24),

              // Bottom actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.flag_outlined),
                      label: const Text('Escalate'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primaryColor,
                        foregroundColor: AppPalette.whiteColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
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
