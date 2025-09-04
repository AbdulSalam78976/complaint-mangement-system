import 'package:flutter/material.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/utils/sessionmanager.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart'; // ✅ for animation

void showTokenExpiryDialogue() {
  if (Get.isDialogOpen ?? false) return;

  void redirectToLogin() async {
    if (Get.isDialogOpen ?? false) Get.back(); // close dialog
    await SessionManager.clearToken(); // clear token + data
    Get.offAllNamed(RouteName.loginScreen); // go to login
  }

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Warning Lottie animation
            Lottie.asset(
              "assets/animations/session_expired.json", // replace with your animation
              height: 150,
              repeat: false,
            ),
            const SizedBox(height: 20),

            // ✅ Title
            const Text(
              "Session Expired",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // ✅ Message
            const Text(
              "Your session has expired.\nPlease login again to continue.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),

            // ✅ Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: redirectToLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Login Now",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
