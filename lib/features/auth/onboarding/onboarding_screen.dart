import 'package:afronika/common/GButton.dart';
import 'package:afronika/features/auth/onboarding/widget/widget_onboarding.dart';
import 'package:afronika/routes/routes_name.dart';
import 'package:flutter/material.dart';
import '../../../utils/constant/image_strings.dart';
import '../../../utils/constant/text_strings.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushNamed(context, RouteName.loginScreen);
      // Navigate to next screen or handle completion
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => YourNextScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
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
                    return OnboardingPageWidget(page: _pages[index], dark: dark,);
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
                          : Colors.grey[300],
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

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}