import 'package:flutter/material.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/utils/sessionmanager.dart';
import 'package:get/get.dart';

void showTokenExpiryDialogue() {
  if (Get.isDialogOpen ?? false) return;

  void redirectToLogin() async {
    if (Get.isDialogOpen ?? false) Get.back(); // close dialog
    await SessionManager.clearToken(); // clear token + data

    Get.offAllNamed(RouteName.loginScreen); // go to login
  }

  Get.defaultDialog(
    title: 'Session Expired',
    titleStyle: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.red,
    ),
    middleText: 'Your session has expired.\nPlease login again.',
    textConfirm: 'Login Now',
    confirmTextColor: Colors.white,
    buttonColor: Colors.red,
    radius: 12,
    onConfirm: redirectToLogin,
    barrierDismissible: false,
  );
}
