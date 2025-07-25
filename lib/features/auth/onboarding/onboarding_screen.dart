import 'package:afronika/common/GButton.dart';
import 'package:afronika/features/auth/onboarding/widget/widget_onboarding.dart';
import 'package:afronika/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/constant/image_strings.dart';
import '../../../utils/constant/text_strings.dart';
import '../../../webview/AfronikaWebView.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Keys for SharedPreferences
  static const String _firstLaunchKey = 'first_launch_completed';
  static const String _onboardingSeenKey = 'onboarding_seen';
  static const String _appVersionKey = 'app_version';

  // Current app version - increment this when you want to show onboarding again
  static const String _currentAppVersion = '1.0.0';

  bool _isLoading = true;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: AText.oBorDing1Title,
      description: AText.oBorDing1Sub,
      image: GImagePath.image1,
    ),
    OnboardingPage(
      title: AText.oBorDing2Title,
      description: AText.oBorDing2Sub,
      image: GImagePath.image2,
    ),
    OnboardingPage(
      title: AText.oBorDing3Title,
      description: AText.oBorDing3Sub,
      image: GImagePath.image3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  /// Check if this is the first time the user is opening the app
  Future<void> _checkFirstTimeUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if this is the very first launch
      final bool isFirstLaunch = !prefs.containsKey(_firstLaunchKey);

      // Check if onboarding has been seen for current version
      final bool hasSeenOnboarding = prefs.getBool(_onboardingSeenKey) ?? false;
      final String? savedVersion = prefs.getString(_appVersionKey);

      // Show onboarding if:
      // 1. First time launching the app, OR
      // 2. App version has changed (for new features), OR
      // 3. User hasn't seen onboarding for current version
      final bool shouldShowOnboarding = isFirstLaunch ||
          savedVersion != _currentAppVersion ||
          !hasSeenOnboarding;

      if (shouldShowOnboarding) {
        // This is first time or version changed - show onboarding
        setState(() {
          _isLoading = false;
        });

        // Mark that first launch is completed
        if (isFirstLaunch) {
          await prefs.setBool(_firstLaunchKey, true);
        }
      } else {
        // User has seen onboarding before - skip to login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, RouteName.loginScreen);
          }
        });
      }
    } catch (e) {
      print('Error checking first time user: $e');
      // On error, show onboarding to be safe
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Mark onboarding as completed for current version
  Future<void> _markOnboardingAsCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingSeenKey, true);
      await prefs.setString(_appVersionKey, _currentAppVersion);

      // Also store completion timestamp for analytics if needed
      await prefs.setInt('onboarding_completed_timestamp',
          DateTime.now().millisecondsSinceEpoch);

      print('Onboarding marked as completed for version $_currentAppVersion');
    } catch (e) {
      print('Error marking onboarding as completed: $e');
    }
  }

  /// Reset onboarding status (useful for testing)
  Future<void> _resetOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_onboardingSeenKey);
      await prefs.remove(_appVersionKey);
      await prefs.remove('onboarding_completed_timestamp');
      print('Onboarding status reset');
    } catch (e) {
      print('Error resetting onboarding status: $e');
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }



  void _completeOnboarding() {
    _markOnboardingAsCompleted().then((_) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) =>  AfronikaBrowserApp()),
        );

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking first time status
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ),
      );
    }

    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              // Header with skip button

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPageWidget(
                      page: _pages[index],
                      dark: dark,
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                      (index) => AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 20 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: _currentPage == index
                          ? Colors.orange
                          : (dark ? Colors.grey[600] : Colors.grey[300]),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40),

              // Navigation button
              AButton(
                text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                onPressed: _nextPage,
              ),

              // Debug reset button (only show in debug mode)
              if (false) // Set to true for debugging
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: TextButton(
                    onPressed: _resetOnboardingStatus,
                    child: Text(
                      'Reset Onboarding (Debug)',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}