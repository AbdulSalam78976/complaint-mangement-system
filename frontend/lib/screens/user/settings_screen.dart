import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile Section
          const _ProfileSection(),
          const SizedBox(height: 24),
          
          // Preferences Section
          const _SectionHeader(title: 'Preferences'),
          _SettingsItem(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () {
              // Navigate to notification settings
            },
            hasSwitch: false,
          ),
          _SettingsItem(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Toggle dark theme',
            onTap: () {},
            hasSwitch: true,
            switchValue: false,
            onSwitchChanged: (value) {
              // Toggle theme
            },
          ),
          
          const SizedBox(height: 24),
          
          // Security Section
          const _SectionHeader(title: 'Security'),
          _SettingsItem(
            icon: Icons.lock,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () {
              // Navigate to change password screen
            },
            hasSwitch: false,
          ),
          _SettingsItem(
            icon: Icons.fingerprint,
            title: 'Biometric Authentication',
            subtitle: 'Use fingerprint to login',
            onTap: () {},
            hasSwitch: true,
            switchValue: true,
            onSwitchChanged: (value) {
              // Toggle biometric auth
            },
          ),
          
          const SizedBox(height: 24),
          
          // Support Section
          const _SectionHeader(title: 'Support'),
          _SettingsItem(
            icon: Icons.help,
            title: 'Help Center',
            subtitle: 'Get help with using the app',
            onTap: () {
              // Navigate to help center
            },
            hasSwitch: false,
          ),
          _SettingsItem(
            icon: Icons.feedback,
            title: 'Send Feedback',
            subtitle: 'Help us improve the app',
            onTap: () {
              // Navigate to feedback form
            },
            hasSwitch: false,
          ),
          
          const SizedBox(height: 24),
          
          // About Section
          const _SectionHeader(title: 'About'),
          _SettingsItem(
            icon: Icons.info,
            title: 'About App',
            subtitle: 'Version 1.0.0',
            onTap: () {
              // Show about dialog
            },
            hasSwitch: false,
          ),
          _SettingsItem(
            icon: Icons.policy,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () {
              // Navigate to privacy policy
            },
            hasSwitch: false,
          ),
          
          const SizedBox(height: 24),
          
          // Logout Button
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                // Logout functionality
                Get.offAllNamed('/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1499714608240-22fc6ad53fb2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'john.doe@example.com',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              // Navigate to edit profile
            },
            child: const Text('Edit Profile'),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
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
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: hasSwitch
            ? Switch(
                value: switchValue ?? false,
                onChanged: onSwitchChanged,
                activeColor: Colors.blue,
              )
            : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: hasSwitch ? null : onTap,
      ),
    );
  }
}