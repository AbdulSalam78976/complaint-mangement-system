import 'package:flutter/material.dart';
import 'package:frontend/controllers/complaint%20controller/complaints_controller.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/appbar.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/complaint_card.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class AdminComplaintManagement extends StatelessWidget {
  AdminComplaintManagement({super.key});

  final ComplaintController controller = Get.put(ComplaintController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Complaint Management',
        isAdmin: true,
        showBack: true,
        showLogo: false,
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(child: _buildComplaintList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppPalette.primaryColor,
        onPressed: () {
          _showExportDialog(context);
        },
        child: const Icon(Icons.download),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Complaints',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.textColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // TODO: Show search dialog
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.filters.map((filter) {
                  final isSelected = controller.selectedFilter.value == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(filter),
                      onSelected: (selected) {
                        controller.changeFilter(filter);
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: AppPalette.primaryColor.withOpacity(0.2),
                      checkmarkColor: AppPalette.primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppPalette.primaryColor
                            : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final complaints = controller.filteredComplaints;

      if (complaints.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No complaints found',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          final complaint = complaints[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: EnhancedComplaintCard(
              title: complaint.title,
              department: complaint.category,
              priority: complaint.priority,
              status: complaint.status,
              time: timeago.format(complaint.createdAt),
              description: complaint.description,
              onTap: () {
                Get.toNamed(
                  RouteName.complaintDetailsScreen,
                  arguments: {'complaint': complaint, 'isAdminView': true},
                );
              },
            ),
          );
        },
      );
    });
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Complaints'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select export format:'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildExportOption(
                  context,
                  'PDF',
                  Icons.picture_as_pdf,
                  Colors.red,
                ),
                _buildExportOption(
                  context,
                  'Excel',
                  Icons.table_chart,
                  Colors.green,
                ),
                _buildExportOption(
                  context,
                  'CSV',
                  Icons.insert_drive_file,
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildExportOption(
    BuildContext context,
    String format,
    IconData icon,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exporting as $format...'),
            backgroundColor: color,
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            format,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
