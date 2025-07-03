  import 'package:afronika/features/auth/onboarding/onboarding_screen.dart';
import 'package:afronika/features/auth/splash/splash_screen.dart';
import 'package:afronika/routes/routes_name.dart';
import 'package:flutter/material.dart';



  class Routes{


    static Route<dynamic> generateRoute(RouteSettings settings){

      switch(settings.name) {
        case RouteName.splashScreen:
          return MaterialPageRoute(builder: (context) => SplashScreen());
        case RouteName.onboardingScreen:
          return MaterialPageRoute(builder: (context) => OnboardingScreen());


        default:
          return MaterialPageRoute(builder: (context){
            return Scaffold(body: Center(child: Text('Routes not found'),),);
          });
      }


    }

  }