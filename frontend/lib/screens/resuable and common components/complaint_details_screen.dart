import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:frontend/controllers/complaint_controller.dart';
import 'package:frontend/models/complaint_model.dart';
import 'package:frontend/resources/theme/colors.dart';

class ComplaintDetailsScreen extends StatelessWidget {
  final Complaint complaint;
  final controller = Get.put(ComplaintController());

  ComplaintDetailsScreen({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    controller.loadComments(complaint);

    return Scaffold(
      appBar: AppBar(title: const Text("Complaint Details")),
      body: Obx(() {
        return controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Complaint Info
                    Text(
                      complaint.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(complaint.description),
                    const Divider(height: 32),

                    // Status Dropdown
                    Row(
                      children: [
                        const Text(
                          "Status: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Obx(
                          () => DropdownButton<String>(
                            value: controller.selectedStatus.value.isEmpty
                                ? complaint.status
                                : controller.selectedStatus.value,
                            items: controller.filters
                                .where((f) => f != "All")
                                .map((status) {
                                  return DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  );
                                })
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.updateStatus(complaint.id, value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // Comments Section
                    const Text(
                      "Comments",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Obx(() {
                      if (controller.comments.isEmpty) {
                        return const Text(
                          "No comments yet",
                          style: TextStyle(color: AppColors.grey),
                        );
                      }
                      return Column(
                        children: controller.comments.map((comment) {
                          return _CommentItem(
                            name: comment.user.name ?? "Unknown",
                            comment: comment.body,
                            time: DateFormat(
                              'dd MMM, hh:mm a',
                            ).format(comment.createdAt),
                            avatarUrl: comment.user.avatar ?? "",
                          );
                        }).toList(),
                      );
                    }),

                    const SizedBox(height: 16),

                    // Add Comment Box
                    _AddCommentBox(complaint: complaint),
                  ],
                ),
              );
      }),
    );
  }
}

// ===================== Comment Item =====================
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
      leading: CircleAvatar(
        backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
        child: avatarUrl.isEmpty ? const Icon(Icons.person) : null,
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(comment),
      trailing: Text(
        time,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}

// ===================== Add Comment Box =====================
class _AddCommentBox extends StatefulWidget {
  final Complaint complaint;

  const _AddCommentBox({required this.complaint});

  @override
  State<_AddCommentBox> createState() => _AddCommentBoxState();
}

class _AddCommentBoxState extends State<_AddCommentBox> {
  final TextEditingController _controller = TextEditingController();
  final complaintController = Get.find<ComplaintController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Add a comment...",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.send, color: Colors.blue),
          onPressed: () async {
            if (_controller.text.trim().isNotEmpty) {
              await complaintController.addComment(
                _controller.text.trim(),
                widget.complaint,
                isAdmin: false,
              );
              _controller.clear();
            }
          },
        ),
      ],
    );
  }
}
