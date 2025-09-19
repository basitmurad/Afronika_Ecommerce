import 'package:afronika/features/auth/splash/splash_screen.dart';
import 'package:afronika/utils/CookieConsentBanner.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
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

  // Initialize tracking *before* running the app
  await initTracking();

  runApp(const MyApp());
}

Future<void> initTracking() async {
  final status = await AppTrackingTransparency.trackingAuthorizationStatus;

  if (status == TrackingStatus.notDetermined) {
    // Wait a bit before showing Apple's ATT popup
    await Future.delayed(const Duration(milliseconds: 200));
    final newStatus = await AppTrackingTransparency.requestTrackingAuthorization();
    debugPrint("Tracking status: $newStatus");
  }

  // Optional: get advertising identifier (IDFA)
  final idfa = await AppTrackingTransparency.getAdvertisingIdentifier();
  debugPrint("IDFA: $idfa");
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
