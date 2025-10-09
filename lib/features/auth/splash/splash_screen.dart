import 'dart:async';
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
    with SingleTickerProviderStateMixin {
  double progress = 0.0;
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  static const String _onboardingCompletedKey = 'onboarding_completed';

  Timer? _progressTimer;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller immediately
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations and progress after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _progressAnimationController.forward();
        _startProgress();
      }
    });
  }

  void _startProgress() {
    if (!mounted) return;

    // Slightly longer interval for better iOS performance
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        progress += 0.03; // Adjusted for 50ms interval
        if (progress > 1.0) progress = 1.0;
      });

      if (progress >= 1.0) {
        timer.cancel();
        _checkNavigationDestination();
      }
    });
  }

  Future<void> _checkNavigationDestination() async {
    if (_isNavigating || !mounted) return;
    _isNavigating = true;

    try {
      HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }

    try {
      // Add a small delay before checking preferences on iOS
      await Future.delayed(const Duration(milliseconds: 100));

      final prefs = await SharedPreferences.getInstance();
      final bool hasCompletedOnboarding =
          prefs.getBool(_onboardingCompletedKey) ?? false;

      // Additional delay for smoother transition
      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      // Use pushReplacement directly instead of Future.microtask
      if (hasCompletedOnboarding) {
        debugPrint('✅ Returning user — launching main app');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const AfronikaBrowserApp(),
          ),
        );
      } else {
        debugPrint('🟢 First time user — showing onboarding');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const OnboardingScreen(),
          ),
        );
      }
    } catch (e) {
      debugPrint('🔴 Error checking onboarding state: $e');
      if (mounted) {
        _fallbackNavigation();
      }
    }
  }

  void _fallbackNavigation() {
    if (!mounted) return;

    try {
      debugPrint('⚠️ Fallback — showing onboarding');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        ),
      );
    } catch (e) {
      debugPrint('Fallback navigation error: $e');
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = ADeviceUtils.isDarkMode(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
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
                        text: 'A',
                        style: AappTextStyle.roboto(
                          fontSize: 56,
                          letterSpacing: 0.3,
                          weight: FontWeight.bold,
                          color: AColors.hardRed,
                        ),
                      ),
                      TextSpan(
                        text: 'fro',
                        style: AappTextStyle.roboto(
                          letterSpacing: 0.3,
                          fontSize: 56,
                          weight: FontWeight.bold,
                          color: AColors.hardRed,
                        ),
                      ),
                      TextSpan(
                        text: 'ni',
                        style: AappTextStyle.roboto(
                          fontSize: 56,
                          letterSpacing: 0.3,
                          weight: FontWeight.bold,
                          color: AColors.primary,
                        ),
                      ),
                      TextSpan(
                        text: 'ka',
                        style: AappTextStyle.roboto(
                          fontSize: 56,
                          letterSpacing: 0.3,
                          weight: FontWeight.bold,
                          color: AColors.lightBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Animated progress bar
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