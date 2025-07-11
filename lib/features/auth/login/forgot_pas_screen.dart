// import 'package:afronika/features/auth/login/widgets/svg_image.dart';
// import 'package:afronika/routes/routes_name.dart';
// import 'package:afronika/utils/constant/app_test_style.dart';
// import 'package:afronika/utils/constant/image_strings.dart';
// import 'package:afronika/utils/constant/paddings.dart';
// import 'package:afronika/utils/constant/text_strings.dart';
// import 'package:afronika/common/text_input_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:afronika/common/GButton.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class ForgotPasScreen extends StatefulWidget {
//   const ForgotPasScreen({super.key});
//
//   @override
//   State<ForgotPasScreen> createState() => _ForgotPasScreenState();
// }
//
// class _ForgotPasScreenState extends State<ForgotPasScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       backgroundColor: isDark ? Colors.black : Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 10),
//           child: IconButton(
//             onPressed: () {
//               Navigator.pop(context); // Use pop instead of pushNamed for back navigation
//             },
//             icon: Icon(
//               Icons.arrow_back_ios,
//               color: isDark ? Colors.white : Colors.black,
//             ),
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Top spacing
//                 SizedBox(height: 40),
//
//                 // Lock icon with circle background
//                 Center(
//                   child: Container(
//                     width: 154,
//                     height: 154,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: isDark ? Colors.grey[800] : Colors.grey[100],
//                     ),
//                     child: Center(
//                       child: SvgImage(
//                         height: 74.52,
//                         width: 54.65,
//                         imagePath: GImagePath.lockVector,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Spacing after icon
//                 SizedBox(height: 40),
//
//                 // Title
//                 Text(
//                   AText.forgotP,
//                   textAlign: TextAlign.center,
//                   style: AappTextStyle.roboto(
//                     color: isDark ? Colors.white : Colors.black,
//                     fontSize: 36,
//                     weight: FontWeight.w500,
//                   ),
//                 ),
//
//                 // Spacing after title
//                 SizedBox(height: 24),
//
//                 // Description text
//                 Text(
//                   AText.forgotPGuide,
//                   textAlign: TextAlign.center,
//                   style: AappTextStyle.roboto(
//                     color: isDark ? Colors.grey[400]! : Colors.grey[600]!,
//                     fontSize: 16,
//                     weight: FontWeight.w400,
//                     height: 1.5, // Line height for better readability
//                   ),
//                 ),
//
//                 // Spacing before email field
//                 SizedBox(height: 48),
//
//                 // Email input field
//                 TextInputWidget(
//                   headerText: AText.email,
//                   hintText: AText.emailHint,
//                   dark: isDark,
//                 ),
//
//                 // Spacing before send button
//                 SizedBox(height: 32),
//
//                 // Send reset link button
//                 AButton(
//                   text: AText.sendRLink,
//                   fontWeight: FontWeight.w400,
//                   textColor: Colors.white,
//                   onPressed: () {
//                     // Add your send reset link logic here
//                     // Navigator.pushNamed(context, RouteName.sendResetLink);
//                   },
//                 ),
//
//                 // Spacing before back to login
//                 SizedBox(height: 24),
//
//                 // Back to login section
//                 Center(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context); // Use pop to go back
//                     },
//                     child: Text(
//                       AText.backToLogin,
//                       style: AappTextStyle.roboto(
//                         color: Colors.lightBlue,
//                         fontSize: 16,
//                         weight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Bottom spacing
//                 SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:afronika/features/auth/login/widgets/svg_image.dart';
import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/constant/image_strings.dart';
import 'package:afronika/utils/constant/text_strings.dart';
import 'package:afronika/common/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:afronika/common/GButton.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class ForgotPasScreen extends StatefulWidget {
  const ForgotPasScreen({super.key});

  @override
  State<ForgotPasScreen> createState() => _ForgotPasScreenState();
}

class _ForgotPasScreenState extends State<ForgotPasScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendResetLink() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Clear any previous errors
      authProvider.clearError();

      bool success = await authProvider.resetPassword(_emailController.text.trim());

      if (success && mounted) {
        setState(() {
          _emailSent = true;
        });

        _showSuccessDialog();
      }
      // If failed, error message will be shown via Consumer
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'Email Sent!',
                style: AappTextStyle.roboto(
                  fontSize: 20,
                  weight: FontWeight.w600, color: Colors.black,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password reset link has been sent to:',
                style: AappTextStyle.roboto(
                  fontSize: 16,
                  weight: FontWeight.w400, color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _emailController.text.trim(),
                style: AappTextStyle.roboto(
                  fontSize: 16,
                  weight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Please check your email and follow the instructions to reset your password.',
                style: AappTextStyle.roboto(
                  fontSize: 14,
                  weight: FontWeight.w400,
                  color: Colors.grey[600]!,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to login screen
              },
              child: Text(
                'Back to Login',
                style: AappTextStyle.roboto(
                  fontSize: 16,
                  weight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Show error message if there's an error
          if (authProvider.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showErrorSnackBar(authProvider.errorMessage!);
              authProvider.clearError();
            });
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top spacing
                      SizedBox(height: 40),

                      // Lock icon with circle background
                      Center(
                        child: Container(
                          width: 154,
                          height: 154,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? Colors.grey[800] : Colors.grey[100],
                          ),
                          child: Center(
                            child: SvgImage(
                              height: 74.52,
                              width: 54.65,
                              imagePath: GImagePath.lockVector,
                            ),
                          ),
                        ),
                      ),

                      // Spacing after icon
                      SizedBox(height: 40),

                      // Title
                      Text(
                        AText.forgotP,
                        textAlign: TextAlign.center,
                        style: AappTextStyle.roboto(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 36,
                          weight: FontWeight.w500,
                        ),
                      ),

                      // Spacing after title
                      SizedBox(height: 24),

                      // Description text
                      Text(
                        _emailSent
                            ? 'Reset link sent! Please check your email.'
                            : AText.forgotPGuide,
                        textAlign: TextAlign.center,
                        style: AappTextStyle.roboto(
                          color: _emailSent
                              ? Colors.green
                              : (isDark ? Colors.grey[400]! : Colors.grey[600]!),
                          fontSize: 16,
                          weight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),

                      // Spacing before email field
                      SizedBox(height: 48),

                      // Email input field
                      TextInputWidget(
                        controller: _emailController,
                        headerText: AText.email,
                        hintText: AText.emailHint,
                        dark: isDark,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),

                      // Spacing before send button
                      SizedBox(height: 32),

                      // Send reset link button with loading state
                      AButton(
                        text: authProvider.isLoading
                            ? (_emailSent ? 'Email Sent ✓' : 'Sending...')
                            : (_emailSent ? 'Email Sent ✓' : AText.sendRLink),
                        fontWeight: FontWeight.w400,
                        textColor: Colors.white,
                        backgroundColor: _emailSent ? Colors.green : null,
                        onPressed: (authProvider.isLoading || _emailSent)
                            ? null
                            : _handleSendResetLink, // or _handleLogin
                      ),

                      // Spacing before additional options
                      SizedBox(height: 24),

                      // Resend email button (only show after email is sent)
                      if (_emailSent) ...[
                        AButton(
                          text: authProvider.isLoading ? 'Resending...' : 'Resend Email',
                          buttonType: AButtonType.outlined,
                          fontWeight: FontWeight.w400,
                          textColor: isDark ? Colors.white : Colors.black,
                          onPressed: authProvider.isLoading ? null : () {
                            setState(() {
                              _emailSent = false;
                            });
                            _handleSendResetLink();
                          },
                        ),
                        SizedBox(height: 16),
                      ],

                      // Back to login section
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            AText.backToLogin,
                            style: AappTextStyle.roboto(
                              color: Colors.lightBlue,
                              fontSize: 16,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      // Bottom spacing
                      SizedBox(height: 40),

                      // Help text
                      if (_emailSent)
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[900] : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue,
                                size: 24,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Didn\'t receive the email?',
                                style: AappTextStyle.roboto(
                                  fontSize: 16,
                                  weight: FontWeight.w600, color: Colors.grey[600]!,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Check your spam folder or try resending the email.',
                                textAlign: TextAlign.center,
                                style: AappTextStyle.roboto(
                                  fontSize: 14,
                                  weight: FontWeight.w400,
                                  color: Colors.grey[600]!,
                                ),
                              ),
                            ],
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
    );
  }
}