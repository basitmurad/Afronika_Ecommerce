import 'package:afronika/utils/device/device_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:afronika/common/GButton.dart';
import 'package:afronika/common/app_logo.dart';
import 'package:afronika/routes/routes_name.dart';
import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/constant/paddings.dart';
import 'package:afronika/utils/constant/text_strings.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constant/sizes.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isResendingLink = false;
  int _countdownTimer = 0;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _countdownTimer = 60; // 60 seconds countdown
    });

    Future.delayed(const Duration(seconds: 1), _updateCountdown);
  }

  void _updateCountdown() {
    if (_countdownTimer > 0) {
      setState(() {
        _countdownTimer--;
      });
      Future.delayed(const Duration(seconds: 1), _updateCountdown);
    }
  }

  void _resendVerificationLink() async {
    if (_countdownTimer > 0) return;

    setState(() {
      _isResendingLink = true;
    });

    try {
      // Simulate API call to resend verification email
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification email sent to ${widget.email}'),
            backgroundColor: Colors.green,
          ),
        );
        _startCountdown();
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send verification email. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResendingLink = false;
        });
      }
    }
  }

  void _openEmailApp() {
    // This would typically open the default email app
    // You can use url_launcher package: launch('mailto:')
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening email app...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _goBackToLogin() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteName.loginScreen,
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 44),

              // App Logo
              const AppLogo(),

              const SizedBox(height: 40),

              // Email verification icon
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  CupertinoIcons.mail,
                  size: 60,
                  color: isDark ? Colors.white : Colors.black54,
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                'Verify Your Email',
                style: AappTextStyle.roboto(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 28,
                  weight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'We\'ve sent a verification link to',
                  style: AappTextStyle.roboto(
                    color: isDark ? Colors.grey[300]! : Colors.grey[600]!,
                    fontSize: 16,
                    weight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 8),

              // Email address
              Text(
                widget.email,
                style: AappTextStyle.roboto(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                  weight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Instructions
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Please check your email and click the verification link to activate your account.',
                  style: AappTextStyle.roboto(
                    color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                    fontSize: 14,
                    weight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              // Open Email App Button
              AButton(
                text: 'Open Email App',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textColor: Colors.white,
                onPressed: _openEmailApp,
              ),

              SizedBox(height: ASizes.spaceBtwInputFields + 20),

              // Resend verification link section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t receive the email? ',
                    style: AappTextStyle.roboto(
                      color:isDark ? Colors.grey[600]! : Colors.grey[300]!,
                      fontSize: 14,
                      weight: FontWeight.w400,
                    ),
                  ),
                  if (_countdownTimer > 0)
                    Text(
                      'Resend in ${_countdownTimer}s',
                      style: AappTextStyle.roboto(
                        color: Colors.grey,
                        fontSize: 14,
                        weight: FontWeight.w400,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: _isResendingLink ? null : _resendVerificationLink,
                      child: Text(
                        _isResendingLink ? 'Sending...' : 'Resend Link',
                        style: AappTextStyle.roboto(
                          color: _isResendingLink ? Colors.grey : Colors.lightBlue,
                          fontSize: 14,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 40),

              // Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDark ? Colors.grey[600] : Colors.grey[300],
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or',
                      style: AappTextStyle.roboto(
                        color: isDark ? Colors.grey[400]! : Colors.grey[500]!,
                        fontSize: 14,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isDark ? Colors.grey[600] : Colors.grey[300],
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Back to Login Button
              AButton(
                text: 'Back to Login',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                textColor: isDark ? Colors.white : Colors.black,
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                onPressed: _goBackToLogin,
              ),

              const SizedBox(height: 40),

              // Help text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'If you continue to have problems, please contact our support team.',
                  style: AappTextStyle.roboto(
                    color: isDark ? Colors.grey[400]! : Colors.grey[500]!,
                    fontSize: 12,
                    weight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}