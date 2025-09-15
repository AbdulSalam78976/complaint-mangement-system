import 'package:flutter/material.dart';
import 'package:frontend/data/api_service.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/utils/sessionmanager.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final api = ApiService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var obscureText = true.obs;

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // ✅ Basic validation before request
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Missing Fields",
        "Please enter both email and password.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    try {
      isLoading.value = true;

      final result = await api.post('/auth/login', {
        'email': email,
        'password': password,
      }, requireAuth: false);

      if (result.isSuccess) {
        // ✅ Extract token
        final data = result.data as Map<String, dynamic>;
        final token = data['token'] as String?;

        if (token != null) {
          await SessionManager.saveToken(token);
        }
        Get.snackbar(
          "Login Successful 🎉",
          "Welcome back!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        );

        Future.delayed(const Duration(seconds: 1), () {
          SessionManager.navigateBasedOnRole();
        });
      } else {
        if (result.statusCode == 403) {
          // ✅ Email not verified case
          Get.snackbar(
            "Login Failed",
            "Please verify your email first",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.shade400,
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
          );
        } else {
          Get.snackbar(
            "Login Failed",
            result.errorMessage ?? "Invalid email or password",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade400,
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
