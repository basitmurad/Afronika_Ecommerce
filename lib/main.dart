import 'package:afronika/features/auth/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );


  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Afronika',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // only light them
      home: SplashScreen(),

      // home: Stack(
      //   children: const [
      //     SplashScreen(),
      //     CookieConsentBanner(),
      //   ],
      // ),
      // home: SplashScreen(),
    );
  }
}
