  import 'package:afronika/features/auth/splash/splash_screen.dart';
import 'package:afronika/routes/routes_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../features/dashborad/home/screen/home_screen.dart';

  class Routes{


    static Route<dynamic> generateRoute(RouteSettings settings){

      switch(settings.name) {
        case RouteName.splashScreen:
          return MaterialPageRoute(builder: (context) => SplashScreen());
        case RouteName.homeScreen:
          return MaterialPageRoute(builder: (context) => HomeScreen());


        default:
          return MaterialPageRoute(builder: (context){
            return Scaffold(body: Center(child: Text('Routes not found'),),);
          });
      }


    }

  }