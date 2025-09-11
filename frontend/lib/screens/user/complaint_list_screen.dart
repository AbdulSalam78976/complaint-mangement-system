import 'package:flutter/material.dart';
import 'package:frontend/controllers/complaint%20controller/complaints_controller.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/appbar.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/complaint_card.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/new_compliant_form.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class ComplaintListScreen extends StatelessWidget {
  ComplaintListScreen({super.key});

  final controller = Get.put(ComplaintController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.backgroundColor,
      appBar: const CustomAppBar(
        title: 'My Complaints',
        showBack: true,
        showLogo: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => _FiltersBar(
                selectedFilter: controller.selectedFilter.value,
                onFilterChanged: controller.changeFilter,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                () => controller.filteredComplaints.isEmpty
                    ? const Center(
                        child: Text(
                          'No complaints found',
                          style: TextStyle(
                            color: AppPalette.greyColor,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: controller.filteredComplaints.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final complaint =
                              controller.filteredComplaints[index];
                          return EnhancedComplaintCard(
                            title: complaint.title,
                            department: complaint.category,
                            priority: complaint.priority,
                            status: complaint.status,
                            time: timeago.format(complaint.createdAt),
                            description: complaint.description,
                            onTap: () => Get.toNamed(
                              RouteName.complaintDetailsScreen,
                              arguments: {
                                'complaint': complaint,
                                'isAdminView': false,
                              },
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showComplaintDialog(),
        backgroundColor: AppPalette.primaryColor,
        foregroundColor: AppPalette.whiteColor,
        icon: const Icon(Icons.add),
        label: const Text('New Complaint'),
      ),
    );
  }
}

class _FiltersBar extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const _FiltersBar({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Chip(
            label: 'All',
            selected: selectedFilter == 'All',
            onTap: () => onFilterChanged('All'),
          ),
          const SizedBox(width: 8),
          _Chip(
            label: 'Open',
            selected: selectedFilter == 'Open',
            onTap: () => onFilterChanged('Open'),
          ),
          const SizedBox(width: 8),
          _Chip(
            label: 'In Progress',
            selected: selectedFilter == 'In Progress',
            onTap: () => onFilterChanged('In Progress'),
          ),
          const SizedBox(width: 8),
          _Chip(
            label: 'Resolved',
            selected: selectedFilter == 'Resolved',
            onTap: () => onFilterChanged('Resolved'),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppPalette.primaryColor.withOpacity(0.1)
              : AppPalette.whiteColor,
          border: Border.all(
            color: selected ? AppPalette.primaryColor : AppPalette.borderColor,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppPalette.primaryColor : AppPalette.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
