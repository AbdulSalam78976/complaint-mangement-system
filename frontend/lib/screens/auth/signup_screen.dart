import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth%20controller/signup_controller.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final SignupController controller = Get.put(SignupController());

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
                    'assets/images/signup-image.jpeg',
                    fit: BoxFit.contain,
                    height: 500,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Join Our Platform",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppPalette.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Create your account to start exploring and managing your personalized dashboard.",
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

          // RIGHT SIDE - SIGNUP FORM
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
                child: _buildSignupForm(theme, context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Signup Form
  Widget _buildSignupForm(ThemeData theme, BuildContext context) {
    return Form(
      key: _formKey,
      child: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/cms-logo.png', height: 150),
            const SizedBox(height: 20),
            Text(
              "Create Account",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppPalette.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Sign up to get started",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppPalette.greyColor,
              ),
            ),
            const SizedBox(height: 40),

            // Name
            TextFormField(
              controller: controller.nameController,
              decoration: _inputDecoration("Full Name", Icons.person_outline),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Email
            TextFormField(
              controller: controller.emailController,
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
            const SizedBox(height: 20),

            // Password
            TextFormField(
              controller: controller.passwordController,
              obscureText: controller.obscureText.value,
              decoration: _inputDecoration("Password", Icons.lock_outline)
                  .copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscureText.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppPalette.secondaryColor,
                      ),
                      onPressed: controller.toggleObscureText,
                    ),
                  ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                if (!Utils.passwordRegex.hasMatch(value)) {
                  return 'Password must contain uppercase, lowercase, and a number';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            // Already have account
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.toNamed(RouteName.loginScreen),
                child: Text(
                  "Already have an account? Login",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppPalette.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          controller.signup();
                        }
                      },
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Sign Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Input decoration helper - Updated to use Icon instead of SVG
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppPalette.secondaryColor),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );
  }
}
