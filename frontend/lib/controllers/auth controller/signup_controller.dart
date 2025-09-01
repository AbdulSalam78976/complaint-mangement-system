import 'package:flutter/material.dart';
import 'package:frontend/resources/routes/routes_names.dart';
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

  // Signup logic (dummy API/Firebase)
  Future<void> signup() async {
    try {
      isLoading.value = true;

      // Simulate API request
      await Future.delayed(const Duration(seconds: 2));

      Get.toNamed(
        RouteName.emailVerificationScreen,
        arguments: {'email': emailController.text.trim()},
      );
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
