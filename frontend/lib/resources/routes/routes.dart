import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/screens/auth/login_screen.dart';
import 'package:frontend/screens/auth/signup_screen.dart';
import 'package:frontend/screens/user/user_dashboard.dart';
import 'package:get/get.dart';

class AppRoutes {
  static appRoutes() => [
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
      name: RouteName.userDashboard,
      page: () => UserDashboard(),
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade,
    ),
  ];
}
