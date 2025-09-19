import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/appbar.dart';
import 'package:get/get.dart';
import 'package:frontend/utils/sessionmanager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final decodedToken = await SessionManager.decodeToken();
      setState(() {
        userData = decodedToken;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.backgroundColor,
      appBar: const CustomAppBar(
        title: 'My Profile',
        showBack: true,
        showLogo: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _HeaderCard(userData: userData),
                  const SizedBox(height: 16),
                  _InfoCard(userData: userData),
                  const SizedBox(height: 16),
                  _SecurityCard(),
                ],
              ),
            ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const _HeaderCard({this.userData});

  @override
  Widget build(BuildContext context) {
    final name = userData?['name'] ?? 'User';
    final email = userData?['email'] ?? 'user@example.com';
    final userId = userData?['userId'] ?? 'N/A';
    final role = userData?['role'] ?? 'user';
    final initials = name.isNotEmpty
        ? name.split(' ').map((n) => n[0]).join('').toUpperCase()
        : 'U';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppPalette.borderColor, width: 2),
            ),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: AppPalette.primaryColor.withOpacity(0.1),
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppPalette.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(email, style: TextStyle(color: AppPalette.greyColor)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _Pill(text: 'User ID: $userId'),
                    const SizedBox(width: 8),
                    _Pill(text: 'Role: ${role.toUpperCase()}'),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement edit profile functionality
              Get.snackbar(
                'Feature Coming Soon',
                'Edit profile functionality will be implemented soon',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppPalette.primaryColor,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.primaryColor,
              foregroundColor: AppPalette.whiteColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const _InfoCard({this.userData});

  @override
  Widget build(BuildContext context) {
    final name = userData?['name'] ?? 'User';
    final email = userData?['email'] ?? 'user@example.com';
    final phone = userData?['phone'] ?? 'Not provided';
    final department = userData?['department'] ?? 'Not specified';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Personal Information'),
          const SizedBox(height: 12),
          _FieldRow(label: 'Full Name', value: name),
          _FieldRow(label: 'Email', value: email),
          _FieldRow(label: 'Phone', value: phone),
          _FieldRow(label: 'Department', value: department),
        ],
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Security'),
          const SizedBox(height: 12),
          _ActionRow(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _ActionRow(
            icon: Icons.security_outlined,
            title: 'Two-Factor Authentication',
            subtitle: 'Protect your account with 2FA',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppPalette.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppPalette.primaryColor.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppPalette.primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppPalette.textColor,
        letterSpacing: -0.2,
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final String value;
  const _FieldRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: TextStyle(color: AppPalette.greyColor)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppPalette.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPalette.borderColor),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppPalette.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppPalette.primaryColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppPalette.textColor,
          ),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: AppPalette.greyColor)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppPalette.greyColor,
        ),
        onTap: onTap,
      ),
    );
  }
}
