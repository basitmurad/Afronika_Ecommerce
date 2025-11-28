import 'package:afronika/features/auth/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'helpers/deep_link_servive.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DeepLinkService().initialize();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("🔥 Firebase Initialized Successfully!");
  } catch (e) {
    print("❌ Firebase Initialization FAILED!");
    print(e);
  }
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Initialize tracking *before* running the app

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
