  import 'package:afronika/routes/routes_name.dart';
import 'package:flutter/material.dart';



  class Routes{


    static Route<dynamic> generateRoute(RouteSettings settings){

      switch(settings.name) {
        // case RouteName.onboardingScreen:
        //   return MaterialPageRoute(builder: (context) => OnboardingScreen());
        // case RouteName.splashScreen:
        //   return MaterialPageRoute(builder: (context) => SplashScreen());


        default:
          return MaterialPageRoute(builder: (context){
            return Scaffold(body: Center(child: Text('Routes not found'),),);
          });
      }


    }

  }