import 'package:afronika/features/dashborad/profile/profile%20screen.dart';
import 'package:afronika/routes/routes.dart';
import 'package:afronika/routes/routes_name.dart';
import 'package:afronika/utils/themes/themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: GAppTheme.lightTheme,
      darkTheme: GAppTheme.darkTheme,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: RouteName.splashScreen,
      themeMode: ThemeMode.system,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      },
    );
  }
}
