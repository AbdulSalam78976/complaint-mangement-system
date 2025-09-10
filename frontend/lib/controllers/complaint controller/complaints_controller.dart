import 'package:get/get.dart';
import 'package:frontend/data/api_service.dart';
import 'package:frontend/models/complaint_model.dart';

class ComplaintController extends GetxController {
  final api = ApiService();

  // All complaints
  final complaints = <Complaint>[].obs;

  // Selected complaint for details
  final selectedComplaint = Rxn<Complaint>();

  // Loading states
  final isLoading = false.obs;

  // Filters (use backend values)
  final filters = ['All', 'open', 'in progress', 'resolved'].obs;
  final selectedFilter = "All".obs;

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

  // Select complaint for details screen
  void selectComplaint(Complaint complaint) {
    selectedComplaint.value = complaint;
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

  // Add comment (local update for now)
  void addComment(String text, {bool isAdmin = false}) {
    if (selectedComplaint.value != null) {
      selectedComplaint.update((c) {
        c?.comments.insert(0, {
          'text': text,
          'author': isAdmin ? 'Admin' : 'You',
          'time': 'Just now',
          'avatar': isAdmin
              ? 'https://via.placeholder.com/150/0000FF/FFFFFF?text=Admin'
              : 'https://via.placeholder.com/150/FF0000/FFFFFF?text=User',
        });
      });
    }
  }

  void addComplaint(Complaint newComplaint) {
    complaints.insert(0, newComplaint);
  }
}
