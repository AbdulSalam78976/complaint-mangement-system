import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/screens/admin/admin_complaint_management.dart';
import 'package:frontend/screens/admin/admin_dashboard.dart';
import 'package:frontend/screens/admin/admin_reports.dart';
import 'package:frontend/screens/admin/admin_user_management.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/screens/auth/signup_screen.dart';
import 'package:frontend/screens/auth/splash_screen.dart';
import 'package:frontend/screens/auth/forget_password_screen.dart';
import 'package:frontend/screens/user/user_dashboard.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/complaint_details_screen.dart';
import 'package:frontend/screens/user/settings_screen.dart';
import 'package:frontend/screens/user/complaint_list_screen.dart';
import 'package:frontend/screens/user/notifications_screen.dart';
import 'package:frontend/screens/user/profile_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static appRoutes() => [
    GetPage(
      name: RouteName.splashScreen,
      page: () => SplashScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: RouteName.signupScreen,
      page: () => SignupScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),

    GetPage(
      name: RouteName.loginScreen,
      page: () => LoginScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: RouteName.forgetPasswordScreen,
      page: () => ForgetPasswordScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
    GetPage(
      name: RouteName.userDashboard,
      page: () => UserDashboard(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),

    // New user screens
    GetPage(
      name: RouteName.complaintListScreen,
      page: () => ComplaintListScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.rightToLeftWithFade,
    ),

    GetPage(
      name: RouteName.complaintDetailsScreen,
      page: () {
        return ComplaintDetailsScreen();
      },
      transitionDuration: const Duration(milliseconds: 250),
      transition: Transition.rightToLeftWithFade,
    ),

    GetPage(
      name: RouteName.notificationsScreen,
      page: () => NotificationsScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.rightToLeftWithFade,
    ),

    GetPage(
      name: RouteName.settingsScreen,
      page: () => SettingsScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.rightToLeftWithFade,
    ),

    GetPage(
      name: RouteName.profileScreen,
      page: () => ProfileScreen(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.rightToLeftWithFade,
    ),

    // Admin screens
    GetPage(
      name: RouteName.adminDashboard,
      page: () => const AdminDashboard(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RouteName.adminComplaintManagement,
      page: () => AdminComplaintManagement(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RouteName.adminUserManagement,
      page: () => const AdminUserManagement(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: RouteName.adminReports,
      page: () => const AdminReports(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
