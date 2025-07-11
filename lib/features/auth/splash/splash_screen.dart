// // // // import 'dart:async';
// // // // import 'dart:math' as math;
// // // // import 'package:afronika/routes/routes_name.dart';
// // // // import 'package:afronika/utils/constant/colors.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter/services.dart';
// // // //
// // // // import '../../../utils/constant/app_test_style.dart';
// // // // import '../../../utils/device/device_utility.dart';
// // // // import '../onboarding/onboarding_screen.dart';
// // // //
// // // // class SplashScreen extends StatefulWidget {
// // // //   const SplashScreen({super.key});
// // // //
// // // //   @override
// // // //   State<SplashScreen> createState() => _SplashScreenState();
// // // // }
// // // //
// // // // class _SplashScreenState extends State<SplashScreen>
// // // //     with TickerProviderStateMixin {
// // // //   double progress = 0.0;
// // // //   late AnimationController _logoAnimationController;
// // // //   late AnimationController _progressAnimationController;
// // // //   late AnimationController _pulseAnimationController;
// // // //   late AnimationController _fadeAnimationController;
// // // //
// // // //   late Animation<double> _logoScaleAnimation;
// // // //   late Animation<double> _logoFadeAnimation;
// // // //   late Animation<double> _progressAnimation;
// // // //   late Animation<double> _pulseAnimation;
// // // //   late Animation<double> _fadeAnimation;
// // // //
// // // //   Timer? _progressTimer;
// // // //   bool _isNavigating = false;
// // // //
// // // //   final List<String> _loadingTexts = [
// // // //     'Initializing...',
// // // //     'Loading resources...',
// // // //     'Preparing experience...',
// // // //     'Almost ready...',
// // // //     'Welcome to Afronika!',
// // // //   ];
// // // //
// // // //   String _currentLoadingText = 'Initializing...';
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _initializeAnimations();
// // // //     _startAnimations();
// // // //     _startProgress();
// // // //   }
// // // //
// // // //   void _initializeAnimations() {
// // // //     _logoAnimationController = AnimationController(
// // // //       duration: const Duration(milliseconds: 1500),
// // // //       vsync: this,
// // // //     );
// // // //
// // // //     _progressAnimationController = AnimationController(
// // // //       duration: const Duration(milliseconds: 200),
// // // //       vsync: this,
// // // //     );
// // // //
// // // //     _pulseAnimationController = AnimationController(
// // // //       duration: const Duration(milliseconds: 1000),
// // // //       vsync: this,
// // // //     );
// // // //
// // // //     _fadeAnimationController = AnimationController(
// // // //       duration: const Duration(milliseconds: 500),
// // // //       vsync: this,
// // // //     );
// // // //
// // // //     _logoScaleAnimation = Tween<double>(
// // // //       begin: 0.0,
// // // //       end: 1.0,
// // // //     ).animate(CurvedAnimation(
// // // //       parent: _logoAnimationController,
// // // //       curve: Curves.elasticOut,
// // // //     ));
// // // //
// // // //     _logoFadeAnimation = Tween<double>(
// // // //       begin: 0.0,
// // // //       end: 1.0,
// // // //     ).animate(CurvedAnimation(
// // // //       parent: _logoAnimationController,
// // // //       curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
// // // //     ));
// // // //
// // // //     _progressAnimation = Tween<double>(
// // // //       begin: 0.0,
// // // //       end: 1.0,
// // // //     ).animate(CurvedAnimation(
// // // //       parent: _progressAnimationController,
// // // //       curve: Curves.easeInOut,
// // // //     ));
// // // //
// // // //     _pulseAnimation = Tween<double>(
// // // //       begin: 1.0,
// // // //       end: 1.1,
// // // //     ).animate(CurvedAnimation(
// // // //       parent: _pulseAnimationController,
// // // //       curve: Curves.easeInOut,
// // // //     ));
// // // //
// // // //     _fadeAnimation = Tween<double>(
// // // //       begin: 1.0,
// // // //       end: 0.0,
// // // //     ).animate(CurvedAnimation(
// // // //       parent: _fadeAnimationController,
// // // //       curve: Curves.easeInOut,
// // // //     ));
// // // //   }
// // // //
// // // //   void _startAnimations() {
// // // //     _logoAnimationController.forward();
// // // //     _progressAnimationController.forward();
// // // //     _pulseAnimationController.repeat(reverse: true);
// // // //
// // // //     // Delay the fade animation to start after logo animation
// // // //     Future.delayed(const Duration(milliseconds: 800), () {
// // // //       if (mounted) {
// // // //         _fadeAnimationController.forward();
// // // //       }
// // // //     });
// // // //   }
// // // //
// // // //   void _startProgress() {
// // // //     _progressTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
// // // //       if (!mounted) {
// // // //         timer.cancel();
// // // //         return;
// // // //       }
// // // //
// // // //       setState(() {
// // // //         progress += 0.008;
// // // //
// // // //         // Update loading text based on progress
// // // //         if (progress < 0.2) {
// // // //           _currentLoadingText = _loadingTexts[0];
// // // //         } else if (progress < 0.4) {
// // // //           _currentLoadingText = _loadingTexts[1];
// // // //         } else if (progress < 0.6) {
// // // //           _currentLoadingText = _loadingTexts[2];
// // // //         } else if (progress < 0.8) {
// // // //           _currentLoadingText = _loadingTexts[3];
// // // //         } else {
// // // //           _currentLoadingText = _loadingTexts[4];
// // // //         }
// // // //
// // // //         if (progress >= 1.0) {
// // // //           progress = 1.0;
// // // //           timer.cancel();
// // // //           _navigateToOnboarding();
// // // //         }
// // // //       });
// // // //     });
// // // //   }
// // // //
// // // //   void _navigateToOnboarding() {
// // // //     if (_isNavigating) return;
// // // //     _isNavigating = true;
// // // //
// // // //     HapticFeedback.lightImpact();
// // // //
// // // //     // Add a small delay before navigation for better UX
// // // //     Future.delayed(const Duration(milliseconds: 500), () {
// // // //       if (mounted) {
// // // //
// // // //         Navigator.pushReplacementNamed(context, RouteName.onboardingScreen);
// // // //       }
// // // //     });
// // // //   }
// // // //
// // // //   @override
// // // //   void dispose() {
// // // //     _progressTimer?.cancel();
// // // //     _logoAnimationController.dispose();
// // // //     _progressAnimationController.dispose();
// // // //     _pulseAnimationController.dispose();
// // // //     _fadeAnimationController.dispose();
// // // //     super.dispose();
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final bool dark = ADeviceUtils.isDarkMode(context);
// // // //     final size = MediaQuery.of(context).size;
// // // //
// // // //     return Scaffold(
// // // //       body: Center(
// // // //         child: Column(
// // // //           mainAxisAlignment: MainAxisAlignment.center,
// // // //           children: [
// // // //             // Logo with animations
// // // //             AnimatedBuilder(
// // // //               animation: _logoAnimationController,
// // // //               builder: (context, child) {
// // // //                 return Transform.scale(
// // // //                   scale: _logoScaleAnimation.value,
// // // //                   child: FadeTransition(
// // // //                     opacity: _logoFadeAnimation,
// // // //                     child: Container(
// // // //                       padding: const EdgeInsets.all(20),
// // // //                       decoration: BoxDecoration(
// // // //                       ),
// // // //                       child:
// // // //                       RichText(
// // // //                         text: TextSpan(
// // // //                           style: AappTextStyle.roboto(
// // // //                             fontSize: 56,
// // // //                             weight: FontWeight.bold,
// // // //                             color: Colors.red,
// // // //                           ),
// // // //                           children: [
// // // //                             TextSpan(
// // // //                               text: 'Afr',
// // // //                               style: AappTextStyle.roboto(
// // // //                                 fontSize: 56,
// // // //                                 weight: FontWeight.bold,
// // // //                                 color: Colors.red,
// // // //                               ),
// // // //                             ),
// // // //                             TextSpan(
// // // //                               text: 'o',
// // // //                               style: AappTextStyle.roboto(
// // // //                                 fontSize: 56,
// // // //                                 weight: FontWeight.bold,
// // // //                                 color: dark ?Colors.white :Colors.black,
// // // //                               ),
// // // //                             ),
// // // //                             TextSpan(
// // // //                               text: 'n',
// // // //                               style: AappTextStyle.roboto(
// // // //                                 fontSize: 56,
// // // //                                 weight: FontWeight.bold,
// // // //                                 color: AColors.primary,
// // // //                               ),
// // // //                             ),
// // // //                             TextSpan(
// // // //                               text: 'ika',
// // // //                               style: AappTextStyle.roboto(
// // // //                                 fontSize: 56,
// // // //                                 weight: FontWeight.bold,
// // // //                                 color: Colors.cyan,
// // // //                               ),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 );
// // // //               },
// // // //             ),
// // // //
// // // //             const SizedBox(height: 80),
// // // //
// // // //
// // // //
// // // //             // Enhanced progress bar
// // // //             AnimatedBuilder(
// // // //               animation: _progressAnimationController,
// // // //               builder: (context, child) {
// // // //                 return FadeTransition(
// // // //                   opacity: _progressAnimation,
// // // //                   child: Padding(
// // // //                     padding: const EdgeInsets.symmetric(horizontal: 40),
// // // //                     child: Container(
// // // //                       decoration: BoxDecoration(
// // // //                         borderRadius: BorderRadius.circular(15),
// // // //                         border: Border.all(
// // // //                           color: AColors.primary,
// // // //                           width: 2,
// // // //                         ),
// // // //                         boxShadow: [
// // // //                           BoxShadow(
// // // //                             color: Colors.black.withOpacity(0.1),
// // // //                             blurRadius: 15,
// // // //                             offset: const Offset(0, 5),
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                       child: Stack(
// // // //                         children: [
// // // //                           // Background bar
// // // //                           Container(
// // // //                             height: 20,
// // // //                             decoration: BoxDecoration(
// // // //                               color: dark
// // // //                                   ? Colors.grey[800]
// // // //                                   : Colors.grey[200],
// // // //                               borderRadius: BorderRadius.circular(15),
// // // //                             ),
// // // //                           ),
// // // //
// // // //                           // Progress bar with gradient
// // // //                           AnimatedContainer(
// // // //                             duration: const Duration(milliseconds: 200),
// // // //                             height: 20,
// // // //                             width: (size.width - 80) * progress,
// // // //                             decoration: BoxDecoration(
// // // //                               borderRadius: BorderRadius.circular(15),
// // // //                               gradient: const LinearGradient(
// // // //                                 colors: [
// // // //                                   Colors.tealAccent,
// // // //                                   Colors.cyan,
// // // //                                   Colors.lightBlue,
// // // //                                 ],
// // // //                                 begin: Alignment.centerLeft,
// // // //                                 end: Alignment.centerRight,
// // // //                               ),
// // // //                               boxShadow: [
// // // //                                 BoxShadow(
// // // //                                   color: Colors.tealAccent.withOpacity(0.4),
// // // //                                   blurRadius: 10,
// // // //                                   offset: const Offset(0, 2),
// // // //                                 ),
// // // //                               ],
// // // //                             ),
// // // //                           ),
// // // //
// // // //                           // Animated shimmer effect
// // // //                           AnimatedContainer(
// // // //                             duration: const Duration(milliseconds: 200),
// // // //                             height: 20,
// // // //                             width: (size.width - 80) * progress,
// // // //                             decoration: BoxDecoration(
// // // //                               borderRadius: BorderRadius.circular(15),
// // // //                               gradient: LinearGradient(
// // // //                                 colors: [
// // // //                                   Colors.white.withOpacity(0.0),
// // // //                                   Colors.white.withOpacity(0.3),
// // // //                                   Colors.white.withOpacity(0.0),
// // // //                                 ],
// // // //                                 stops: const [0.0, 0.5, 1.0],
// // // //                                 begin: Alignment.centerLeft,
// // // //                                 end: Alignment.centerRight,
// // // //                               ),
// // // //                             ),
// // // //                           ),
// // // //
// // // //                           // Percentage text
// // // //                           Container(
// // // //                             height: 20,
// // // //                             alignment: Alignment.center,
// // // //                             child: AnimatedOpacity(
// // // //                               opacity: progress > 0.1 ? 1.0 : 0.0,
// // // //                               duration: const Duration(milliseconds: 300),
// // // //                               child: Text(
// // // //                                 '${(progress * 100).toInt()}%',
// // // //                                 style: const TextStyle(
// // // //                                   color: Colors.white,
// // // //                                   fontWeight: FontWeight.bold,
// // // //                                   fontSize: 12,
// // // //                                   shadows: [
// // // //                                     Shadow(
// // // //                                       color: Colors.black54,
// // // //                                       blurRadius: 2,
// // // //                                     ),
// // // //                                   ],
// // // //                                 ),
// // // //                               ),
// // // //                             ),
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 );
// // // //               },
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // //
// // // import 'dart:async';
// // // import 'dart:math' as math;
// // // import 'package:afronika/routes/routes_name.dart';
// // // import 'package:afronika/utils/constant/colors.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/services.dart';
// // // import 'package:provider/provider.dart';
// // //
// // // import '../../../utils/constant/app_test_style.dart';
// // // import '../../../utils/device/device_utility.dart';
// // // import '../onboarding/onboarding_screen.dart';
// // // import '../provider/auth_provider.dart'; // Add your auth provider import
// // //
// // // class SplashScreen extends StatefulWidget {
// // //   const SplashScreen({super.key});
// // //
// // //   @override
// // //   State<SplashScreen> createState() => _SplashScreenState();
// // // }
// // //
// // // class _SplashScreenState extends State<SplashScreen>
// // //     with TickerProviderStateMixin {
// // //   double progress = 0.0;
// // //   late AnimationController _logoAnimationController;
// // //   late AnimationController _progressAnimationController;
// // //   late AnimationController _pulseAnimationController;
// // //   late AnimationController _fadeAnimationController;
// // //
// // //   late Animation<double> _logoScaleAnimation;
// // //   late Animation<double> _logoFadeAnimation;
// // //   late Animation<double> _progressAnimation;
// // //   late Animation<double> _pulseAnimation;
// // //   late Animation<double> _fadeAnimation;
// // //
// // //   Timer? _progressTimer;
// // //   bool _isNavigating = false;
// // //
// // //   final List<String> _loadingTexts = [
// // //     'Initializing...',
// // //     'Checking authentication...',
// // //     'Loading resources...',
// // //     'Preparing experience...',
// // //     'Almost ready...',
// // //     'Welcome to Afronika!',
// // //   ];
// // //
// // //   String _currentLoadingText = 'Initializing...';
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _initializeAnimations();
// // //     _startAnimations();
// // //     _startProgress();
// // //   }
// // //
// // //   void _initializeAnimations() {
// // //     _logoAnimationController = AnimationController(
// // //       duration: const Duration(milliseconds: 1500),
// // //       vsync: this,
// // //     );
// // //
// // //     _progressAnimationController = AnimationController(
// // //       duration: const Duration(milliseconds: 200),
// // //       vsync: this,
// // //     );
// // //
// // //     _pulseAnimationController = AnimationController(
// // //       duration: const Duration(milliseconds: 1000),
// // //       vsync: this,
// // //     );
// // //
// // //     _fadeAnimationController = AnimationController(
// // //       duration: const Duration(milliseconds: 500),
// // //       vsync: this,
// // //     );
// // //
// // //     _logoScaleAnimation = Tween<double>(
// // //       begin: 0.0,
// // //       end: 1.0,
// // //     ).animate(CurvedAnimation(
// // //       parent: _logoAnimationController,
// // //       curve: Curves.elasticOut,
// // //     ));
// // //
// // //     _logoFadeAnimation = Tween<double>(
// // //       begin: 0.0,
// // //       end: 1.0,
// // //     ).animate(CurvedAnimation(
// // //       parent: _logoAnimationController,
// // //       curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
// // //     ));
// // //
// // //     _progressAnimation = Tween<double>(
// // //       begin: 0.0,
// // //       end: 1.0,
// // //     ).animate(CurvedAnimation(
// // //       parent: _progressAnimationController,
// // //       curve: Curves.easeInOut,
// // //     ));
// // //
// // //     _pulseAnimation = Tween<double>(
// // //       begin: 1.0,
// // //       end: 1.1,
// // //     ).animate(CurvedAnimation(
// // //       parent: _pulseAnimationController,
// // //       curve: Curves.easeInOut,
// // //     ));
// // //
// // //     _fadeAnimation = Tween<double>(
// // //       begin: 1.0,
// // //       end: 0.0,
// // //     ).animate(CurvedAnimation(
// // //       parent: _fadeAnimationController,
// // //       curve: Curves.easeInOut,
// // //     ));
// // //   }
// // //
// // //   void _startAnimations() {
// // //     _logoAnimationController.forward();
// // //     _progressAnimationController.forward();
// // //     _pulseAnimationController.repeat(reverse: true);
// // //
// // //     // Delay the fade animation to start after logo animation
// // //     Future.delayed(const Duration(milliseconds: 800), () {
// // //       if (mounted) {
// // //         _fadeAnimationController.forward();
// // //       }
// // //     });
// // //   }
// // //
// // //   void _startProgress() {
// // //     _progressTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
// // //       if (!mounted) {
// // //         timer.cancel();
// // //         return;
// // //       }
// // //
// // //       setState(() {
// // //         progress += 0.008;
// // //
// // //         // Update loading text based on progress
// // //         if (progress < 0.15) {
// // //           _currentLoadingText = _loadingTexts[0];
// // //         } else if (progress < 0.3) {
// // //           _currentLoadingText = _loadingTexts[1];
// // //         } else if (progress < 0.5) {
// // //           _currentLoadingText = _loadingTexts[2];
// // //         } else if (progress < 0.7) {
// // //           _currentLoadingText = _loadingTexts[3];
// // //         } else if (progress < 0.9) {
// // //           _currentLoadingText = _loadingTexts[4];
// // //         } else {
// // //           _currentLoadingText = _loadingTexts[5];
// // //         }
// // //
// // //         if (progress >= 1.0) {
// // //           progress = 1.0;
// // //           timer.cancel();
// // //           _checkAuthAndNavigate();
// // //         }
// // //       });
// // //     });
// // //   }
// // //
// // //   void _checkAuthAndNavigate() {
// // //     if (_isNavigating) return;
// // //     _isNavigating = true;
// // //
// // //     HapticFeedback.lightImpact();
// // //
// // //     // Add a small delay before navigation for better UX
// // //     Future.delayed(const Duration(milliseconds: 500), () {
// // //       if (mounted) {
// // //         final authProvider = Provider.of<AuthProvider>(context, listen: false);
// // //
// // //         // Check authentication status
// // //         switch (authProvider.status) {
// // //           case AuthStatus.authenticated:
// // //           // User is logged in and email is verified
// // //             if (authProvider.isEmailVerified) {
// // //               Navigator.pushReplacementNamed(context, RouteName.navigationMenu);
// // //             } else {
// // //               Navigator.pushReplacementNamed(context, RouteName.emailVerificationScreen);
// // //             }
// // //             break;
// // //
// // //           case AuthStatus.emailVerificationPending:
// // //           // User is logged in but email is not verified
// // //             Navigator.pushReplacementNamed(context, RouteName.emailVerificationScreen);
// // //             break;
// // //
// // //           case AuthStatus.unauthenticated:
// // //           case AuthStatus.uninitialized:
// // //           default:
// // //           // User is not logged in, go to onboarding/login
// // //             Navigator.pushReplacementNamed(context, RouteName.onboardingScreen);
// // //             break;
// // //         }
// // //       }
// // //     });
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     _progressTimer?.cancel();
// // //     _logoAnimationController.dispose();
// // //     _progressAnimationController.dispose();
// // //     _pulseAnimationController.dispose();
// // //     _fadeAnimationController.dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final bool dark = ADeviceUtils.isDarkMode(context);
// // //     final size = MediaQuery.of(context).size;
// // //
// // //     return Scaffold(
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             // Logo with animations
// // //             AnimatedBuilder(
// // //               animation: _logoAnimationController,
// // //               builder: (context, child) {
// // //                 return Transform.scale(
// // //                   scale: _logoScaleAnimation.value,
// // //                   child: FadeTransition(
// // //                     opacity: _logoFadeAnimation,
// // //                     child: Container(
// // //                       padding: const EdgeInsets.all(20),
// // //                       decoration: BoxDecoration(),
// // //                       child: RichText(
// // //                         text: TextSpan(
// // //                           style: AappTextStyle.roboto(
// // //                             fontSize: 56,
// // //                             weight: FontWeight.bold,
// // //                             color: Colors.red,
// // //                           ),
// // //                           children: [
// // //                             TextSpan(
// // //                               text: 'Afr',
// // //                               style: AappTextStyle.roboto(
// // //                                 fontSize: 56,
// // //                                 weight: FontWeight.bold,
// // //                                 color: Colors.red,
// // //                               ),
// // //                             ),
// // //                             TextSpan(
// // //                               text: 'o',
// // //                               style: AappTextStyle.roboto(
// // //                                 fontSize: 56,
// // //                                 weight: FontWeight.bold,
// // //                                 color: dark ? Colors.white : Colors.black,
// // //                               ),
// // //                             ),
// // //                             TextSpan(
// // //                               text: 'n',
// // //                               style: AappTextStyle.roboto(
// // //                                 fontSize: 56,
// // //                                 weight: FontWeight.bold,
// // //                                 color: AColors.primary,
// // //                               ),
// // //                             ),
// // //                             TextSpan(
// // //                               text: 'ika',
// // //                               style: AappTextStyle.roboto(
// // //                                 fontSize: 56,
// // //                                 weight: FontWeight.bold,
// // //                                 color: Colors.cyan,
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 );
// // //               },
// // //             ),
// // //
// // //             const SizedBox(height: 80),
// // //
// // //             // Enhanced progress bar
// // //             AnimatedBuilder(
// // //               animation: _progressAnimationController,
// // //               builder: (context, child) {
// // //                 return FadeTransition(
// // //                   opacity: _progressAnimation,
// // //                   child: Padding(
// // //                     padding: const EdgeInsets.symmetric(horizontal: 40),
// // //                     child: Container(
// // //                       decoration: BoxDecoration(
// // //                         borderRadius: BorderRadius.circular(15),
// // //                         border: Border.all(
// // //                           color: AColors.primary,
// // //                           width: 2,
// // //                         ),
// // //                         boxShadow: [
// // //                           BoxShadow(
// // //                             color: Colors.black.withOpacity(0.1),
// // //                             blurRadius: 15,
// // //                             offset: const Offset(0, 5),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                       child: Stack(
// // //                         children: [
// // //                           // Background bar
// // //                           Container(
// // //                             height: 20,
// // //                             decoration: BoxDecoration(
// // //                               color: dark
// // //                                   ? Colors.grey[800]
// // //                                   : Colors.grey[200],
// // //                               borderRadius: BorderRadius.circular(15),
// // //                             ),
// // //                           ),
// // //
// // //                           // Progress bar with gradient
// // //                           AnimatedContainer(
// // //                             duration: const Duration(milliseconds: 200),
// // //                             height: 20,
// // //                             width: (size.width - 80) * progress,
// // //                             decoration: BoxDecoration(
// // //                               borderRadius: BorderRadius.circular(15),
// // //                               gradient: const LinearGradient(
// // //                                 colors: [
// // //                                   Colors.tealAccent,
// // //                                   Colors.cyan,
// // //                                   Colors.lightBlue,
// // //                                 ],
// // //                                 begin: Alignment.centerLeft,
// // //                                 end: Alignment.centerRight,
// // //                               ),
// // //                               boxShadow: [
// // //                                 BoxShadow(
// // //                                   color: Colors.tealAccent.withOpacity(0.4),
// // //                                   blurRadius: 10,
// // //                                   offset: const Offset(0, 2),
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                           ),
// // //
// // //                           // Animated shimmer effect
// // //                           AnimatedContainer(
// // //                             duration: const Duration(milliseconds: 200),
// // //                             height: 20,
// // //                             width: (size.width - 80) * progress,
// // //                             decoration: BoxDecoration(
// // //                               borderRadius: BorderRadius.circular(15),
// // //                               gradient: LinearGradient(
// // //                                 colors: [
// // //                                   Colors.white.withOpacity(0.0),
// // //                                   Colors.white.withOpacity(0.3),
// // //                                   Colors.white.withOpacity(0.0),
// // //                                 ],
// // //                                 stops: const [0.0, 0.5, 1.0],
// // //                                 begin: Alignment.centerLeft,
// // //                                 end: Alignment.centerRight,
// // //                               ),
// // //                             ),
// // //                           ),
// // //
// // //                           // Percentage text
// // //                           Container(
// // //                             height: 20,
// // //                             alignment: Alignment.center,
// // //                             child: AnimatedOpacity(
// // //                               opacity: progress > 0.1 ? 1.0 : 0.0,
// // //                               duration: const Duration(milliseconds: 300),
// // //                               child: Text(
// // //                                 '${(progress * 100).toInt()}%',
// // //                                 style: const TextStyle(
// // //                                   color: Colors.white,
// // //                                   fontWeight: FontWeight.bold,
// // //                                   fontSize: 12,
// // //                                   shadows: [
// // //                                     Shadow(
// // //                                       color: Colors.black54,
// // //                                       blurRadius: 2,
// // //                                     ),
// // //                                   ],
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 );
// // //               },
// // //             ),
// // //
// // //             const SizedBox(height: 30),
// // //
// // //             // Loading text
// // //             AnimatedSwitcher(
// // //               duration: const Duration(milliseconds: 300),
// // //               child: Text(
// // //                 _currentLoadingText,
// // //                 key: ValueKey(_currentLoadingText),
// // //                 style: AappTextStyle.roboto(
// // //                   fontSize: 16,
// // //                   weight: FontWeight.w500,
// // //                   color: dark ? Colors.white70 : Colors.black54,
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// // import 'dart:async';
// // import 'dart:math' as math;
// // import 'package:afronika/routes/routes_name.dart';
// // import 'package:afronika/utils/constant/colors.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:provider/provider.dart';
// //
// // import '../../../utils/constant/app_test_style.dart';
// // import '../../../utils/device/device_utility.dart';
// //
// // import '../provider/auth_provider.dart'; // Add your auth provider import
// //
// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({super.key});
// //
// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }
// //
// // class _SplashScreenState extends State<SplashScreen>
// //     with TickerProviderStateMixin {
// //   double progress = 0.0;
// //   late AnimationController _logoAnimationController;
// //   late AnimationController _progressAnimationController;
// //   late AnimationController _pulseAnimationController;
// //   late AnimationController _fadeAnimationController;
// //
// //   late Animation<double> _logoScaleAnimation;
// //   late Animation<double> _logoFadeAnimation;
// //   late Animation<double> _progressAnimation;
// //   late Animation<double> _pulseAnimation;
// //   late Animation<double> _fadeAnimation;
// //
// //   Timer? _progressTimer;
// //   bool _isNavigating = false;
// //
// //   final List<String> _loadingTexts = [
// //     'Initializing...',
// //     'Checking authentication...',
// //     'Loading resources...',
// //     'Preparing experience...',
// //     'Almost ready...',
// //     'Welcome to Afronika!',
// //   ];
// //
// //   String _currentLoadingText = 'Initializing...';
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeAnimations();
// //     _startAnimations();
// //     _startProgress();
// //   }
// //
// //   void _initializeAnimations() {
// //     _logoAnimationController = AnimationController(
// //       duration: const Duration(milliseconds: 1500),
// //       vsync: this,
// //     );
// //
// //     _progressAnimationController = AnimationController(
// //       duration: const Duration(milliseconds: 200),
// //       vsync: this,
// //     );
// //
// //     _pulseAnimationController = AnimationController(
// //       duration: const Duration(milliseconds: 1000),
// //       vsync: this,
// //     );
// //
// //     _fadeAnimationController = AnimationController(
// //       duration: const Duration(milliseconds: 500),
// //       vsync: this,
// //     );
// //
// //     _logoScaleAnimation = Tween<double>(
// //       begin: 0.0,
// //       end: 1.0,
// //     ).animate(CurvedAnimation(
// //       parent: _logoAnimationController,
// //       curve: Curves.elasticOut,
// //     ));
// //
// //     _logoFadeAnimation = Tween<double>(
// //       begin: 0.0,
// //       end: 1.0,
// //     ).animate(CurvedAnimation(
// //       parent: _logoAnimationController,
// //       curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
// //     ));
// //
// //     _progressAnimation = Tween<double>(
// //       begin: 0.0,
// //       end: 1.0,
// //     ).animate(CurvedAnimation(
// //       parent: _progressAnimationController,
// //       curve: Curves.easeInOut,
// //     ));
// //
// //     _pulseAnimation = Tween<double>(
// //       begin: 1.0,
// //       end: 1.1,
// //     ).animate(CurvedAnimation(
// //       parent: _pulseAnimationController,
// //       curve: Curves.easeInOut,
// //     ));
// //
// //     _fadeAnimation = Tween<double>(
// //       begin: 1.0,
// //       end: 0.0,
// //     ).animate(CurvedAnimation(
// //       parent: _fadeAnimationController,
// //       curve: Curves.easeInOut,
// //     ));
// //   }
// //
// //   void _startAnimations() {
// //     _logoAnimationController.forward();
// //     _progressAnimationController.forward();
// //     _pulseAnimationController.repeat(reverse: true);
// //
// //     // Delay the fade animation to start after logo animation
// //     Future.delayed(const Duration(milliseconds: 800), () {
// //       if (mounted) {
// //         _fadeAnimationController.forward();
// //       }
// //     });
// //   }
// //
// //   void _startProgress() {
// //     _progressTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
// //       if (!mounted) {
// //         timer.cancel();
// //         return;
// //       }
// //
// //       setState(() {
// //         progress += 0.008;
// //
// //         // Update loading text based on progress
// //         if (progress < 0.15) {
// //           _currentLoadingText = _loadingTexts[0];
// //         } else if (progress < 0.3) {
// //           _currentLoadingText = _loadingTexts[1];
// //         } else if (progress < 0.5) {
// //           _currentLoadingText = _loadingTexts[2];
// //         } else if (progress < 0.7) {
// //           _currentLoadingText = _loadingTexts[3];
// //         } else if (progress < 0.9) {
// //           _currentLoadingText = _loadingTexts[4];
// //         } else {
// //           _currentLoadingText = _loadingTexts[5];
// //         }
// //
// //         if (progress >= 1.0) {
// //           progress = 1.0;
// //           timer.cancel();
// //           _checkAuthAndNavigate();
// //         }
// //       });
// //     });
// //   }
// //
// //   void _checkAuthAndNavigate() {
// //     if (_isNavigating) return;
// //     _isNavigating = true;
// //
// //     HapticFeedback.lightImpact();
// //
// //     // Add a small delay before navigation for better UX
// //     Future.delayed(const Duration(milliseconds: 500), () {
// //       if (mounted) {
// //         final authProvider = Provider.of<AuthProvider>(context, listen: false);
// //
// //         String message = '';
// //         String nextRoute = '';
// //
// //         // Check authentication status and set appropriate message
// //         switch (authProvider.status) {
// //           case AuthStatus.authenticated:
// //           // User is logged in and email is verified
// //             if (authProvider.isEmailVerified) {
// //               message = 'Welcome back, ${authProvider.user?.displayName ?? 'User'}!';
// //               nextRoute = RouteName.navigationMenu;
// //             } else {
// //               message = 'Please verify your email to continue';
// //               nextRoute = RouteName.emailVerificationScreen;
// //             }
// //             break;
// //
// //           case AuthStatus.emailVerificationPending:
// //           // User is logged in but email is not verified
// //             message = 'Email verification required';
// //             nextRoute = RouteName.emailVerificationScreen;
// //             break;
// //
// //           case AuthStatus.unauthenticated:
// //           case AuthStatus.uninitialized:
// //           default:
// //           // User is not logged in, go to onboarding/login
// //             message = 'Welcome to Afronika!';
// //             nextRoute = RouteName.onboardingScreen;
// //             break;
// //         }
// //
// //         // Show the message
// //         _showNavigationMessage(message, nextRoute);
// //       }
// //     });
// //   }
// //
// //   void _showNavigationMessage(String message, String nextRoute) {
// //     // Update the current loading text to show the message
// //     setState(() {
// //       _currentLoadingText = message;
// //     });
// //
// //     // Show a brief message before navigating
// //     Future.delayed(const Duration(milliseconds: 1500), () {
// //       if (mounted) {
// //         Navigator.pushReplacementNamed(context, nextRoute);
// //       }
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _progressTimer?.cancel();
// //     _logoAnimationController.dispose();
// //     _progressAnimationController.dispose();
// //     _pulseAnimationController.dispose();
// //     _fadeAnimationController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final bool dark = ADeviceUtils.isDarkMode(context);
// //     final size = MediaQuery.of(context).size;
// //
// //     return Scaffold(
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             // Logo with animations
// //             AnimatedBuilder(
// //               animation: _logoAnimationController,
// //               builder: (context, child) {
// //                 return Transform.scale(
// //                   scale: _logoScaleAnimation.value,
// //                   child: FadeTransition(
// //                     opacity: _logoFadeAnimation,
// //                     child: Container(
// //                       padding: const EdgeInsets.all(20),
// //                       decoration: BoxDecoration(),
// //                       child: RichText(
// //                         text: TextSpan(
// //                           style: AappTextStyle.roboto(
// //                             fontSize: 56,
// //                             weight: FontWeight.bold,
// //                             color: Colors.red,
// //                           ),
// //                           children: [
// //                             TextSpan(
// //                               text: 'Afr',
// //                               style: AappTextStyle.roboto(
// //                                 fontSize: 56,
// //                                 weight: FontWeight.bold,
// //                                 color: Colors.red,
// //                               ),
// //                             ),
// //                             TextSpan(
// //                               text: 'o',
// //                               style: AappTextStyle.roboto(
// //                                 fontSize: 56,
// //                                 weight: FontWeight.bold,
// //                                 color: dark ? Colors.white : Colors.black,
// //                               ),
// //                             ),
// //                             TextSpan(
// //                               text: 'n',
// //                               style: AappTextStyle.roboto(
// //                                 fontSize: 56,
// //                                 weight: FontWeight.bold,
// //                                 color: AColors.primary,
// //                               ),
// //                             ),
// //                             TextSpan(
// //                               text: 'ika',
// //                               style: AappTextStyle.roboto(
// //                                 fontSize: 56,
// //                                 weight: FontWeight.bold,
// //                                 color: Colors.cyan,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //
// //             const SizedBox(height: 80),
// //
// //             // Enhanced progress bar
// //             AnimatedBuilder(
// //               animation: _progressAnimationController,
// //               builder: (context, child) {
// //                 return FadeTransition(
// //                   opacity: _progressAnimation,
// //                   child: Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 40),
// //                     child: Container(
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(15),
// //                         border: Border.all(
// //                           color: AColors.primary,
// //                           width: 2,
// //                         ),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.black.withOpacity(0.1),
// //                             blurRadius: 15,
// //                             offset: const Offset(0, 5),
// //                           ),
// //                         ],
// //                       ),
// //                       child: Stack(
// //                         children: [
// //                           // Background bar
// //                           Container(
// //                             height: 20,
// //                             decoration: BoxDecoration(
// //                               color: dark
// //                                   ? Colors.grey[800]
// //                                   : Colors.grey[200],
// //                               borderRadius: BorderRadius.circular(15),
// //                             ),
// //                           ),
// //
// //                           // Progress bar with gradient
// //                           AnimatedContainer(
// //                             duration: const Duration(milliseconds: 200),
// //                             height: 20,
// //                             width: (size.width - 80) * progress,
// //                             decoration: BoxDecoration(
// //                               borderRadius: BorderRadius.circular(15),
// //                               gradient: const LinearGradient(
// //                                 colors: [
// //                                   Colors.tealAccent,
// //                                   Colors.cyan,
// //                                   Colors.lightBlue,
// //                                 ],
// //                                 begin: Alignment.centerLeft,
// //                                 end: Alignment.centerRight,
// //                               ),
// //                               boxShadow: [
// //                                 BoxShadow(
// //                                   color: Colors.tealAccent.withOpacity(0.4),
// //                                   blurRadius: 10,
// //                                   offset: const Offset(0, 2),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //
// //                           // Animated shimmer effect
// //                           AnimatedContainer(
// //                             duration: const Duration(milliseconds: 200),
// //                             height: 20,
// //                             width: (size.width - 80) * progress,
// //                             decoration: BoxDecoration(
// //                               borderRadius: BorderRadius.circular(15),
// //                               gradient: LinearGradient(
// //                                 colors: [
// //                                   Colors.white.withOpacity(0.0),
// //                                   Colors.white.withOpacity(0.3),
// //                                   Colors.white.withOpacity(0.0),
// //                                 ],
// //                                 stops: const [0.0, 0.5, 1.0],
// //                                 begin: Alignment.centerLeft,
// //                                 end: Alignment.centerRight,
// //                               ),
// //                             ),
// //                           ),
// //
// //                           // Percentage text
// //                           Container(
// //                             height: 20,
// //                             alignment: Alignment.center,
// //                             child: AnimatedOpacity(
// //                               opacity: progress > 0.1 ? 1.0 : 0.0,
// //                               duration: const Duration(milliseconds: 300),
// //                               child: Text(
// //                                 '${(progress * 100).toInt()}%',
// //                                 style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontWeight: FontWeight.bold,
// //                                   fontSize: 12,
// //                                   shadows: [
// //                                     Shadow(
// //                                       color: Colors.black54,
// //                                       blurRadius: 2,
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //
// //             const SizedBox(height: 30),
// //
// //             // Loading text
// //             AnimatedSwitcher(
// //               duration: const Duration(milliseconds: 300),
// //               child: Text(
// //                 _currentLoadingText,
// //                 key: ValueKey(_currentLoadingText),
// //                 style: AappTextStyle.roboto(
// //                   fontSize: 16,
// //                   weight: FontWeight.w500,
// //                   color: dark ? Colors.white70 : Colors.black54,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'dart:async';
// import 'dart:math' as math;
// import 'package:afronika/routes/routes_name.dart';
// import 'package:afronika/utils/constant/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
//
// import '../../../utils/constant/app_test_style.dart';
// import '../../../utils/device/device_utility.dart';
//
// import '../provider/auth_provider.dart'; // Add your auth provider import
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   double progress = 0.0;
//   late AnimationController _logoAnimationController;
//   late AnimationController _progressAnimationController;
//   late AnimationController _pulseAnimationController;
//   late AnimationController _fadeAnimationController;
//
//   late Animation<double> _logoScaleAnimation;
//   late Animation<double> _logoFadeAnimation;
//   late Animation<double> _progressAnimation;
//   late Animation<double> _pulseAnimation;
//   late Animation<double> _fadeAnimation;
//
//   Timer? _progressTimer;
//   bool _isNavigating = false;
//
//   final List<String> _loadingTexts = [
//     'Initializing...',
//     'Checking authentication...',
//     'Verifying email status...',
//     'Loading resources...',
//     'Preparing experience...',
//     'Almost ready...',
//     'Welcome to Afronika!',
//   ];
//
//   String _currentLoadingText = 'Initializing...';
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _startAnimations();
//     _startProgress();
//   }
//
//   void _initializeAnimations() {
//     _logoAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//
//     _progressAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//     );
//
//     _pulseAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//
//     _fadeAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//
//     _logoScaleAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _logoAnimationController,
//       curve: Curves.elasticOut,
//     ));
//
//     _logoFadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _logoAnimationController,
//       curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
//     ));
//
//     _progressAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _progressAnimationController,
//       curve: Curves.easeInOut,
//     ));
//
//     _pulseAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.1,
//     ).animate(CurvedAnimation(
//       parent: _pulseAnimationController,
//       curve: Curves.easeInOut,
//     ));
//
//     _fadeAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.0,
//     ).animate(CurvedAnimation(
//       parent: _fadeAnimationController,
//       curve: Curves.easeInOut,
//     ));
//   }
//
//   void _startAnimations() {
//     _logoAnimationController.forward();
//     _progressAnimationController.forward();
//     _pulseAnimationController.repeat(reverse: true);
//
//     // Delay the fade animation to start after logo animation
//     Future.delayed(const Duration(milliseconds: 800), () {
//       if (mounted) {
//         _fadeAnimationController.forward();
//       }
//     });
//   }
//
//   void _startProgress() {
//     _progressTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
//       if (!mounted) {
//         timer.cancel();
//         return;
//       }
//
//       setState(() {
//         progress += 0.008;
//
//         // Update loading text based on progress
//         if (progress < 0.15) {
//           _currentLoadingText = _loadingTexts[0];
//         } else if (progress < 0.3) {
//           _currentLoadingText = _loadingTexts[1];
//         } else if (progress < 0.45) {
//           _currentLoadingText = _loadingTexts[2];
//         } else if (progress < 0.6) {
//           _currentLoadingText = _loadingTexts[3];
//         } else if (progress < 0.75) {
//           _currentLoadingText = _loadingTexts[4];
//         } else if (progress < 0.9) {
//           _currentLoadingText = _loadingTexts[5];
//         } else {
//           _currentLoadingText = _loadingTexts[6];
//         }
//
//         if (progress >= 1.0) {
//           progress = 1.0;
//           timer.cancel();
//           _checkAuthAndNavigate();
//         }
//       });
//     });
//   }
//
//   Future<void> _checkAuthAndNavigate() async {
//     if (_isNavigating) return;
//     _isNavigating = true;
//
//     HapticFeedback.lightImpact();
//
//     // Add a small delay before navigation for better UX
//     await Future.delayed(const Duration(milliseconds: 500));
//
//     if (!mounted) return;
//
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//
//     String message = '';
//     String nextRoute = '';
//
//     // Check if user exists first
//     if (authProvider.user != null) {
//       print("User exists: ${authProvider.user?.email}");
//
//       // Check email verification status by calling the updated method
//       setState(() {
//         _currentLoadingText = 'Verifying email status...';
//       });
//
//       await Future.delayed(const Duration(milliseconds: 500));
//
//       // Use the updated checkEmailVerification method
//       bool isVerified = await authProvider.checkEmailVerification();
//
//       if (isVerified) {
//         // User is authenticated and email is verified - go to main app
//         message = 'Welcome back, ${authProvider.user?.displayName ?? 'User'}!';
//         nextRoute = RouteName.navigationMenu;
//         print("✅ User authenticated and verified - going to main app");
//       } else {
//         // User exists but email is not verified - go to verification screen
//         message = 'Please verify your email to continue';
//         nextRoute = RouteName.emailVerificationScreen;
//         print("❌ User exists but email not verified - going to verification screen");
//       }
//     } else {
//       // No user exists - go to onboarding/login
//       message = 'Welcome to Afronika!';
//       nextRoute = RouteName.onboardingScreen;
//       print("No user found - going to onboarding");
//     }
//
//     // Show the message and navigate
//     _showNavigationMessage(message, nextRoute);
//   }
//
//   void _showNavigationMessage(String message, String nextRoute) {
//     // Update the current loading text to show the message
//     setState(() {
//       _currentLoadingText = message;
//     });
//
//     // Show a brief message before navigating
//     Future.delayed(const Duration(milliseconds: 1500), () {
//       if (mounted) {
//         Navigator.pushReplacementNamed(context, nextRoute);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _progressTimer?.cancel();
//     _logoAnimationController.dispose();
//     _progressAnimationController.dispose();
//     _pulseAnimationController.dispose();
//     _fadeAnimationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool dark = ADeviceUtils.isDarkMode(context);
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Logo with animations
//             AnimatedBuilder(
//               animation: _logoAnimationController,
//               builder: (context, child) {
//                 return Transform.scale(
//                   scale: _logoScaleAnimation.value,
//                   child: FadeTransition(
//                     opacity: _logoFadeAnimation,
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(),
//                       child: RichText(
//                         text: TextSpan(
//                           style: AappTextStyle.roboto(
//                             fontSize: 56,
//                             weight: FontWeight.bold,
//                             color: Colors.red,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: 'Afr',
//                               style: AappTextStyle.roboto(
//                                 fontSize: 56,
//                                 weight: FontWeight.bold,
//                                 color: Colors.red,
//                               ),
//                             ),
//                             TextSpan(
//                               text: 'o',
//                               style: AappTextStyle.roboto(
//                                 fontSize: 56,
//                                 weight: FontWeight.bold,
//                                 color: dark ? Colors.white : Colors.black,
//                               ),
//                             ),
//                             TextSpan(
//                               text: 'n',
//                               style: AappTextStyle.roboto(
//                                 fontSize: 56,
//                                 weight: FontWeight.bold,
//                                 color: AColors.primary,
//                               ),
//                             ),
//                             TextSpan(
//                               text: 'ika',
//                               style: AappTextStyle.roboto(
//                                 fontSize: 56,
//                                 weight: FontWeight.bold,
//                                 color: Colors.cyan,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//
//             const SizedBox(height: 80),
//
//             // Enhanced progress bar
//             AnimatedBuilder(
//               animation: _progressAnimationController,
//               builder: (context, child) {
//                 return FadeTransition(
//                   opacity: _progressAnimation,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 40),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         border: Border.all(
//                           color: AColors.primary,
//                           width: 2,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 15,
//                             offset: const Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: Stack(
//                         children: [
//                           // Background bar
//                           Container(
//                             height: 20,
//                             decoration: BoxDecoration(
//                               color: dark
//                                   ? Colors.grey[800]
//                                   : Colors.grey[200],
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//
//                           // Progress bar with gradient
//                           AnimatedContainer(
//                             duration: const Duration(milliseconds: 200),
//                             height: 20,
//                             width: (size.width - 80) * progress,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               gradient: const LinearGradient(
//                                 colors: [
//                                   Colors.tealAccent,
//                                   Colors.cyan,
//                                   Colors.lightBlue,
//                                 ],
//                                 begin: Alignment.centerLeft,
//                                 end: Alignment.centerRight,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.tealAccent.withOpacity(0.4),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           // Animated shimmer effect
//                           AnimatedContainer(
//                             duration: const Duration(milliseconds: 200),
//                             height: 20,
//                             width: (size.width - 80) * progress,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.white.withOpacity(0.0),
//                                   Colors.white.withOpacity(0.3),
//                                   Colors.white.withOpacity(0.0),
//                                 ],
//                                 stops: const [0.0, 0.5, 1.0],
//                                 begin: Alignment.centerLeft,
//                                 end: Alignment.centerRight,
//                               ),
//                             ),
//                           ),
//
//                           // Percentage text
//                           Container(
//                             height: 20,
//                             alignment: Alignment.center,
//                             child: AnimatedOpacity(
//                               opacity: progress > 0.1 ? 1.0 : 0.0,
//                               duration: const Duration(milliseconds: 300),
//                               child: Text(
//                                 '${(progress * 100).toInt()}%',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12,
//                                   shadows: [
//                                     Shadow(
//                                       color: Colors.black54,
//                                       blurRadius: 2,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//
//             const SizedBox(height: 30),
//
//             // Loading text
//             AnimatedSwitcher(
//               duration: const Duration(milliseconds: 300),
//               child: Text(
//                 _currentLoadingText,
//                 key: ValueKey(_currentLoadingText),
//                 style: AappTextStyle.roboto(
//                   fontSize: 16,
//                   weight: FontWeight.w500,
//                   color: dark ? Colors.white70 : Colors.black54,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:math' as math;
import 'package:afronika/routes/routes_name.dart';
import 'package:afronika/utils/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../services/UserService.dart';
import '../../../utils/constant/app_test_style.dart';
import '../../../utils/device/device_utility.dart';
import '../provider/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double progress = 0.0;
  late AnimationController _logoAnimationController;
  late AnimationController _progressAnimationController;
  late AnimationController _pulseAnimationController;
  late AnimationController _fadeAnimationController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  Timer? _progressTimer;
  bool _isNavigating = false;
  final UserService _userService = UserService.instance;

  final List<String> _loadingTexts = [
    'Initializing...',
    'Checking saved login...',
    'Verifying authentication...',
    'Loading user data...',
    'Preparing experience...',
    'Almost ready...',
    'Welcome to Afronika!',
  ];

  String _currentLoadingText = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _startProgress();
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _logoAnimationController.forward();
    _progressAnimationController.forward();
    _pulseAnimationController.repeat(reverse: true);

    // Delay the fade animation to start after logo animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _fadeAnimationController.forward();
      }
    });
  }

  void _startProgress() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        progress += 0.008;

        // Update loading text based on progress
        if (progress < 0.15) {
          _currentLoadingText = _loadingTexts[0];
        } else if (progress < 0.25) {
          _currentLoadingText = _loadingTexts[1];
        } else if (progress < 0.4) {
          _currentLoadingText = _loadingTexts[2];
        } else if (progress < 0.55) {
          _currentLoadingText = _loadingTexts[3];
        } else if (progress < 0.7) {
          _currentLoadingText = _loadingTexts[4];
        } else if (progress < 0.9) {
          _currentLoadingText = _loadingTexts[5];
        } else {
          _currentLoadingText = _loadingTexts[6];
        }

        if (progress >= 1.0) {
          progress = 1.0;
          timer.cancel();
          _checkAuthAndNavigate();
        }
      });
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    if (_isNavigating) return;
    _isNavigating = true;

    HapticFeedback.lightImpact();

    // Add a small delay before navigation for better UX
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    try {
      // Initialize UserService
      await _userService.init();

      // Check saved login state first
      setState(() {
        _currentLoadingText = 'Checking saved login...';
      });
      await Future.delayed(const Duration(milliseconds: 300));

      UserAuthStatus savedStatus = await _userService.getUserAuthStatus();

      // Get redirect route based on saved status
      String nextRoute = await _userService.getRedirectRoute();
      String message = '';

      // Debug print saved data
      await _userService.debugPrintSavedData();

      switch (savedStatus) {
        case UserAuthStatus.authenticatedAndVerified:
        // User was previously logged in and verified
          setState(() {
            _currentLoadingText = 'Loading user data...';
          });
          await Future.delayed(const Duration(milliseconds: 300));

          Map<String, dynamic>? userData = await _userService
              .getSavedUserData();
          String userName = userData?['displayName'] ?? 'User';

          message = 'Welcome back, $userName!';
          nextRoute = RouteName.navigationMenu;
          print("🔄 Auto-login: Redirecting to NavigationMenu");
          break;

        case UserAuthStatus.authenticatedButNotVerified:
        // User was logged in but email not verified
          setState(() {
            _currentLoadingText = 'Verifying email status...';
          });
          await Future.delayed(const Duration(milliseconds: 300));

          // Check current Firebase auth state and email verification
          final authProvider = Provider.of<AuthProvider>(
              context, listen: false);
          await authProvider.checkSavedLoginState();

          if (authProvider.user != null) {
            bool isNowVerified = await authProvider.checkEmailVerification();
            if (isNowVerified) {
              message = 'Email verified! Welcome back!';
              nextRoute = RouteName.navigationMenu;
            } else {
              message = 'Please verify your email to continue';
              nextRoute = RouteName.emailVerificationScreen1;
            }
          } else {
            // Firebase session expired
            message = 'Session expired. Please login again.';
            nextRoute = RouteName.onboardingScreen;
          }
          break;

        case UserAuthStatus.notLoggedIn:
        default:
        // No saved login or expired
          message = 'Welcome to Afronika!';
          nextRoute = RouteName.onboardingScreen;
          print("🔄 No saved login: Redirecting to Onboarding");
          break;
      }

      // Show the message and navigate
      _showNavigationMessage(message, nextRoute);
    } catch (e) {
      print("Error during auth check: $e");
      // Fallback to onboarding on error
      _showNavigationMessage(
          'Welcome to Afronika!', RouteName.onboardingScreen);
    }
  }

  void _showNavigationMessage(String message, String nextRoute) {
    // Update the current loading text to show the message
    setState(() {
      _currentLoadingText = message;
    });

    // Show a brief message before navigating
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, nextRoute);
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _logoAnimationController.dispose();
    _progressAnimationController.dispose();
    _pulseAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = ADeviceUtils.isDarkMode(context);
    final size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with animations
            AnimatedBuilder(
              animation: _logoAnimationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoScaleAnimation.value,
                  child: FadeTransition(
                    opacity: _logoFadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(),
                      child: RichText(
                        text: TextSpan(
                          style: AappTextStyle.roboto(
                            fontSize: 56,
                            weight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          children: [
                            TextSpan(
                              text: 'Afr',
                              style: AappTextStyle.roboto(
                                fontSize: 56,
                                weight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            TextSpan(
                              text: 'o',
                              style: AappTextStyle.roboto(
                                fontSize: 56,
                                weight: FontWeight.bold,
                                color: dark ? Colors.white : Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'n',
                              style: AappTextStyle.roboto(
                                fontSize: 56,
                                weight: FontWeight.bold,
                                color: AColors.primary,
                              ),
                            ),
                            TextSpan(
                              text: 'ika',
                              style: AappTextStyle.roboto(
                                fontSize: 56,
                                weight: FontWeight.bold,
                                color: Colors.cyan,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 80),

            // Enhanced progress bar
            AnimatedBuilder(
              animation: _progressAnimationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _progressAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AColors.primary,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Background bar
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: dark
                                  ? Colors.grey[800]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),

                          // Progress bar with gradient
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 20,
                            width: (size.width - 80) * progress,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.tealAccent,
                                  Colors.cyan,
                                  Colors.lightBlue,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.tealAccent.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),

                          // Animated shimmer effect
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 20,
                            width: (size.width - 80) * progress,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white.withOpacity(0.3),
                                  Colors.white.withOpacity(0.0),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),

                          // Percentage text
                          Container(
                            height: 20,
                            alignment: Alignment.center,
                            child: AnimatedOpacity(
                              opacity: progress > 0.1 ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                '${(progress * 100).toInt()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Loading text
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _currentLoadingText,
                key: ValueKey(_currentLoadingText),
                style: AappTextStyle.roboto(
                  fontSize: 16,
                  weight: FontWeight.w500,
                  color: dark ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}