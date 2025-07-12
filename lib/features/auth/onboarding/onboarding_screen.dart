// import 'package:afronika/common/GButton.dart';
// import 'package:afronika/features/auth/onboarding/widget/widget_onboarding.dart';
// import 'package:afronika/routes/routes_name.dart';
// import 'package:flutter/material.dart';
// import '../../../utils/constant/image_strings.dart';
// import '../../../utils/constant/text_strings.dart';
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//
//   final List<OnboardingPage> _pages = [
//     OnboardingPage(
//       title: AText.oBorDing1Title,
//       description: AText.oBorDing1Sub,
//       image: GImagePath.image1,
//     ),
//     OnboardingPage(
//       title: AText.oBorDing2Title,
//       description: AText.oBorDing2Sub,
//       image: GImagePath.image2,
//     ),
//     OnboardingPage(
//       title: AText.oBorDing3Title,
//       description: AText.oBorDing3Sub,
//       image: GImagePath.image3,
//     ),
//   ];
//
//   void _nextPage() {
//     if (_currentPage < _pages.length - 1) {
//       _pageController.nextPage(
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       Navigator.pushNamed(context, RouteName.loginScreen);
//       // Navigate to next screen or handle completion
//       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => YourNextScreen()));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool dark = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       backgroundColor: dark ? Colors.black : Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//           child: Column(
//             children: [
//               Expanded(
//                 child: PageView.builder(
//                   controller: _pageController,
//                   itemCount: _pages.length,
//                   onPageChanged: (index) {
//                     setState(() {
//                       _currentPage = index;
//                     });
//                   },
//                   itemBuilder: (context, index) {
//                     return OnboardingPageWidget(page: _pages[index], dark: dark,);
//                   },
//                 ),
//               ),
//
//               SizedBox(height: 20),
//
//               // Page indicators
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(
//                   _pages.length,
//                       (index) => AnimatedContainer(
//                     duration: Duration(milliseconds: 300),
//                     margin: EdgeInsets.symmetric(horizontal: 4),
//                     width: _currentPage == index ? 20 : 10,
//                     height: 10,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       color: _currentPage == index
//                           ? Colors.orange
//                           : Colors.grey[300],
//                     ),
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 40),
//
//               // Navigation button
//               AButton(
//                 text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
//                 onPressed: _nextPage,
//               ),
//
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:afronika/common/GButton.dart';
import 'package:afronika/features/auth/onboarding/widget/widget_onboarding.dart';
import 'package:afronika/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  static const String _onboardingKey = 'onboarding_shown';

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
    _checkOnboardingStatus();
  }

  /// Check if onboarding has been shown before
  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding = prefs.getBool(_onboardingKey) ?? false;

    if (hasSeenOnboarding) {
      // User has already seen onboarding, navigate to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, RouteName.loginScreen);
      });
    }
  }

  /// Mark onboarding as completed
  Future<void> _markOnboardingAsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Mark onboarding as completed and navigate to login
      _markOnboardingAsCompleted().then((_) {
        Navigator.pushReplacementNamed(context, RouteName.loginScreen);
      });
    }
  }

  /// Skip onboarding and go to login
  void _skipOnboarding() {
    _markOnboardingAsCompleted().then((_) {
      Navigator.pushReplacementNamed(context, RouteName.loginScreen);
    });
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
              // Skip button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: dark ? Colors.white70 : Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),

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