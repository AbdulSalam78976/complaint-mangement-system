import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/resources/theme/colors.dart';

/// Show Success Dialog after Signup
void showSignupSuccessDialog() {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      backgroundColor: Colors.white.withOpacity(0.95), // ✅ glassy effect
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 520),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ Success Animation
              Lottie.asset(
                "assets/images/success.json",
                height: 220,
                repeat: false,
              ),
              const SizedBox(height: 16),

              // ✅ Heading
              Text(
                "🎉 Account Created!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // ✅ Message
              Text(
                "Your account has been created successfully.\n\n"
                "We've sent a verification email to your inbox.\n"
                "Please verify your email before logging in.",
                style: TextStyle(
                  fontSize: 14,
                  color: AppPalette.greyColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // ✅ Divider for clean separation
              Divider(
                thickness: 1,
                color: Colors.grey.withOpacity(0.2),
                height: 1,
              ),
              const SizedBox(height: 20),

              // ✅ Gradient Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppPalette.primaryColor,
                        AppPalette.secondaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Get.back(); // Close dialog
                      Get.offAllNamed(RouteName.loginScreen); // Go to login
                    },
                    child: const Text(
                      "Go to Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
