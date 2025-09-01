import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/appbar.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/notifications_dialogue.dart'
    as dialog;

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.backgroundColor,
      appBar: const CustomAppBar(title: 'Notifications', showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => dialog.showNotificationsDialog(),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open Dialog View'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.primaryColor,
                    foregroundColor: AppPalette.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      size: 48,
                      color: AppPalette.greyColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Pull notifications from API here',
                      style: TextStyle(color: AppPalette.greyColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
