import 'package:afronika/routes/routes.dart';
import 'package:afronika/routes/routes_name.dart';
import 'package:afronika/utils/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/auth/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force status bar to be transparent initially
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: GAppTheme.lightTheme.copyWith(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),
      ),
      darkTheme: GAppTheme.darkTheme.copyWith(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      ),
      onGenerateRoute: Routes.generateRoute,
      initialRoute: RouteName.loginScreen,
      themeMode: ThemeMode.system,
      builder: (context, child) {
        // This ensures status bar color changes with theme
        final brightness = Theme.of(context).brightness;

        SystemChrome.setSystemUIOverlayStyle(
          brightness == Brightness.dark
              ? const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          )
              : const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        );

        return child!;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      },
    );
  }
}