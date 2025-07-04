import 'package:afronika/features/auth/login/login_screen.dart';
import 'package:afronika/features/auth/siginup/signup_screen.dart';
import 'package:afronika/features/auth/splash/splash_screen.dart';
import 'package:afronika/routes/routes_name.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
    // case RouteName.splashScreen:
    //   return MaterialPageRoute(builder: (context) => SplashScreen());
      case RouteName.loginScreen:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RouteName.accountLogin:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RouteName.accountSignup:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RouteName.forgotPScreen:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RouteName.contWG:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RouteName.signUpScreen:
        return MaterialPageRoute(builder: (context) => SignupScreen());
      case RouteName.guestScreen:
        return MaterialPageRoute(builder: (context) => LoginScreen());

      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(body: Center(child: Text('Routes not found')));
          },
        );
    }
  }
}
