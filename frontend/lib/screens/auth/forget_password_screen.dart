import 'package:flutter/material.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          // LEFT SIDE - IMAGE + WELCOME
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/login-image.jpeg',
                    fit: BoxFit.contain,
                    height: 500,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Password Recovery",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppPalette.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Enter your email address and we'll send you a link to reset your password.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppPalette.greyColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // RIGHT SIDE - FORGET PASSWORD FORM
          Expanded(
            flex: 5,
            child: Center(
              child: Container(
                width: 450,
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppPalette.primaryColor.withOpacity(0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: _buildForgetPasswordForm(theme, context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Forget Password Form
  Widget _buildForgetPasswordForm(ThemeData theme, BuildContext context) {
    return Form(
      key: _formKey,
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/cms-logo.png', height: 150),
            const SizedBox(height: 20),
            Text(
              "Forgot Password?",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppPalette.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter your email to receive a password reset link",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppPalette.greyColor,
              ),
            ),
            const SizedBox(height: 40),

            // Email
            TextFormField(
              controller: emailController,
              decoration: _inputDecoration(
                "Email Address",
                Icons.email_outlined,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!Utils.isEmail(value.trim())) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),

            // Reset Password Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: isLoading.value
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _resetPassword();
                        }
                      },
                child: isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Send Reset Link"),
              ),
            ),
            const SizedBox(height: 20),

            // Back to Login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Remember your password?",
                  style: TextStyle(color: AppPalette.greyColor),
                ),
                TextButton(
                  onPressed: () => Get.toNamed(RouteName.loginScreen),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: AppPalette.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Input Decoration
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppPalette.secondaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppPalette.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppPalette.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppPalette.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppPalette.errorColor, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppPalette.errorColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  // Reset Password Logic
  void _resetPassword() {
    isLoading.value = true;
    
    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      
      // Show success message
      Get.snackbar(
        'Success',
        'Password reset link has been sent to your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate back to login screen after delay
      Future.delayed(const Duration(seconds: 2), () {
        Get.offNamed(RouteName.loginScreen);
      });
    });
  }
}