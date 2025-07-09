import 'package:afronika/features/auth/login/forgot_pas_screen.dart';
import 'package:afronika/features/auth/login/login_screen.dart';
import 'package:afronika/features/auth/onboarding/onboarding_screen.dart';
import 'package:afronika/features/auth/siginup/signup_screen.dart';
import 'package:afronika/features/auth/splash/splash_screen.dart';
import 'package:afronika/routes/routes_name.dart';
import 'package:flutter/material.dart';

import '../NavigationMenu.dart';
// note: some routes are marks as pd [ path to defined ],
// theses routes are set to login screen for default
// please, defined paths to pd routes
class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
    case RouteName.onboardingScreen:
      return MaterialPageRoute(builder: (context) => OnboardingScreen());
      case RouteName.loginScreen:
      return MaterialPageRoute(builder: (context) => LoginScreen());
      case RouteName.signUpScreen:
      return MaterialPageRoute(builder: (context) => SignupScreen());
      case RouteName.forgotPasScreen:
      return MaterialPageRoute(builder: (context) => ForgotPasScreen());
 case RouteName.navigationMenu:
      return MaterialPageRoute(builder: (context) => NavigationMenu());

      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(body: Center(child: Text('Routes not found')));
          },
        );
    }
  }
}
