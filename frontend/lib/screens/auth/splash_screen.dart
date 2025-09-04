import 'package:flutter/material.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/resources/theme/colors.dart';
import 'package:frontend/utils/sessionmanager.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ✅ Navigation after delay
    Future.delayed(const Duration(seconds: 2), () async {
      final isLoggedIn = await SessionManager.isLoggedIn();
      if (isLoggedIn) {
        await SessionManager.navigateBasedOnRole();
      } else {
        Get.offNamed(RouteName.loginScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Logo
            Image.asset('assets/images/cms-logo.png', height: 300),

            const SizedBox(height: 30),

            // ✅ Simple loading indicator
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: AppPalette.primaryColor,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
