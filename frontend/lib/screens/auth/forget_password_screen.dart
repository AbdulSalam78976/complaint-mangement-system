import 'package:flutter/material.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();

  final isLoading = false.obs;
  final emailExists = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final resendCountdown = 120.obs; // 2 minutes in seconds

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    // Start a countdown timer for resend functionality
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && resendCountdown.value > 0) {
        resendCountdown.value--;
        _startCountdown();
      }
    });
  }

  String _formatCountdown() {
    int minutes = resendCountdown.value ~/ 60;
    int seconds = resendCountdown.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _checkEmail() {
    if (_formKey.currentState!.validate()) {
      isLoading.value = true;

      // Simulate API call to check if email exists
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;

        // For demo purposes, assume email exists if it contains '@'
        if (emailController.text.contains('@')) {
          emailExists.value = true;
          Get.snackbar(
            'Code Sent',
            'A verification code has been sent to your email',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'This email is not registered with us',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      });
    }
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      isLoading.value = true;

      // Simulate password reset process
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;

        // Show success message and navigate back to login
        Get.snackbar(
          'Success',
          'Your password has been reset successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(RouteName.loginScreen);
        });
      });
    }
  }

  void _resendCode() {
    if (resendCountdown.value == 0) {
      resendCountdown.value = 120; // Reset to 2 minutes
      _startCountdown();

      // Show success message
      Get.snackbar(
        'Code Sent',
        'A new verification code has been sent to your email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

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
                  Obx(
                    () => Text(
                      emailExists.value
                          ? "Password Reset"
                          : "Password Recovery",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppPalette.secondaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Obx(
                      () => Text(
                        emailExists.value
                            ? "Enter the verification code and create a new password to secure your account."
                            : "Enter your email address and we'll send you a link to reset your password.",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppPalette.greyColor,
                        ),
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
              emailExists.value ? "Reset Password" : "Forgot Password?",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppPalette.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              emailExists.value
                  ? "Enter verification code and new password"
                  : "Enter your email to receive a password reset link",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppPalette.greyColor,
              ),
            ),
            const SizedBox(height: 40),

            if (!emailExists.value) ...[
              // Email Input
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
            ] else ...[
              // Verification Code
              TextFormField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(
                  "Verification Code",
                  Icons.sms_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the verification code';
                  }
                  if (value.length != 6) {
                    return 'Verification code must be 6 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // New Password
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword.value,
                decoration: _inputDecoration("New Password", Icons.lock_outline)
                    .copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppPalette.secondaryColor,
                        ),
                        onPressed: () {
                          obscurePassword.value = !obscurePassword.value;
                        },
                      ),
                    ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Confirm Password
              TextFormField(
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword.value,
                decoration:
                    _inputDecoration(
                      "Confirm Password",
                      Icons.lock_outline,
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirmPassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppPalette.secondaryColor,
                        ),
                        onPressed: () {
                          obscureConfirmPassword.value =
                              !obscureConfirmPassword.value;
                        },
                      ),
                    ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Resend Code Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: resendCountdown.value == 0 ? _resendCode : null,
                    child: Text(
                      "Resend",
                      style: TextStyle(
                        color: resendCountdown.value == 0
                            ? AppPalette.primaryColor
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Countdown timer
              Text(
                "Resend code in ${_formatCountdown()}",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppPalette.greyColor,
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Submit Button
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
                    : emailExists.value
                    ? _resetPassword
                    : _checkEmail,
                child: isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Reset Password"),
              ),
            ),
            const SizedBox(height: 20),

            // Back to Login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emailExists.value
                      ? "Remember your password?"
                      : "Already have an account?",
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
}
