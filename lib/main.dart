// import 'package:afronika/routes/routes.dart';
// import 'package:afronika/routes/routes_name.dart';
// import 'package:afronika/utils/themes/themes.dart';
// import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
//
// import 'features/auth/provider/auth_provider.dart';
// import 'features/auth/splash/splash_screen.dart';
// import 'firebase_options.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Force status bar to be transparent initially
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   // checkEmailVerified();
//   print("🔥 Firebase Initialized"); // This will print in console
//   runApp(const MyApp());
// }
//
// // Future<void> checkEmailVerified() async {
// //   User? user = FirebaseAuth.instance.currentUser;
// //
// //   if (user != null) {
// //     await user.reload(); // Force refresh from Firebase
// //     user = FirebaseAuth.instance.currentUser; // Get updated info
// //
// //     if (user!.emailVerified) {
// //       print("✅ Email is verified");
// //       // Navigate to the home screen or continue
// //     } else {
// //       print("❌ Email is NOT verified");
// //       // Prompt user to check their email again
// //     }
// //   }
// //
// // }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: GAppTheme.lightTheme.copyWith(
//           appBarTheme: const AppBarTheme(
//             systemOverlayStyle: SystemUiOverlayStyle(
//               statusBarColor: Colors.white,
//               statusBarIconBrightness: Brightness.dark,
//               statusBarBrightness: Brightness.light,
//             ),
//           ),
//         ),
//         darkTheme: GAppTheme.darkTheme.copyWith(
//           appBarTheme: const AppBarTheme(
//             systemOverlayStyle: SystemUiOverlayStyle(
//               statusBarColor: Colors.black,
//               statusBarIconBrightness: Brightness.light,
//               statusBarBrightness: Brightness.dark,
//             ),
//           ),
//         ),
//         onGenerateRoute: Routes.generateRoute,
//         initialRoute: RouteName.splashScreen,
//         themeMode: ThemeMode.system,
//         builder: (context, child) {
//           // This ensures status bar color changes with theme
//           final brightness = Theme.of(context).brightness;
//
//           SystemChrome.setSystemUIOverlayStyle(
//             brightness == Brightness.dark
//                 ? const SystemUiOverlayStyle(
//               statusBarColor: Colors.black,
//               statusBarIconBrightness: Brightness.light,
//               statusBarBrightness: Brightness.dark,
//             )
//                 : const SystemUiOverlayStyle(
//               statusBarColor: Colors.white,
//               statusBarIconBrightness: Brightness.dark,
//               statusBarBrightness: Brightness.light,
//             ),
//           );
//
//           return child!;
//         },
//         onUnknownRoute: (settings) {
//           return MaterialPageRoute(
//             builder: (context) => const SplashScreen(),
//           );
//         },
//       ),
//     );
//   }
// }
//

import 'package:afronika/features/auth/splash/splash_screen.dart';
import 'package:afronika/webview/AfronikaWebView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  // Set the status bar to white
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white, // Background color of status bar
    statusBarIconBrightness: Brightness.dark, // Dark icons for white background
    statusBarBrightness: Brightness.light, // For iOS
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Afronika WebView',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}



