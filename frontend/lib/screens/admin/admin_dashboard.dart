import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/appbar.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/overview_card.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/quickaction_card.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/recent_activity_card.dart'; // Import the new component
import 'package:get/get.dart';
import 'package:frontend/resources/routes/routes_names.dart';

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: OverviewCard(
                                title: 'Total Complaints',
                                value: '100',
                                icon: Icons.report_problem,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: OverviewCard(
                                title: 'Pending Complaints',
                                value: '50',
                                icon: Icons.pending_actions,
                                color: Colors.orange[300]!,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: OverviewCard(
                                title: 'Resolved Complaints',
                                value: '50',
                                icon: Icons.check_circle,
                                color: Colors.green[300]!,
                              ),
                            ),
                          ],
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
    final activities = [
      {
        'title': 'Complaint #1234 resolved',
        'description': 'Resolved by Admin',
        'time': '2 hours ago',
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'title': 'New user registered',
        'description': 'John Doe joined the system',
        'time': '3 hours ago',
        'icon': Icons.person_add,
        'color': Colors.blue,
      },
      {
        'title': 'Complaint #1235 assigned',
        'description': 'Assigned to Technical Team',
        'time': '5 hours ago',
        'icon': Icons.assignment_ind,
        'color': Colors.orange,
      },
      {
        'title': 'System maintenance',
        'description': 'Scheduled for tomorrow',
        'time': '1 day ago',
        'icon': Icons.build,
        'color': Colors.purple,
      },
    ];

    return RecentActivityList(
      activities: activities,
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(16),
      titleFontSize: 16,
      descriptionFontSize: 14,
      timeFontSize: 12,
    );
  }
}
