import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:frontend/data/api_service.dart';
import 'package:frontend/models/complaint_model.dart';
import 'package:frontend/models/comment_model.dart';

class ComplaintController extends GetxController {
  final api = ApiService();

  // All complaints
  final complaints = <Complaint>[].obs;

  // Loading states
  final isLoading = false.obs;

  // Filters (use backend values)
  final filters = ['All', 'open', 'in progress', 'resolved'].obs;
  final selectedFilter = "All".obs;

  // Complaint details reactive states
  final comments = <Comment>[].obs; // Stores current complaint comments
  final selectedStatus = "".obs; // Tracks currently selected status

  @override
  void onInit() {
    super.onInit();
    fetchComplaints();
  }

  // Fetch complaints
  Future<void> fetchComplaints() async {
    try {
      isLoading.value = true;
      final response = await api.get('/complaints');
      if (response.isSuccess) {
        complaints.value = (response.data['items'] as List)
            .map((c) => Complaint.fromJson(c))
            .toList();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Filter complaints
  List<Complaint> get filteredComplaints {
    if (selectedFilter.value == 'All') {
      return complaints.toList();
    }
    return complaints
        .where(
          (c) => c.status.toLowerCase() == selectedFilter.value.toLowerCase(),
        )
        .toList();
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  // Refresh complaints
  Future<void> refreshComplaints() async {
    await fetchComplaints();
  }

  // Load comments for a specific complaint
  void loadComments(Complaint complaint) {
    comments
      ..clear()
      ..addAll(complaint.comments);
    selectedStatus.value = complaint.status;
  }

  // Add comment
  Future<void> addComment(
    String text,
    Complaint selectedComplaint, {
    bool isAdmin = false,
  }) async {
    try {
      isLoading.value = true;
      final response = await api.post(
        '/complaints/${selectedComplaint.id}/comments',
        {'body': text, 'admin': isAdmin, 'visibility': 'public'},
      );
      if (response.isSuccess) {
        // Fetch updated complaint
        final refreshed = await api.get('/complaints/${selectedComplaint.id}');
        if (refreshed.isSuccess) {
          final updatedComplaint = Complaint.fromJson(refreshed.data);
          loadComments(updatedComplaint);
        }
      } else {
        debugPrint(response.errorMessage);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Update complaint status
  Future<void> updateStatus(String complaintId, String newStatus) async {
    try {
      isLoading.value = true;
      final response = await api.put('/complaints/$complaintId/status', {
        'status': newStatus,
      });
      if (response.isSuccess) {
        selectedStatus.value = newStatus;
        await refreshComplaints();
      } else {
        debugPrint(response.errorMessage);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
