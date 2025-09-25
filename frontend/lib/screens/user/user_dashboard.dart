import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/new_compliant_form.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/appbar.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/complaint_card.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/quickaction_card.dart';
import 'package:get/get.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/controllers/complaint%20controller/complaints_controller.dart';
import 'package:frontend/models/complaint_model.dart';
import 'package:frontend/screens/resuable and common components/overview_card.dart';
import 'package:frontend/utils/sessionmanager.dart';

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
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    // Ensure controller is registered before first build so Obx(find) works
    Get.put(ComplaintController());
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

    _loadUserName();

    // Refresh complaints data when dashboard opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<ComplaintController>();
      controller.refreshComplaints();
    });
  }

  Future<void> _loadUserName() async {
    try {
      final decoded = await SessionManager.decodeToken();
      if (decoded != null && mounted) {
        final dynamic name = decoded['name'] ?? decoded['username'];
        final dynamic email = decoded['email'];
        final resolved = (name is String && name.trim().isNotEmpty)
            ? name.trim()
            : (email is String && email.contains('@')
                  ? email.split('@').first
                  : 'User');
        setState(() {
          _userName = resolved;
        });
      }
    } catch (_) {}
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
                                    'Welcome Back, $_userName! 👋',
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
                        // Overview Cards - Real data from API
                        Obx(() {
                          final controller = Get.find<ComplaintController>();
                          final complaints = controller.complaints;
                          final isLoading = controller.isLoading.value;
                          final totalComplaints = complaints.length;
                          final inProgressCount = complaints
                              .where((c) => c.status == 'in_progress')
                              .length;
                          final resolvedCount = complaints
                              .where((c) => c.status == 'resolved')
                              .length;
                          final avgResponseTime = _calculateAvgResponseTime(
                            complaints,
                          );

                          return LayoutBuilder(
                            builder: (context, constraints) {
                              bool isDesktop = constraints.maxWidth > 768;

                              if (isDesktop) {
                                // Desktop: All cards in one row
                                return Row(
                                  children: [
                                    Expanded(
                                      child: EnhancedOverviewCard(
                                        title: 'Total Complaints',
                                        value: totalComplaints.toString(),
                                        icon: Icons.receipt_long_outlined,

                                        isLoading: isLoading,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: EnhancedOverviewCard(
                                        title: 'In Progress',
                                        value: inProgressCount.toString(),
                                        icon: Icons.schedule_outlined,

                                        isLoading: isLoading,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: EnhancedOverviewCard(
                                        title: 'Resolved',
                                        value: resolvedCount.toString(),
                                        icon: Icons.check_circle_outline,

                                        isLoading: isLoading,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: EnhancedOverviewCard(
                                        title: 'Avg. Response',
                                        value: avgResponseTime,
                                        icon: Icons.speed_outlined,

                                        isLoading: isLoading,
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
                                          child: EnhancedOverviewCard(
                                            title: 'Total Complaints',
                                            value: totalComplaints.toString(),
                                            icon: Icons.receipt_long_outlined,

                                            isLoading: isLoading,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: EnhancedOverviewCard(
                                            title: 'In Progress',
                                            value: inProgressCount.toString(),
                                            icon: Icons.schedule_outlined,

                                            isLoading: isLoading,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: EnhancedOverviewCard(
                                            title: 'Resolved',
                                            value: resolvedCount.toString(),
                                            icon: Icons.check_circle_outline,

                                            isLoading: isLoading,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: EnhancedOverviewCard(
                                            title: 'Avg. Response',
                                            value: avgResponseTime,
                                            icon: Icons.speed_outlined,

                                            isLoading: isLoading,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                            },
                          );
                        }),
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

                  // Real complaints from API
                  Obx(() {
                    final controller = Get.find<ComplaintController>();
                    final isLoading = controller.isLoading.value;
                    final recentComplaints = controller.complaints
                        .take(3)
                        .toList();

                    if (isLoading && recentComplaints.isEmpty) {
                      return _buildLoadingComplaintsList();
                    }

                    if (recentComplaints.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppPalette.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppPalette.borderColor.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 48,
                              color: AppPalette.textColor.withOpacity(0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No complaints yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppPalette.textColor.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Submit your first complaint to get started',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppPalette.textColor.withOpacity(0.5),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: recentComplaints.map((complaint) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: EnhancedComplaintCard(
                            title: complaint.title,
                            department: complaint.category,
                            priority: complaint.priority,
                            status: complaint.status,
                            time: _formatTimeAgo(complaint.createdAt),
                            description: complaint.description,
                          ),
                        );
                      }).toList(),
                    );
                  }),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

  String _calculateAvgResponseTime(List<Complaint> complaints) {
    if (complaints.isEmpty) return '0 hrs';

    // Calculate response time for resolved complaints
    final resolvedComplaints = complaints
        .where((c) => c.status == 'resolved')
        .toList();

    if (resolvedComplaints.isEmpty) return 'N/A';

    double totalHours = 0;
    int validComplaints = 0;

    for (final complaint in resolvedComplaints) {
      final responseTime = complaint.updatedAt.difference(complaint.createdAt);
      final hours = responseTime.inHours + (responseTime.inMinutes / 60.0);

      if (hours > 0) {
        totalHours += hours;
        validComplaints++;
      }
    }

    if (validComplaints == 0) return 'N/A';

    final avgHours = totalHours / validComplaints;

    if (avgHours < 1) {
      final minutes = (avgHours * 60).round();
      return '${minutes}m';
    } else if (avgHours < 24) {
      return '${avgHours.toStringAsFixed(1)} hrs';
    } else {
      final days = (avgHours / 24).toStringAsFixed(1);
      return '${days} days';
    }
  }

  Widget _buildLoadingComplaintsList() {
    return Column(
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPalette.whiteColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Loading icon
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
                // Loading content
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
                      const SizedBox(height: 8),
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
          ),
        );
      }),
    );
  }
}
