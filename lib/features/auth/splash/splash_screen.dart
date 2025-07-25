import 'dart:async';
import 'package:afronika/routes/routes_name.dart';
import 'package:afronika/utils/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/constant/app_test_style.dart';
import '../../../utils/device/device_utility.dart';
import '../../../webview/AfronikaWebView.dart';
import '../onboarding/onboarding_screen.dart';

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

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _progressAnimation;
  static const String _firstLaunchKey = 'first_launch_completed';
  static const String _onboardingSeenKey = 'onboarding_seen';
  static const String _appVersionKey = 'app_version';
  static const String _currentAppVersion = '1.0.0'; // Update as needed

  Timer? _progressTimer;
  bool _isNavigating = false;

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
  }

  void _startAnimations() {
    _logoAnimationController.forward();
    _progressAnimationController.forward();
  }

  void _startProgress() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        progress += 0.025; // Fast progress
      });

      if (progress >= 1.0) {
        progress = 1.0;
        timer.cancel();
        _navigateToOnboarding();
      }
    });
  }

  void _navigateToOnboarding() async {
    if (_isNavigating) return;
    _isNavigating = true;

    HapticFeedback.lightImpact();

    final prefs = await SharedPreferences.getInstance();

    final bool isFirstLaunch = !prefs.containsKey(_firstLaunchKey);
    final bool hasSeenOnboarding = prefs.getBool(_onboardingSeenKey) ?? false;
    final String? savedVersion = prefs.getString(_appVersionKey);

    final bool shouldShowOnboarding = isFirstLaunch ||
        savedVersion != _currentAppVersion ||
        !hasSeenOnboarding;

    // Delay slightly to allow animation to finish
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      if (shouldShowOnboarding) {
        // First time or version update -> Onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );

        // Mark that first launch is completed
        prefs.setBool(_firstLaunchKey, true);
      } else {
        // Already onboarded -> Go to main app
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) =>  AfronikaBrowserApp()),
        );
      }
    });
  }

  // void _navigateToOnboarding() {
  //   if (_isNavigating) return;
  //   _isNavigating = true;
  //
  //   HapticFeedback.lightImpact();
  //
  //   Future.delayed(const Duration(milliseconds: 300), () {
  //     if (mounted) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (_) => OnboardingScreen()),
  //       );
  //     }
  //   });
  //
  // }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _logoAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = ADeviceUtils.isDarkMode(context);
    final size = MediaQuery.of(context).size;

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

            // Simple progress bar
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
                      ),
                      child: Stack(
                        children: [
                          // Background bar
                          Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: dark ? Colors.grey[800] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),

                          // Progress bar with gradient
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
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
          ],
        ),
      ),
    );
  }
}