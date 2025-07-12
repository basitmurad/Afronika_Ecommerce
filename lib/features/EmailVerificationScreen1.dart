import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../utils/constant/colors.dart';
import '../../../utils/constant/app_test_style.dart';
import '../../../utils/device/device_utility.dart';
import '../../../routes/routes_name.dart';
import '../common/GButton.dart';
import 'auth/provider/auth_provider.dart';

class EmailVerificationScreen1 extends StatefulWidget {
  const EmailVerificationScreen1({super.key});

  @override
  State<EmailVerificationScreen1> createState() =>
      _EmailVerificationScreen1State();
}

class _EmailVerificationScreen1State extends State<EmailVerificationScreen1>
    with TickerProviderStateMixin {
  Timer? _timer;
  bool _isResendingEmail = false;
  bool _isResettingLink = false;
  int _resendCooldown = 0;
  int _resetCooldown = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEmailVerificationCheck();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  void _startEmailVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.checkEmailVerification();

      if (authProvider.isEmailVerified) {
        timer.cancel();
        if (mounted) {
          Navigator.pushReplacementNamed(context, RouteName.navigationMenu);
        }
      }
    });
  }

  Future<void> _resendVerificationEmail() async {
    if (_resendCooldown > 0) return;

    setState(() {
      _isResendingEmail = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success = await authProvider.sendEmailVerification();

    if (mounted) {
      setState(() {
        _isResendingEmail = false;
        if (success) {
          _resendCooldown = 60; // 60 seconds cooldown
          _startResendCooldown();
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Verification email sent successfully!'
                : 'Failed to send verification email. Please try again.',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _resetVerificationLink() async {
    if (_resetCooldown > 0) return;

    setState(() {
      _isResettingLink = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      // Send a fresh verification email (same as resend but with different messaging)
      bool success = await authProvider.sendEmailVerification();

      if (mounted) {
        setState(() {
          _isResettingLink = false;
          if (success) {
            _resetCooldown = 120; // 2 minutes cooldown for reset
            _startResetCooldown();
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'New verification link sent! Please check your email.'
                  : 'Failed to reset verification link. Please try again.',
            ),
            backgroundColor: success ? Colors.blue : Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isResettingLink = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'An error occurred while resetting the link. Please try again.',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _startResendCooldown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _resendCooldown--;
        });

        if (_resendCooldown <= 0) {
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _startResetCooldown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _resetCooldown--;
        });

        if (_resetCooldown <= 0) {
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _signOut() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();

    if (mounted) {
      Navigator.pushReplacementNamed(context, RouteName.onboardingScreen);
    }
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final bool dark = ADeviceUtils.isDarkMode(context);
        return AlertDialog(
          backgroundColor: dark ? Colors.grey[850] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Reset Verification Link',
            style: AappTextStyle.roboto(
              fontSize: 20,
              weight: FontWeight.bold,
              color: dark ? Colors.white : Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This will send a new verification email to your registered email address.',
                style: AappTextStyle.roboto(
                  fontSize: 16,
                  color: dark ? Colors.white70 : Colors.black87,
                  weight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Note: Any previous verification links will become invalid.',
                style: AappTextStyle.roboto(
                  fontSize: 14,
                  color: Colors.orange,
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            AButton(
              text: 'Cancel',
              buttonType: AButtonType.text,
              textColor: dark ? Colors.white70 : Colors.black54,
              height: 40,
              width: 80,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              onPressed: () => Navigator.of(context).pop(),
            ),
            AButton(
              text: 'Reset Link',
              height: 40,
              width: 100,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              backgroundColor: AColors.primary,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
                _resetVerificationLink();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = ADeviceUtils.isDarkMode(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final userEmail = authProvider.user?.email ?? '';

    return Scaffold(
      backgroundColor: dark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          AButton(
            text: 'Sign Out',
            buttonType: AButtonType.text,
            textColor: AColors.primary,
            height: 40,
            width: 80,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            onPressed: _signOut,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  kToolbarHeight -
                  48, // Account for AppBar and padding
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email icon with animation
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: AColors.primary, width: 2),
                        ),
                        child: Icon(
                          Icons.mark_email_unread_outlined,
                          size: 80,
                          color: AColors.primary,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Title
                Text(
                  'Verify Your Email',
                  style: AappTextStyle.roboto(
                    fontSize: 28,
                    weight: FontWeight.bold,
                    color: dark ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'Verification is pending',
                  style: AappTextStyle.roboto(
                    fontSize: 18,
                    weight: FontWeight.w500,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                // Description
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AappTextStyle.roboto(
                      fontSize: 16,
                      color: dark ? Colors.white70 : Colors.black54,
                      height: 1.5,
                      weight: FontWeight.w400,
                    ),
                    children: [
                      const TextSpan(
                        text: 'We\'ve sent a verification link to:\n',
                      ),
                      TextSpan(
                        text: userEmail,
                        style: AappTextStyle.roboto(
                          fontSize: 16,
                          weight: FontWeight.bold,
                          color: AColors.primary,
                        ),
                      ),
                      const TextSpan(
                        text:
                            '\n\nPlease check your email and click the verification link to continue.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Resend email button
                AButton(
                  text: _isResendingEmail
                      ? 'Sending...'
                      : _resendCooldown > 0
                      ? 'Resend in ${_resendCooldown}s'
                      : 'Resend Verification Email',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  backgroundColor: AColors.primary,
                  textColor: Colors.white,
                  onPressed: _resendCooldown > 0 || _isResendingEmail
                      ? null
                      : _resendVerificationEmail,
                ),

                const SizedBox(height: 16),

                // Reset verification link button
                AButton(
                  text: _isResettingLink
                      ? 'Resetting...'
                      : _resetCooldown > 0
                      ? 'Reset available in ${_resetCooldown}s'
                      : 'Reset Verification Link',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  buttonType: AButtonType.outlined,
                  textColor: Colors.blue,
                  onPressed: _resetCooldown > 0 || _isResettingLink
                      ? null
                      : _showResetConfirmationDialog,
                ),

                const SizedBox(height: 16),

                // Check status button
                AButton(
                  text: 'I\'ve verified my email',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  buttonType: AButtonType.outlined,
                  textColor: AColors.primary,
                  onPressed: () async {
                    await authProvider.checkEmailVerification();
                    if (authProvider.isEmailVerified && mounted) {
                      Navigator.pushReplacementNamed(
                        context,
                        RouteName.navigationMenu,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Email not verified yet. Please check your email.',
                          ),
                          backgroundColor: Colors.orange,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 30),

                // Help text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: dark ? Colors.grey[800] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.help_outline,
                        color: dark ? Colors.white70 : Colors.black54,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Having trouble with verification?',
                        style: AappTextStyle.roboto(
                          fontSize: 14,
                          weight: FontWeight.w600,
                          color: dark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Check your spam folder, try resending the email, or reset the verification link if the previous one expired.',
                        style: AappTextStyle.roboto(
                          fontSize: 12,
                          color: dark ? Colors.white60 : Colors.black45,
                          weight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Bottom padding for scroll comfort
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
