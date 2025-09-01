import 'package:flutter/material.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:get/get.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email = Get.arguments['email'];

  EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  int _resendCountdown = 150; // 2 minutes 30 seconds in seconds

  @override
  void initState() {
    super.initState();
    _startCountdown();

    // Set up focus node listeners
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (!_focusNodes[i].hasFocus && _codeControllers[i].text.isEmpty) {
          // Optionally handle when a field loses focus and is empty
        }
      });
    }
  }

  void _startCountdown() {
    // Start a countdown timer for resend functionality
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
        _startCountdown();
      }
    });
  }

  String _formatCountdown() {
    int minutes = _resendCountdown ~/ 60;
    int seconds = _resendCountdown % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      // Move to next field
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      // Move to previous field when backspace is pressed
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }

    // Auto-submit when all fields are filled
    if (index == 5 && value.isNotEmpty) {
      _verifyCode();
    }
  }

  void _verifyCode() {
    // Combine all code fields
    String verificationCode = _codeControllers
        .map((controller) => controller.text)
        .join();

    if (verificationCode.length == 6) {
      setState(() {
        _isLoading = true;
      });

      // Simulate verification process
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Navigate to home screen on success
          Get.toNamed(RouteName.userDashboard);

          // For demo purposes, you might want to add error handling
          // Get.snackbar('Error', 'Invalid verification code');
        }
      });
    }
  }

  void _resendCode() {
    if (_resendCountdown == 0) {
      setState(() {
        _resendCountdown = 150; // Reset to 2 minutes 30 seconds
      });
      _startCountdown();

      // Clear all code fields
      for (var controller in _codeControllers) {
        controller.clear();
      }
      FocusScope.of(context).requestFocus(_focusNodes[0]);

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
  void dispose() {
    // Dispose all controllers and focus nodes
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.white,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppPalette.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mark_email_read_outlined,
                    size: 50,
                    color: AppPalette.primaryColor,
                  ),
                ),
                const SizedBox(height: 30),

                // Title
                Text(
                  "Verify Your Email",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppPalette.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  "We've sent a verification code to your email address",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppPalette.greyColor,
                  ),
                ),
                const SizedBox(height: 8),

                // Email address
                Text(
                  widget.email,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppPalette.secondaryColor,
                  ),
                ),
                const SizedBox(height: 30),

                // Verification Code Input
                _buildVerificationCodeInput(),
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
                      onPressed: _resendCountdown == 0 ? _resendCode : null,
                      child: Text(
                        "Resend",
                        style: TextStyle(
                          color: _resendCountdown == 0
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
                const SizedBox(height: 30),

                // Verify Button
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
                    onPressed: _isLoading ? null : _verifyCode,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Verify Email"),
                  ),
                ),
                const SizedBox(height: 20),

                // Back to login
                TextButton(
                  onPressed: () => Get.toNamed(RouteName.loginScreen),
                  child: Text(
                    "Back to Login",
                    style: TextStyle(color: AppPalette.secondaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationCodeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verification Code",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 60,
              height: 55,
              child: TextFormField(
                controller: _codeControllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                decoration: InputDecoration(
                  counterText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppPalette.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppPalette.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) => _onCodeChanged(value, index),
              ),
            );
          }),
        ),
      ],
    );
  }
}
