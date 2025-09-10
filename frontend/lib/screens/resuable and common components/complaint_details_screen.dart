import 'package:flutter/material.dart';
import 'package:frontend/models/complaint_model.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/appbar.dart';
import 'package:get/get.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  const ComplaintDetailsScreen({super.key});

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  late Complaint complaintData;
  late bool isAdminView;
  late String currentStatus;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // ✅ Get strongly-typed arguments
    final Map<String, dynamic> arguments =
        Get.arguments as Map<String, dynamic>;
    complaintData = arguments['complaint'] as Complaint;
    isAdminView = arguments['isAdminView'] as bool;

    currentStatus = complaintData.status;
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
        return Colors.green;
      case 'in progress':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'open':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
        return Icons.check_circle;
      case 'in progress':
        return Icons.sync;
      case 'rejected':
        return Icons.cancel;
      case 'pending':
        return Icons.pending;
      case 'open':
        return Icons.mark_email_unread;
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
              Text(
                'Update Status',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.textColor,
                ),
              ),
              const SizedBox(height: 24),
              StatefulBuilder(
                builder: (context, setDialogState) {
                  return Column(
                    children: statuses.map((status) {
                      final isSelected = selectedStatus == status;
                      final color = _statusColor(status);

                      return ListTile(
                        leading: Icon(_statusIcon(status), color: color),
                        title: Text(status),
                        trailing: isSelected
                            ? Icon(Icons.check, color: color)
                            : null,
                        onTap: () {
                          setDialogState(() {
                            selectedStatus = status;
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentStatus = selectedStatus;
                  });
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Status updated to $selectedStatus',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    final newComment = {
      'text': _commentController.text,
      'author': isAdminView ? 'Admin' : 'You',
      'time': 'Just now',
      'avatar': isAdminView
          ? 'https://via.placeholder.com/150/0000FF/FFFFFF?text=Admin'
          : 'https://via.placeholder.com/150/FF0000/FFFFFF?text=User',
    };

    setState(() {
      complaintData.comments.insert(0, newComment);
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Complaint ID
            Text(
              'Complaint #${complaintData.id}',
              style: TextStyle(fontSize: 14, color: AppPalette.greyColor),
            ),
            const SizedBox(height: 8),

            // ✅ Status badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(currentStatus).withOpacity(0.12),
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Icon(Icons.access_time, size: 16, color: AppPalette.greyColor),
                const SizedBox(width: 6),
                Text(
                  "Created: ${complaintData.createdAt}",
                  style: TextStyle(color: AppPalette.greyColor, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ✅ Title
            Text(
              complaintData.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppPalette.textColor,
              ),
            ),

            const SizedBox(height: 12),

            // ✅ Priority + Department
            Row(
              children: [
                _buildTag(
                  "${complaintData.priority} Priority",
                  _getPriorityColor(complaintData.priority),
                ),
                const SizedBox(width: 8),
                _buildTag(complaintData.category, AppPalette.primaryColor),
              ],
            ),

            const SizedBox(height: 16),

            // ✅ Description
            _SectionHeader(title: "Description"),
            Text(
              complaintData.description,
              style: TextStyle(color: AppPalette.textColor, height: 1.5),
            ),

            const SizedBox(height: 16),

            // ✅ Comments section
            _SectionHeader(title: "Comments"),
            _buildCommentBox(),
            const SizedBox(height: 12),

            if (complaintData.comments.isEmpty)
              Text(
                "No comments yet",
                style: TextStyle(color: AppPalette.greyColor),
              )
            else
              Column(
                children: complaintData.comments
                    .map(
                      (comment) => _CommentItem(
                        name: comment['author'] ?? 'Unknown',
                        comment: comment['text'] ?? '',
                        time: comment['time'] ?? '',
                        avatarUrl: comment['avatar'] ?? '',
                      ),
                    )
                    .toList(),
              ),
          ],
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

  Widget _buildCommentBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPalette.borderColor),
      ),
      child: Column(
        children: [
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Add a comment...",
              border: InputBorder.none,
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
              ),
              child: const Text("Post Comment"),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: AppPalette.textColor,
        ),
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
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(comment),
      trailing: Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
    );
  }
}
