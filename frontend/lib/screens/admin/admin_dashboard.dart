import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/appbar.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/overview_card.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/quickaction_card.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/recent_activity_card.dart';
import 'package:get/get.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/controllers/complaint%20controller/complaints_controller.dart';
import 'package:frontend/controllers/admin%20controller/admin_controller.dart';
import 'package:frontend/models/complaint_model.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();

    // Initialize controllers and refresh data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final complaintController = Get.find<ComplaintController>();
      final adminController = Get.find<AdminController>();
      complaintController.refreshComplaints();
      adminController.fetchUsers();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.backgroundColor,
      appBar: const CustomAppBar(isAdmin: true),
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Combined Welcome and Overview Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppPalette.primaryColor,
                          AppPalette.secondaryColor,
                          AppPalette.primaryColor.withOpacity(0.9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppPalette.primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.admin_panel_settings,
                                size: 36,
                                color: AppPalette.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome, Admin',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Manage all complaints and users',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: Colors.white30),
                        const SizedBox(height: 24),
                        // Real data from API
                        GetBuilder<ComplaintController>(
                          builder: (controller) {
                            final complaints = controller.complaints;
                            final totalComplaints = complaints.length;
                            final pendingCount = complaints
                                .where(
                                  (c) =>
                                      c.status == 'pending' ||
                                      c.status == 'open',
                                )
                                .length;
                            final resolvedCount = complaints
                                .where((c) => c.status == 'resolved')
                                .length;
                            final isLoading = controller.isLoading.value;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: EnhancedOverviewCard(
                                    title: 'Total Complaints',
                                    value: totalComplaints.toString(),
                                    icon: Icons.report_problem,

                                    isLoading: isLoading,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: EnhancedOverviewCard(
                                    title: 'Pending Complaints',
                                    value: pendingCount.toString(),
                                    icon: Icons.pending_actions,

                                    isLoading: isLoading,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: EnhancedOverviewCard(
                                    title: 'Resolved Complaints',
                                    value: resolvedCount.toString(),
                                    icon: Icons.check_circle,

                                    isLoading: isLoading,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Quick Actions Section
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppPalette.textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isDesktop = constraints.maxWidth > 768;

                      if (isDesktop) {
                        // Desktop: All actions in one row
                        return Row(
                          children: [
                            Expanded(
                              child: ActionCard(
                                title: 'Manage Complaints',
                                subtitle: 'View and manage all complaints',
                                icon: Icons.report_problem,
                                color: AppPalette.primaryColor,
                                backgroundColor: AppPalette.primaryColor
                                    .withOpacity(0.1),
                                onTap: () => Get.toNamed(
                                  RouteName.adminComplaintManagement,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ActionCard(
                                title: "Manage Users",
                                subtitle: 'Manage system users',
                                icon: Icons.people,
                                color: AppPalette.secondaryColor,
                                backgroundColor: AppPalette.secondaryColor
                                    .withOpacity(0.1),
                                onTap: () =>
                                    Get.toNamed(RouteName.adminUserManagement),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ActionCard(
                                title: "Analytics",
                                subtitle: 'View system analytics',
                                icon: Icons.analytics,
                                color: AppPalette.accentColor,
                                backgroundColor: AppPalette.accentColor
                                    .withOpacity(0.1),
                                onTap: () =>
                                    Get.toNamed(RouteName.adminReports),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ActionCard(
                                title: "Settings",
                                subtitle: 'System configuration',
                                icon: Icons.settings,
                                color: AppPalette.greyColor,
                                backgroundColor: AppPalette.greyColor
                                    .withOpacity(0.1),
                                onTap: () =>
                                    Get.toNamed(RouteName.settingsScreen),
                              ),
                            ),
                          ],
                        );
                      } else {
                        // Mobile: 2x2 Grid
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ActionCard(
                                    title: 'Manage Complaints',
                                    subtitle: 'View and manage complaints',
                                    icon: Icons.report_problem,
                                    color: AppPalette.primaryColor,
                                    backgroundColor: AppPalette.primaryColor
                                        .withOpacity(0.1),
                                    onTap: () => Get.toNamed(
                                      RouteName.adminComplaintManagement,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ActionCard(
                                    title: 'Manage Users',
                                    subtitle: 'Manage system users',
                                    icon: Icons.people,
                                    color: AppPalette.secondaryColor,
                                    backgroundColor: AppPalette.secondaryColor
                                        .withOpacity(0.1),
                                    onTap: () => Get.toNamed(
                                      RouteName.adminUserManagement,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ActionCard(
                                    title: 'Analytics',
                                    subtitle: 'View system analytics',
                                    icon: Icons.analytics,
                                    color: AppPalette.accentColor,
                                    backgroundColor: AppPalette.accentColor
                                        .withOpacity(0.1),
                                    onTap: () =>
                                        Get.toNamed(RouteName.adminReports),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ActionCard(
                                    title: 'Settings',
                                    subtitle: 'System configuration',
                                    icon: Icons.settings,
                                    color: AppPalette.greyColor,
                                    backgroundColor: AppPalette.greyColor
                                        .withOpacity(0.1),
                                    onTap: () =>
                                        Get.toNamed(RouteName.settingsScreen),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 32),

                  // Recent Activity Section - Updated to use the new component
                  Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppPalette.textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRecentActivityList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivityList() {
    return GetBuilder<ComplaintController>(
      builder: (controller) {
        final isLoading = controller.isLoading.value;
        final complaints = controller.complaints;

        if (isLoading && complaints.isEmpty) {
          return _buildLoadingActivityList();
        }

        // Generate real activities from complaints
        final activities = _generateRealActivities(complaints);

        return RecentActivityList(
          activities: activities,
          padding: const EdgeInsets.all(20),
          borderRadius: BorderRadius.circular(16),
          titleFontSize: 16,
          descriptionFontSize: 14,
          timeFontSize: 12,
        );
      },
    );
  }

  List<Map<String, dynamic>> _generateRealActivities(
    List<Complaint> complaints,
  ) {
    final activities = <Map<String, dynamic>>[];

    // Get recent complaints (last 5)
    final recentComplaints = complaints.take(5).toList();

    for (final complaint in recentComplaints) {
      String title;
      String description;
      IconData icon;
      Color color;

      switch (complaint.status) {
        case 'open':
          title = 'New Complaint Submitted';
          description = 'Complaint: ${complaint.title}';
          icon = Icons.report_problem;
          color = Colors.blue;
          break;
        case 'pending':
          title = 'Complaint Pending Review';
          description = 'Complaint: ${complaint.title}';
          icon = Icons.schedule;
          color = Colors.orange;
          break;
        case 'in_progress':
          title = 'Complaint In Progress';
          description = 'Complaint: ${complaint.title}';
          icon = Icons.work;
          color = Colors.purple;
          break;
        case 'resolved':
          title = 'Complaint Resolved';
          description = 'Complaint: ${complaint.title}';
          icon = Icons.check_circle;
          color = Colors.green;
          break;
        case 'closed':
          title = 'Complaint Closed';
          description = 'Complaint: ${complaint.title}';
          icon = Icons.cancel;
          color = Colors.grey;
          break;
        default:
          title = 'Complaint Updated';
          description = 'Complaint: ${complaint.title}';
          icon = Icons.update;
          color = Colors.indigo;
      }

      activities.add({
        'title': title,
        'description': description,
        'time': _formatTimeAgo(complaint.updatedAt),
        'icon': icon,
        'color': color,
      });
    }

    // If no complaints, show a default message
    if (activities.isEmpty) {
      activities.add({
        'title': 'No Recent Activity',
        'description': 'No complaints have been submitted yet',
        'time': 'N/A',
        'icon': Icons.info,
        'color': Colors.grey,
      });
    }

    return activities;
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  Widget _buildLoadingActivityList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(4, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppPalette.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppPalette.primaryColor.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppPalette.textColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: 120,
                        decoration: BoxDecoration(
                          color: AppPalette.textColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppPalette.textColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
