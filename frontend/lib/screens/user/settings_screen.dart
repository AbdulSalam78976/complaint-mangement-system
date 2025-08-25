import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:get/get.dart';
import 'package:frontend/screens/widgets/appbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.backgroundColor,
      appBar: const CustomAppBar(title: 'Settings', showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile Section
          const _ProfileSection(),
          const SizedBox(height: 24),

          // Preferences Section
          const _SectionHeader(title: 'Preferences'),
          _SettingsItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () {
              // Navigate to notification settings
            },
            hasSwitch: false,
          ),
          _SettingsItem(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Toggle dark theme',
            onTap: () {},
            hasSwitch: true,
            switchValue: false,
            onSwitchChanged: (value) {
              // Toggle theme
            },
          ),
          _SettingsItem(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'Change app language',
            onTap: () {
              // Navigate to language settings
            },
            hasSwitch: false,
          ),

          const SizedBox(height: 24),

          // Security Section
          const _SectionHeader(title: 'Security'),
          _SettingsItem(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () {
              // Navigate to change password screen
            },
            hasSwitch: false,
          ),
          _SettingsItem(
            icon: Icons.security_outlined,
            title: 'Two-Factor Authentication',
            subtitle: 'Enable 2FA for extra security',
            onTap: () {},
            hasSwitch: true,
            switchValue: false,
            onSwitchChanged: (value) {
              // Toggle 2FA
            },
          ),

          const SizedBox(height: 24),

          // Support Section
          const _SectionHeader(title: 'Support'),
          _SettingsItem(
            icon: Icons.help_outline,
            title: 'Help Center',
            subtitle: 'Get help with using the app',
            onTap: () {
              // Navigate to help center
            },
            hasSwitch: false,
          ),
          _SettingsItem(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            subtitle: 'Help us improve the app',
            onTap: () {
              // Navigate to feedback form
            },
            hasSwitch: false,
          ),
          _SettingsItem(
            icon: Icons.chat_outlined,
            title: 'Contact Support',
            subtitle: 'Get in touch with our team',
            onTap: () {
              // Navigate to contact support
            },
            hasSwitch: false,
          ),

          const SizedBox(height: 24),

          // About Section
          const _SectionHeader(title: 'About'),
          _SettingsItem(
            icon: Icons.info_outline,
            title: 'About App',
            subtitle: 'Version 1.0.0',
            onTap: () {
              // Show about dialog
              _showAboutDialog(context);
            },
            hasSwitch: false,
          ),
          _SettingsItem(
            icon: Icons.policy_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () {
              // Navigate to privacy policy
            },
            hasSwitch: false,
          ),
          _SettingsItem(
            icon: Icons.gavel_outlined,
            title: 'Terms of Service',
            subtitle: 'Read our terms and conditions',
            onTap: () {
              // Navigate to terms of service
            },
            hasSwitch: false,
          ),

          const SizedBox(height: 32),

          // Logout Button
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                _showLogoutDialog(context);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.errorColor,
                foregroundColor: AppPalette.whiteColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppPalette.whiteColor,
        elevation: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppPalette.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.logout_rounded, color: AppPalette.errorColor),
            ),
            const SizedBox(width: 12),
            Text(
              'Sign Out',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppPalette.textColor,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to sign out of your account?',
          style: TextStyle(
            fontSize: 14,
            color: AppPalette.greyColor,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppPalette.greyColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Get.offAllNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.errorColor,
              foregroundColor: AppPalette.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppPalette.whiteColor,
        elevation: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppPalette.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.info_outline, color: AppPalette.primaryColor),
            ),
            const SizedBox(width: 12),
            Text(
              'About CMS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppPalette.textColor,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Complaint Management System',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppPalette.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 14, color: AppPalette.greyColor),
            ),
            const SizedBox(height: 16),
            Text(
              'A comprehensive solution for managing and tracking complaints efficiently.',
              style: TextStyle(
                fontSize: 14,
                color: AppPalette.greyColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2024 CMS Team. All rights reserved.',
              style: TextStyle(fontSize: 12, color: AppPalette.greyColor),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.primaryColor,
              foregroundColor: AppPalette.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Got it',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppPalette.borderColor, width: 2),
            ),
            child: const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1499714608240-22fc6ad53fb2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'John Doe',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppPalette.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'john.doe@example.com',
            style: TextStyle(fontSize: 14, color: AppPalette.greyColor),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              // Navigate to edit profile
            },
            icon: Icon(
              Icons.edit_outlined,
              size: 18,
              color: AppPalette.primaryColor,
            ),
            label: Text(
              'Edit Profile',
              style: TextStyle(
                color: AppPalette.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppPalette.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppPalette.textColor,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool hasSwitch;
  final bool? switchValue;
  final Function(bool)? onSwitchChanged;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.hasSwitch,
    this.switchValue,
    this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppPalette.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppPalette.primaryColor, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppPalette.textColor,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppPalette.greyColor, fontSize: 14),
        ),
        trailing: hasSwitch
            ? Switch(
                value: switchValue ?? false,
                onChanged: onSwitchChanged,
                activeColor: AppPalette.primaryColor,
                activeTrackColor: AppPalette.primaryColor.withOpacity(0.3),
                inactiveThumbColor: AppPalette.greyColor,
                inactiveTrackColor: AppPalette.borderColor,
              )
            : Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppPalette.greyColor,
              ),
        onTap: hasSwitch ? null : onTap,
      ),
    );
  }
}
