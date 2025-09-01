import 'package:flutter/material.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:get/get.dart';

void showLogoutDialog() {
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
          onPressed: () => Get.back(),
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
            Get.back();
            Get.offAllNamed(RouteName.loginScreen);
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
