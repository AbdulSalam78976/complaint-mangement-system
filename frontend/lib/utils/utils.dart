import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Utils {
  static final formattedDate = DateFormat(
    'MMMM d, yyyy',
  ).format(DateTime.now());

  /// Show a custom snackbar
  static void snackBar({
    required String title,
    required String message,
    Color? backgroundColor,
    IconData? icon,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor:
          backgroundColor ?? AppPalette.primaryColor.withOpacity(0.9),
      colorText: AppPalette.whiteColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      icon: icon != null ? Icon(icon, color: AppPalette.whiteColor) : null,
      duration: const Duration(seconds: 3),
    );
  }

  /// Validate email format
  static bool isEmail(String email) {
    return GetUtils.isEmail(email);
  }

  static final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$');
}
