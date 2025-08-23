import 'package:flutter/material.dart';
import 'package:frontend/resources/routes/routes.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/resources/theme/app_theme.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Complaint Management System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme,
      // initialBinding: AppBinding(),
      initialRoute: RouteName.userDashboard,
      getPages: AppRoutes.appRoutes(),
    );
  }
}
