import 'package:flutter/material.dart';
import 'package:frontend/data/api_service.dart';
import 'package:frontend/screens/auth/signup_sucess_dialogue.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final api = ApiService();
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

  Future<void> signup() async {
    try {
      isLoading.value = true;

      final result = await api.post('/auth/register', {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      }, requireAuth: false);

      if (result.isSuccess) {
        // ✅ Only show dialog, don't navigate here
        showSignupSuccessDialog();
      } else {
        if (result.statusCode == 409) {
          // 409 Conflict → email already exists
          Get.snackbar(
            "Signup Failed",
            "This email is already registered. Please use another one.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.shade400,
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
          );
        } else {
          Get.snackbar(
            "Signup Failed",
            result.errorMessage ?? "Signup failed",
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
        "Signup failed: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
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
