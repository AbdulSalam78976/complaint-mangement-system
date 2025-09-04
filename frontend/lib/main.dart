import 'package:flutter/material.dart';
import 'package:frontend/resources/routes/routes.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/resources/theme/app_theme.dart';
import 'package:frontend/utils/sessionmanager.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SessionManager.init();

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
      initialRoute: RouteName.splashScreen,
      getPages: AppRoutes.appRoutes(),
    );
  }
}
