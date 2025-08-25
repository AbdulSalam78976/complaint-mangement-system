import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:get/get.dart';

void _showHelpDialog() {
  Get.dialog(
    AlertDialog(
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
            child: Icon(
              Icons.help_outline_rounded,
              color: AppPalette.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Help & Support',
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
            'If you have any questions or need assistance, please don\'t hesitate to contact our support team.',
            style: TextStyle(
              fontSize: 14,
              color: AppPalette.greyColor,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '📧 Email: support@cms.com',
            style: TextStyle(fontSize: 14, color: AppPalette.textColor),
          ),
          const SizedBox(height: 8),
          Text(
            '📞 Phone: +1 (555) 123-4567',
            style: TextStyle(fontSize: 14, color: AppPalette.textColor),
          ),
          const SizedBox(height: 8),
          Text(
            '🕒 Hours: Mon-Fri 9AM-5PM',
            style: TextStyle(fontSize: 14, color: AppPalette.textColor),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Get.back(),
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
