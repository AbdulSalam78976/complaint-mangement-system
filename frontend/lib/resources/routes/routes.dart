import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/screens/auth/email_verification_screen.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/screens/auth/signup_screen.dart';
import 'package:frontend/screens/auth/splash_screen.dart';
import 'package:frontend/screens/auth/forget_password_screen.dart';
import 'package:frontend/screens/user/user_dashboard.dart';
import 'package:frontend/screens/user/complaint_details_screen.dart';
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
      name: RouteName.emailVerificationScreen,
      page: () => EmailVerificationScreen(),
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
      page: () => ComplaintDetailsScreen(),
      transitionDuration: Duration(milliseconds: 250),
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
  ];
}
