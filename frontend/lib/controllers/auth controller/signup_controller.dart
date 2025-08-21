import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  //
  RxBool obscureText = true.obs;
  // Reactive loading state
  var isLoading = false.obs;

  //toogle obscure text
  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  // Validation for signup fields
  bool validateFields() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields are required!",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        "Error",
        "Enter a valid email address",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar(
        "Error",
        "Password must be at least 6 characters long",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  // Signup logic (dummy API/Firebase)
  Future<void> signup() async {
    if (!validateFields()) return;

    try {
      isLoading.value = true;

      // Simulate API request
      await Future.delayed(const Duration(seconds: 2));

      // On success
      Get.snackbar(
        "Success",
        "Account created successfully!",
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to Login (or Home)
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        "Error",
        "Signup failed: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Dispose controllers
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
