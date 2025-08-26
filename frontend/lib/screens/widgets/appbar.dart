import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/widgets/help_dialogue.dart';
import 'package:frontend/screens/widgets/logout_dialogue.dart';
import 'package:frontend/screens/widgets/notifications_dialogue.dart';
import 'package:get/get.dart';
import 'package:frontend/resources/routes/routes_names.dart';

// Custom AppBar with notifications and profile menu
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLogo;
  final int notificationCount;
  final String profileImageUrl;
  final Color backgroundColor;
  final bool showNotifications;
  final bool showProfile;
  final bool showBack;
  final VoidCallback? onBackPressed;
  final String? semanticTitle;

  const CustomAppBar({
    Key? key,
    this.title = '',
    this.showLogo = true,
    this.notificationCount = 0,
    this.profileImageUrl =
        'https://images.unsplash.com/photo-1499714608240-22fc6ad53fb2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
    this.backgroundColor = Colors.white,
    this.showNotifications = true,
    this.showProfile = true,
    this.showBack = false,
    this.onBackPressed,
    this.semanticTitle,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: semanticTitle ?? title,
      child: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Row(
          children: [
            if (showBack)
              Semantics(
                button: true,
                label: 'Back button',
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed:
                        onBackPressed ?? () => Navigator.of(context).maybePop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.grey[700],
                      size: 20,
                    ),
                    tooltip: 'Back',
                  ),
                ),
              ),

            // Logo with conditional rendering
            if (showLogo)
              Semantics(
                image: true,
                label: 'App Logo',
                child: Image.asset(
                  'assets/images/cms-logo-header.png',
                  height: 40,
                ),
              ),

            // Title if provided
            if (title.isNotEmpty) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppPalette.textColor,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ] else
              const Spacer(),

            // Notification icon with badge
            if (showNotifications) _buildNotificationIcon(context),

            // Profile menu
            if (showProfile) _buildProfileMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Notifications',
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: showNotificationsDialog,
              icon: Icon(
                Icons.notifications_none_rounded,
                color: Colors.grey[600],
                size: 26,
              ),
              tooltip: 'Notifications',
            ),
          ),
          if (notificationCount > 0)
            Positioned(
              right: 16,
              top: 8,
              child: Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppPalette.primaryColor,
                      AppPalette.secondaryColor,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    notificationCount > 9 ? '9+' : notificationCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Profile menu',
      child: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'profile':
              Get.toNamed(RouteName.profileScreen);
              break;
            case 'settings':
              Get.toNamed(RouteName.settingsScreen);
              break;
            case 'help':
              showHelpDialog();
              break;
            case 'logout':
              showLogoutDialog();
              break;
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.1),
        tooltip: 'Profile options',
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'profile',
            child: Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  'My Profile',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'settings',
            child: Row(
              children: [
                Icon(
                  Icons.settings_outlined,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'help',
            child: Row(
              children: [
                Icon(
                  Icons.help_outline_rounded,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Help & Support',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout_rounded, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Text(
                  'Sign Out',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
        child: Semantics(
          button: true,
          label: 'User profile',
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).cardColor,
              backgroundImage: NetworkImage(profileImageUrl),
              onBackgroundImageError: (exception, stackTrace) {
                // Handle image loading error
                debugPrint('Profile image failed to load: $exception');
              },
              child: profileImageUrl.isEmpty
                  ? const Icon(Icons.person, size: 20)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
