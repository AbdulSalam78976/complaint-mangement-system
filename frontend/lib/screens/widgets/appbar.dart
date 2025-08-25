import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/widgets/notifications_dialogue.dart';

// Custom AppBar with notifications and profile menu
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String logoAssetPath;
  final double logoHeight;
  final int notificationCount;
  final String profileImageUrl;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onHelpPressed;
  final VoidCallback? onLogoutPressed;
  final Color backgroundColor;
  final bool showNotifications;
  final bool showProfile;

  const CustomAppBar({
    Key? key,
    this.title = '',
    this.logoAssetPath = 'assets/images/cms-logo-header.png',
    this.logoHeight = 50,
    this.notificationCount = 0,
    this.profileImageUrl =
        'https://images.unsplash.com/photo-1499714608240-22fc6ad53fb2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',

    this.onProfilePressed,
    this.onSettingsPressed,
    this.onHelpPressed,
    this.onLogoutPressed,
    this.backgroundColor = Colors.white,
    this.showNotifications = true,
    this.showProfile = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      title: Row(
        children: [
          // Logo
          Image.asset(logoAssetPath, height: logoHeight),

          // Title if provided
          if (title.isNotEmpty) ...[
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],

          const Spacer(),

          // Notification icon with badge
          if (showNotifications) _buildNotificationIcon(context),

          // Profile menu
          if (showProfile) _buildProfileMenu(context),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return Stack(
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
                  colors: [AppPalette.primaryColor, AppPalette.secondaryColor],
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
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'profile':
            onProfilePressed?.call();
            break;
          case 'settings':
            onSettingsPressed?.call();
            break;
          case 'help':
            onHelpPressed?.call();
            break;
          case 'logout':
            onLogoutPressed?.call();
            break;
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
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
              Icon(Icons.settings_outlined, color: Colors.grey[600], size: 20),
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
              Icon(Icons.logout_rounded, size: 20),
              const SizedBox(width: 12),
              Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!, width: 2),
        ),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Theme.of(context).cardColor,
          backgroundImage: NetworkImage(profileImageUrl),
        ),
      ),
    );
  }
}
