import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/widgets/new_compliant_form.dart';
import 'package:frontend/screens/widgets/appbar.dart';
import 'package:frontend/screens/widgets/complaint_cards.dart';
import 'package:frontend/screens/widgets/overview_card.dart';
import 'package:frontend/screens/widgets/quickaction_card.dart';
import 'package:get/get.dart';
import 'package:frontend/resources/routes/routes_names.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard>
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
      appBar: const CustomAppBar(),
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome Back, John! 👋',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: AppPalette.whiteColor,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Track your complaints and stay updated with real-time progress monitoring.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppPalette.whiteColor.withOpacity(
                                        0.9,
                                      ),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppPalette.whiteColor.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.support_agent,
                                color: AppPalette.whiteColor,
                                size: 32,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Overview',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.whiteColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Overview Cards - Adjusted for the gradient background
                        LayoutBuilder(
                          builder: (context, constraints) {
                            bool isDesktop = constraints.maxWidth > 768;

                            if (isDesktop) {
                              // Desktop: All cards in one row
                              return Row(
                                children: [
                                  Expanded(
                                    child: OverviewCard(
                                      title: 'Total Complaints',
                                      value: '24',
                                      icon: Icons.receipt_long_outlined,
                                      color: AppPalette.whiteColor,
                                      backgroundColor: AppPalette.whiteColor
                                          .withOpacity(0.15),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OverviewCard(
                                      title: 'In Progress',
                                      value: '8',
                                      icon: Icons.schedule_outlined,
                                      color: AppPalette.whiteColor,
                                      backgroundColor: AppPalette.whiteColor
                                          .withOpacity(0.15),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OverviewCard(
                                      title: 'Resolved',
                                      value: '16',
                                      icon: Icons.check_circle_outline,
                                      color: AppPalette.whiteColor,
                                      backgroundColor: AppPalette.whiteColor
                                          .withOpacity(0.15),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OverviewCard(
                                      title: 'Avg. Response',
                                      value: '2.4 hrs',
                                      icon: Icons.speed_outlined,
                                      color: AppPalette.whiteColor,
                                      backgroundColor: AppPalette.whiteColor
                                          .withOpacity(0.15),
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
                                        child: OverviewCard(
                                          title: 'Total Complaints',
                                          value: '24',
                                          icon: Icons.receipt_long_outlined,
                                          color: AppPalette.whiteColor,
                                          backgroundColor: AppPalette.whiteColor
                                              .withOpacity(0.15),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: OverviewCard(
                                          title: 'In Progress',
                                          value: '8',
                                          icon: Icons.schedule_outlined,
                                          color: AppPalette.whiteColor,
                                          backgroundColor: AppPalette.whiteColor
                                              .withOpacity(0.15),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OverviewCard(
                                          title: 'Resolved',
                                          value: '16',
                                          icon: Icons.check_circle_outline,
                                          color: AppPalette.whiteColor,
                                          backgroundColor: AppPalette.whiteColor
                                              .withOpacity(0.15),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: OverviewCard(
                                          title: 'Avg. Response',
                                          value: '2.4 hrs',
                                          icon: Icons.speed_outlined,
                                          color: AppPalette.whiteColor,
                                          backgroundColor: AppPalette.whiteColor
                                              .withOpacity(0.15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Enhanced Quick Actions
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppPalette.textColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Enhanced Action Grid with Responsive Layout
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isDesktop = constraints.maxWidth > 768;

                      if (isDesktop) {
                        // Desktop: All actions in one row
                        return Row(
                          children: [
                            Expanded(
                              child: ActionCard(
                                title: 'New Complaint',
                                subtitle: 'Submit your complaint quickly',
                                icon: Icons.add_circle_outline,
                                color: AppPalette.primaryColor,
                                backgroundColor: AppPalette.primaryColor
                                    .withOpacity(0.1),
                                onTap: () => showComplaintDialog(),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ActionCard(
                                title: 'View All',
                                subtitle: 'Browse your complaints',
                                icon: Icons.list_alt,
                                color: AppPalette.greyColor,
                                backgroundColor: AppPalette.backgroundColor,
                                onTap: () =>
                                    Get.toNamed(RouteName.complaintFormScreen),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ActionCard(
                                title: 'Track Status',
                                subtitle: 'Real-time updates',
                                icon: Icons.track_changes_outlined,
                                color: AppPalette.successColor,
                                backgroundColor: AppPalette.successColor
                                    .withOpacity(0.1),
                                onTap: () =>
                                    Get.toNamed(RouteName.complaintListScreen),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ActionCard(
                                title: 'Analytics',
                                subtitle: 'View detailed reports',
                                icon: Icons.analytics_outlined,
                                color: AppPalette.secondaryColor,
                                backgroundColor: AppPalette.secondaryColor
                                    .withOpacity(0.1),
                                onTap: () =>
                                    Get.toNamed(RouteName.complaintListScreen),
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
                                    title: 'New Complaint',
                                    subtitle: 'Submit your complaint quickly',
                                    icon: Icons.add_circle_outline,
                                    color: AppPalette.primaryColor,
                                    backgroundColor: AppPalette.primaryColor
                                        .withOpacity(0.1),
                                    onTap: () => showComplaintDialog(),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ActionCard(
                                    title: 'View All',
                                    subtitle: 'Browse your complaints',
                                    icon: Icons.list_alt,
                                    color: AppPalette.greyColor,
                                    backgroundColor: AppPalette.backgroundColor,
                                    onTap: () => Get.toNamed(
                                      RouteName.complaintFormScreen,
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
                                    title: 'Track Status',
                                    subtitle: 'Real-time updates',
                                    icon: Icons.track_changes_outlined,
                                    color: AppPalette.successColor,
                                    backgroundColor: AppPalette.successColor
                                        .withOpacity(0.1),
                                    onTap: () => Get.toNamed(
                                      RouteName.complaintListScreen,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ActionCard(
                                    title: 'Analytics',
                                    subtitle: 'View detailed reports',
                                    icon: Icons.analytics_outlined,
                                    color: AppPalette.secondaryColor,
                                    backgroundColor: AppPalette.secondaryColor
                                        .withOpacity(0.1),
                                    onTap: () => Get.toNamed(
                                      RouteName.complaintListScreen,
                                    ),
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

                  // Enhanced Recent Complaints
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppPalette.textColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () =>
                            Get.toNamed(RouteName.complaintListScreen),
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: const Text('View All'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppPalette.primaryColor,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  EnhancedComplaintCard(
                    title: 'Network Infrastructure Upgrade',
                    department: 'IT Department',
                    priority: 'High',
                    status: 'Open',
                    time: '2 hours ago',
                    icon: Icons.router_outlined,
                    description:
                        'Experiencing intermittent connectivity issues across multiple floors.',
                  ),
                  const SizedBox(height: 16),
                  EnhancedComplaintCard(
                    title: 'HVAC System Maintenance',
                    department: 'Facilities Management',
                    priority: 'Medium',
                    status: 'In Progress',
                    time: '1 day ago',
                    icon: Icons.thermostat_outlined,
                    description:
                        'Temperature control issues in conference rooms 201-205.',
                  ),
                  const SizedBox(height: 16),
                  EnhancedComplaintCard(
                    title: 'Security Access Update',
                    department: 'Security Department',
                    priority: 'Low',
                    status: 'Resolved',
                    time: '3 days ago',
                    icon: Icons.security_outlined,
                    description:
                        'Key card access permissions have been successfully updated.',
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
