import 'package:flutter/material.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/appbar.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/complaint_card.dart';
import 'package:get/get.dart';

class AdminComplaintManagement extends StatefulWidget {
  const AdminComplaintManagement({super.key});

  @override
  State<AdminComplaintManagement> createState() =>
      _AdminComplaintManagementState();
}

class _AdminComplaintManagementState extends State<AdminComplaintManagement> {
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Pending',
    'In Progress',
    'Resolved',
    'Rejected',
  ];

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
          _showExportDialog();
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
                  // Show search dialog
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(filter),
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
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
        ],
      ),
    );
  }

  Widget _buildComplaintList() {
    // Sample complaint data
    final complaints = [
      {
        'id': 'CMP-1001',
        'title': 'Network connectivity issue',
        'description': 'Unable to connect to the internet in the office',
        'status': 'Pending',
        'date': '2023-06-15',
        'priority': 'High',
        'user': 'John Doe',
        'department': 'IT Department',
        'time': '2 hours ago',
      },
      {
        'id': 'CMP-1002',
        'title': 'Software license expired',
        'description': 'Adobe Creative Cloud license has expired',
        'status': 'In Progress',
        'date': '2023-06-14',
        'priority': 'Medium',
        'user': 'Jane Smith',
        'department': 'IT Department',
        'time': '1 day ago',
      },
      {
        'id': 'CMP-1003',
        'title': 'Hardware malfunction',
        'description':
            'Printer not working properly in the marketing department',
        'status': 'Resolved',
        'date': '2023-06-10',
        'priority': 'Low',
        'user': 'Robert Johnson',
        'department': 'Maintenance',
        'time': '5 days ago',
      },
      {
        'id': 'CMP-1004',
        'title': 'Email delivery failure',
        'description': 'Emails not being delivered to external domains',
        'status': 'Rejected',
        'date': '2023-06-08',
        'priority': 'High',
        'user': 'Emily Davis',
        'department': 'IT Department',
        'time': '1 week ago',
      },
      {
        'id': 'CMP-1005',
        'title': 'Access control issue',
        'description': 'Unable to access shared drive for project files',
        'status': 'Pending',
        'date': '2023-06-07',
        'priority': 'Medium',
        'user': 'Michael Wilson',
        'department': 'IT Department',
        'time': '1 week ago',
      },
    ];

    // Filter complaints based on selected filter
    final filteredComplaints = _selectedFilter == 'All'
        ? complaints
        : complaints.where((c) => c['status'] == _selectedFilter).toList();

    return filteredComplaints.isEmpty
        ? Center(
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
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredComplaints.length,
            itemBuilder: (context, index) {
              final complaint = filteredComplaints[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: EnhancedComplaintCard(
                  title: complaint['title']!,
                  department: complaint['department']!,
                  priority: complaint['priority']!,
                  status: complaint['status']!,
                  time: complaint['time']!,
                  description: complaint['description']!,
                  onTap: () {
                    // Handle card tap
                    Get.toNamed(
                      RouteName.complaintDetailsScreen,
                      arguments: {'complaint': complaint, 'isAdminView': true},
                    );
                  },
                ),
              );
            },
          );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String status, Color color) {
    return InkWell(
      onTap: () {
        // Update status logic
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 1),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  void _showExportDialog() {
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
                _buildExportOption('PDF', Icons.picture_as_pdf, Colors.red),
                _buildExportOption('Excel', Icons.table_chart, Colors.green),
                _buildExportOption('CSV', Icons.insert_drive_file, Colors.blue),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildExportOption(String format, IconData icon, Color color) {
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
