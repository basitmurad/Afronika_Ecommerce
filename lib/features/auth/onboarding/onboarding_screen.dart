import 'package:afronika/common/GButton.dart';
import 'package:afronika/features/auth/onboarding/widget/widget_onboarding.dart';
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

  // Simple SharedPreferences key
  static const String _onboardingCompletedKey = 'onboarding_completed';

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: AText.oBording1Title,
      description: AText.oBording1SubTitle,
      image: GImagePath.image1,
    ),
    OnboardingPage(
      title: AText.oBording2Title,
      description: AText.oBording2SubTitle,
      image: GImagePath.image2,
    ),
    OnboardingPage(
      title: AText.oBording3Title,
      description: AText.oBording3SubTitle,
      image: GImagePath.image3,
    ),
    OnboardingPage(
      title: AText.oBording4Title,
      description: AText.oBording4SubTitle,
      image: GImagePath.image4,
    ),
    OnboardingPage(
      title: AText.oBording5Title,
      description: AText.oBording5SubTitle,
      image: GImagePath.image5,
    ),

    OnboardingPage(
      title: AText.oBording7Title,
      description: AText.oBording7SubTitle,
      image: GImagePath.image7,
    ),
    OnboardingPage(
      title: AText.oBording8Title,
      description: AText.oBording8SubTitle,
      image: GImagePath.image8,
    ),
    OnboardingPage(
      title: AText.oBording9Title,
      description: AText.oBording9SubTitle,
      image: GImagePath.image11,
    ),
    OnboardingPage(
      title: AText.oBording10Title,
      description: AText.oBording10SubTitle,
      image: GImagePath.image12,
    ),
  ];

  /// Mark onboarding as completed
  Future<void> _markOnboardingAsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() async {
    await _markOnboardingAsCompleted();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AfronikaBrowserApp(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),

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

              const SizedBox(height: 16),

              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
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

              const SizedBox(height: 24),

              // Navigation button
              AButton(
                text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                onPressed: _nextPage,
              ),

              const SizedBox(height: 20),
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