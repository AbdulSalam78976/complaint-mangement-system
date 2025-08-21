import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var obscureText = true.obs;

  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }

  @override
  void onClose() {
    // Don't dispose controllers here to avoid the error
    // The GetX controller lifecycle handles this automatically
    super.onClose();
  }

  void login() {
    // final email = emailController.text.trim();
    // final password = passwordController.text.trim();

    // isLoading.value = true;

    // Future.delayed(const Duration(seconds: 1), () {
    //   isLoading.value = false;

    //   // Clear controllers before navigation to prevent issues
    //   emailController.clear();
    //   passwordController.clear();

    //   if (email == 'teacher@example.com' && password == '123') {
    //     Get.offNamed(
    //       RouteName.teacherHomeScreen,
    //     ); // Use offNamed to remove current screen
    //   } else if (email == 'student@example.com' && password == '123') {
    //     Get.offNamed(
    //       RouteName.studentHomeScreen,
    //     ); // Use offNamed to remove current screen
    //   } else {
    //     Utils.snackBar(title: 'Error', message: 'Invalid credentials');
    //   }
    // });
  }
}
