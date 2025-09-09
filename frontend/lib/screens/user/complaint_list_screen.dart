import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/appbar.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/complaint_card.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/new_compliant_form.dart';
import 'package:get/get.dart';

class ComplaintListScreen extends StatefulWidget {
  const ComplaintListScreen({super.key});

  @override
  State<ComplaintListScreen> createState() => _ComplaintListScreenState();
}

class _ComplaintListScreenState extends State<ComplaintListScreen> {
  String _selectedFilter = 'All';
  final List<Map<String, dynamic>> _complaints = [];

  @override
  void initState() {
    super.initState();
    // Initialize with sample data
    _initializeComplaints();
  }

  void _initializeComplaints() {
    for (int i = 0; i < 10; i++) {
      _complaints.add({
        'id': "${i + 1}",
        'title': 'Complaint #${i + 1}: Network outage on floor ${i % 5 + 1}',
        'department': 'IT Department',
        'priority': i % 3 == 0 ? 'High' : (i % 3 == 1 ? 'Medium' : 'Low'),
        'status': i % 3 == 0
            ? 'Open'
            : (i % 3 == 1 ? 'In Progress' : 'Resolved'),
        'time': '${i + 1}h ago',
        'description':
            'Detailed description of complaint #${i + 1}. '
            'This is a longer description that explains the issue in more detail. '
            'The network outage has been affecting multiple users on floor ${i % 5 + 1}.',
        'icon': Icons.wifi_off, // Add appropriate icon for each complaint
      });
    }
  }

  List<Map<String, dynamic>> get _filteredComplaints {
    if (_selectedFilter == 'All') {
      return _complaints;
    } else {
      return _complaints
          .where((complaint) => complaint['status'] == _selectedFilter)
          .toList();
    }
  }

  void _handleFilterChange(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

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
            _FiltersBar(
              selectedFilter: _selectedFilter,
              onFilterChanged: _handleFilterChange,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredComplaints.isEmpty
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
                      itemCount: _filteredComplaints.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final complaint = _filteredComplaints[index];
                        return EnhancedComplaintCard(
                          title: complaint['title'],
                          department: complaint['department'],
                          priority: complaint['priority'],
                          status: complaint['status'],
                          time: complaint['time'],

                          description: complaint['description'] ?? '',
                          onTap: () => Get.toNamed(
                            RouteName.complaintDetailsScreen,
                            arguments: {
                              'complaint': complaint,
                              'isAdminView': false,
                              'status': complaint['status'],
                            },
                          ),
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
