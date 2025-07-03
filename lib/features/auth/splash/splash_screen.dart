import 'dart:async';
import 'dart:math' as math;
import 'package:afronika/routes/routes_name.dart';
import 'package:afronika/utils/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/constant/app_test_style.dart';
import '../../../utils/device/device_utility.dart';
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
  late AnimationController _pulseAnimationController;
  late AnimationController _fadeAnimationController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  Timer? _progressTimer;
  bool _isNavigating = false;

  final List<String> _loadingTexts = [
    'Initializing...',
    'Loading resources...',
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
        if (progress < 0.2) {
          _currentLoadingText = _loadingTexts[0];
        } else if (progress < 0.4) {
          _currentLoadingText = _loadingTexts[1];
        } else if (progress < 0.6) {
          _currentLoadingText = _loadingTexts[2];
        } else if (progress < 0.8) {
          _currentLoadingText = _loadingTexts[3];
        } else {
          _currentLoadingText = _loadingTexts[4];
        }

        if (progress >= 1.0) {
          progress = 1.0;
          timer.cancel();
          _navigateToOnboarding();
        }
      });
    });
  }

  void _navigateToOnboarding() {
    if (_isNavigating) return;
    _isNavigating = true;

    HapticFeedback.lightImpact();

    // Add a small delay before navigation for better UX
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {

        Navigator.pushReplacementNamed(context, RouteName.onboardingScreen);
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
                      decoration: BoxDecoration(
                      ),
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
                                color: dark ?Colors.white :Colors.black,
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
          ],
        ),
      ),
    );
  }
}