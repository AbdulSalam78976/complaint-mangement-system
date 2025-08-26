import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/widgets/appbar.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/screens/widgets/new_compliant_form.dart';
import 'package:get/get.dart';

class ComplaintListScreen extends StatelessWidget {
  const ComplaintListScreen({super.key});

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
            _FiltersBar(),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: 10,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _ComplaintListItem(
                    title:
                        'Complaint #${index + 1}: Network outage on floor ${index % 5 + 1}',
                    department: 'IT Department',
                    priority: index % 3 == 0
                        ? 'High'
                        : (index % 3 == 1 ? 'Medium' : 'Low'),
                    status: index % 3 == 0
                        ? 'Open'
                        : (index % 3 == 1 ? 'In Progress' : 'Resolved'),
                    time: '${index + 1}h ago',
                    onTap: () => Get.toNamed(RouteName.complaintDetailsScreen),
                  );
                },
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
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _Chip(label: 'All', selected: true),
        SizedBox(width: 8),
        _Chip(label: 'Open'),
        SizedBox(width: 8),
        _Chip(label: 'In Progress'),
        SizedBox(width: 8),
        _Chip(label: 'Resolved'),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;

  const _Chip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _ComplaintListItem extends StatelessWidget {
  final String title;
  final String department;
  final String priority;
  final String status;
  final String time;
  final VoidCallback onTap;

  const _ComplaintListItem({
    required this.title,
    required this.department,
    required this.priority,
    required this.status,
    required this.time,
    required this.onTap,
  });

  Color _statusColor() {
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppPalette.whiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppPalette.borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppPalette.textColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor().withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _statusColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.apartment_outlined,
                  size: 16,
                  color: AppPalette.greyColor,
                ),
                const SizedBox(width: 6),
                Text(department, style: TextStyle(color: AppPalette.greyColor)),
                const SizedBox(width: 12),
                Icon(
                  Icons.flag_outlined,
                  size: 16,
                  color: AppPalette.greyColor,
                ),
                const SizedBox(width: 6),
                Text(priority, style: TextStyle(color: AppPalette.greyColor)),
                const Spacer(),
                Icon(Icons.access_time, size: 16, color: AppPalette.greyColor),
                const SizedBox(width: 6),
                Text(time, style: TextStyle(color: AppPalette.greyColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
