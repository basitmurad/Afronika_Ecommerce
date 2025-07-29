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

  // Simple SharedPreferences key
  static const String _onboardingCompletedKey = 'onboarding_completed';

  Timer? _progressTimer;
  bool _isNavigating = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isDisposed) {
        _initializeAnimations();
        _startAnimations();
        _startProgress();
      }
    });
  }

  void _initializeAnimations() {
    if (_isDisposed) return;

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
    if (_isDisposed || !mounted) return;

    try {
      _logoAnimationController.forward();
      _progressAnimationController.forward();
    } catch (e) {
      print('Animation error: $e');
    }
  }

  void _startProgress() {
    if (_isDisposed) return;

    _progressTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (!mounted || _isDisposed) {
        timer.cancel();
        return;
      }

      if (mounted) {
        setState(() {
          progress += 0.025; // Fast progress
        });
      }

      if (progress >= 1.0) {
        progress = 1.0;
        timer.cancel();
        _checkNavigationDestination();
      }
    });
  }

  Future<void> _checkNavigationDestination() async {
    if (_isNavigating || _isDisposed || !mounted) return;
    _isNavigating = true;

    try {
      HapticFeedback.lightImpact();
    } catch (e) {
      print('Haptic feedback error: $e');
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final bool hasCompletedOnboarding = prefs.getBool(_onboardingCompletedKey) ?? false;

      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted || _isDisposed) return;

      // Just print messages without navigation
      if (hasCompletedOnboarding) {

        Future.microtask(() {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AfronikaBrowserApp()),
          );
        });
        print('✅ Returning user — would launch main app');
      } else {
        print('🟢 First time user — would show onboarding');
        Future.microtask(() {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => OnboardingScreen()),
          );
        });

      }

    } catch (e) {
      print('🔴 Error checking onboarding state: $e');
    }
  }

  void _fallbackNavigation() {
    if (!mounted || _isDisposed) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isDisposed) return;

      try {
        print('⚠️ Fallback — showing onboarding');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const OnboardingScreen(),
          ),
        );
      } catch (e) {
        print('Fallback navigation error: $e');
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _progressTimer?.cancel();

    try {
      _logoAnimationController.dispose();
      _progressAnimationController.dispose();
    } catch (e) {
      print('Dispose error: $e');
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isDisposed) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final bool dark = ADeviceUtils.isDarkMode(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Center(
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
      ),
    );
  }
}