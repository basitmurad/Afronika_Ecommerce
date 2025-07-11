// import 'package:afronika/utils/device/device_utility.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:afronika/common/GButton.dart';
// import 'package:afronika/common/app_logo.dart';
// import 'package:afronika/common/text_input_widget.dart';
// import 'package:afronika/routes/routes_name.dart';
// import 'package:afronika/utils/constant/app_test_style.dart';
// import 'package:afronika/utils/constant/paddings.dart';
// import 'package:afronika/utils/constant/text_strings.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../utils/constant/sizes.dart';
//
// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//
//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool showPassword = false;
//   bool showConfirmPassword = false;
//
//   @override
//   void dispose() {
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   // Validation functions
//   String? _validateName(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Name is required';
//     }
//     if (value.length < 2) {
//       return 'Name must be at least 2 characters long';
//     }
//     if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
//       return 'Name can only contain letters and spaces';
//     }
//     return null;
//   }
//
//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Email is required';
//     }
//     final emailRegex = RegExp(
//       r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//     );
//     if (!emailRegex.hasMatch(value)) {
//       return 'Please enter a valid email address';
//     }
//     return null;
//   }
//
//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Password is required';
//     }
//     if (value.length < 8) {
//       return 'Password must be at least 8 characters long';
//     }
//     if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
//       return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
//     }
//     return null;
//   }
//
//   String? _validateConfirmPassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please confirm your password';
//     }
//     if (value != _passwordController.text) {
//       return 'Passwords do not match';
//     }
//     return null;
//   }
//
//   void _handleSignup() {
//
//     Navigator.pushNamed(context, RouteName.emailVerificationScreen);
//
//     // if (_formKey.currentState!.validate()) {
//     //   // All validations passed
//     //   // Proceed with signup logic
//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //     const SnackBar(content: Text('Validation successful!')),
//     //   );
//     //   // Navigator.pushNamed(context, RouteName.accountSignup);
//     // }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = ADeviceUtils.isDarkMode(context);
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 SizedBox(height: 44),
//                 AppLogo(),
//                 Padding(
//                   padding: Paddings.textPd,
//                   child: Text(
//                     AText.signUp,
//                     style: AappTextStyle.roboto(
//                       color: isDark ? Colors.white : Colors.black,
//                       fontSize: 30,
//                       weight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//
//                 // Name Field
//                 TextInputWidget(
//                   headerText: AText.name,
//                   hintText: AText.nameHint,
//                   dark: isDark,
//                   validator: _validateName,
//                 ),
//
//                 SizedBox(height: ASizes.spaceBtwInputFields),
//
//                 // Email Field
//                 TextInputWidget(
//                   headerText: AText.email,
//                   hintText: AText.emailHint,
//                   dark: isDark,
//                   validator: _validateEmail,
//                 ),
//
//                 SizedBox(height: ASizes.spaceBtwInputFields),
//
//                 // Password Field
//                 TextInputWidget(
//                   headerText: AText.pas,
//                   hintText: AText.passHint,
//                   dark: isDark,
//                   isPassword: true,
//                   controller: _passwordController,
//                   validator: _validatePassword,
//                   suffixIcon: Icon(
//                     showPassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
//                   ),
//                   onSuffixIconPressed: () {
//                     setState(() {
//                       showPassword = !showPassword;
//                     });
//                   },
//                 ),
//
//                 SizedBox(height: ASizes.spaceBtwInputFields),
//
//                 // Confirm Password Field
//                 TextInputWidget(
//                   headerText: AText.cPass,
//                   hintText: AText.cPassHint,
//                   dark: isDark,
//                   isPassword: true,
//                   controller: _confirmPasswordController,
//                   validator: _validateConfirmPassword,
//                   suffixIcon: Icon(
//                     showConfirmPassword
//                         ? CupertinoIcons.eye_slash
//                         : CupertinoIcons.eye,
//                   ),
//                   onSuffixIconPressed: () {
//                     setState(() {
//                       showConfirmPassword = !showConfirmPassword;
//                     });
//                   },
//                 ),
//
//                 SizedBox(height: ASizes.spaceBtwInputFields + 20),
//
//                 AButton(
//                   text: AText.signUp,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400,
//                   textColor: Colors.white,
//                   onPressed: _handleSignup,
//                 ),
//
//                 SizedBox(height: ASizes.spaceBtwInputFields + 30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       AText.haveAccount,
//                       style: AappTextStyle.roboto(
//                         color: Colors.grey,
//                         fontSize: 16,
//                         weight: FontWeight.w400,
//                       ),
//                     ),
//                     AButton(
//                       text: AText.login,
//                       buttonType: AButtonType.text,
//                       height: 30,
//                       width: 70,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       textColor: Colors.lightBlue,
//                       onPressed: () {
//                         Navigator.pushNamed(context, RouteName.loginScreen);
//                       },
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: ASizes.spaceBtwInputFields + 20),
//
//                 AButton(
//                   text: AText.cAGuest,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400,
//                   textColor: isDark ? Colors.white : Colors.black,
//                   backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
//                   onPressed: () {
//                     // Navigator.pushNamed(context, RouteName.guestScreen);
//                   },
//                 ),
//
//                 SizedBox(height: ASizes.spaceBtwInputFields + 50),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:afronika/utils/device/device_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:afronika/common/GButton.dart';
import 'package:afronika/common/app_logo.dart';
import 'package:afronika/common/text_input_widget.dart';
import 'package:afronika/routes/routes_name.dart';
import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/constant/paddings.dart';
import 'package:afronika/utils/constant/text_strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../utils/constant/sizes.dart';
import '../provider/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validation functions
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.signUpWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
      );

      if (success) {
        _showEmailVerificationDialog();
      } else {
        _showErrorSnackbar(authProvider.errorMessage ?? 'Signup failed');
      }
    }
  }

  // void _handleGoogleSignup() async {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //
  //   final success = await authProvider.signInWithGoogle();
  //
  //   if (success) {
  //     Navigator.pushNamedAndRemoveUntil(
  //         context,
  //         RouteName.homeScreen,
  //             (route) => false
  //     );
  //   } else {
  //     _showErrorSnackbar(authProvider.errorMessage ?? 'Google signup failed');
  //   }
  // }

  void _showEmailVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Verify Your Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'A verification email has been sent to your email address. Please check your inbox and click the verification link.',
            ),
            const SizedBox(height: 16),
            const Text(
              'After verifying your email, you can sign in to your account.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.sendEmailVerification();
              _showSuccessSnackbar('Verification email sent again');
            },
            child: const Text('Resend Email'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteName.loginScreen,
                      (route) => false
              );
            },
            child: const Text('Go to Login'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);

    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 44),
                        const AppLogo(),
                        Padding(
                          padding: Paddings.textPd,
                          child: Text(
                            AText.signUp,
                            style: AappTextStyle.roboto(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 30,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // Error Message Display
                        if (authProvider.errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              border: Border.all(color: Colors.red.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    authProvider.errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => authProvider.clearError(),
                                  child: Icon(Icons.close, color: Colors.red.shade600, size: 20),
                                ),
                              ],
                            ),
                          ),

                        // Name Field
                        TextInputWidget(
                          headerText: AText.name,
                          hintText: AText.nameHint,
                          dark: isDark,
                          controller: _nameController,
                          validator: _validateName,
                        ),

                        SizedBox(height: ASizes.spaceBtwInputFields),

                        // Email Field
                        TextInputWidget(
                          headerText: AText.email,
                          hintText: AText.emailHint,
                          dark: isDark,
                          controller: _emailController,
                          validator: _validateEmail,
                        ),

                        SizedBox(height: ASizes.spaceBtwInputFields),

                        // Password Field
                        TextInputWidget(
                          headerText: AText.pas,
                          hintText: AText.passHint,
                          dark: isDark,
                          isPassword: !showPassword,
                          controller: _passwordController,
                          validator: _validatePassword,
                          suffixIcon: Icon(
                            showPassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                          ),
                          onSuffixIconPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),

                        SizedBox(height: ASizes.spaceBtwInputFields),

                        // Confirm Password Field
                        TextInputWidget(
                          headerText: AText.cPass,
                          hintText: AText.cPassHint,
                          dark: isDark,
                          isPassword: !showConfirmPassword,
                          controller: _confirmPasswordController,
                          validator: _validateConfirmPassword,
                          suffixIcon: Icon(
                            showConfirmPassword
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye,
                          ),
                          onSuffixIconPressed: () {
                            setState(() {
                              showConfirmPassword = !showConfirmPassword;
                            });
                          },
                        ),

                        SizedBox(height: ASizes.spaceBtwInputFields + 20),

                        // Sign Up Button
                        AButton(
                          text: AText.signUp,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          textColor: Colors.white,
                          onPressed: authProvider.isLoading ? null : _handleSignup,
                        ),

                        SizedBox(height: ASizes.spaceBtwInputFields + 10),

                        // Google Sign Up Button
                        // AButton(
                        //   text: "Sign up with Google",
                        //   fontSize: 16,
                        //   fontWeight: FontWeight.w400,
                        //   textColor: isDark ? Colors.white : Colors.black,
                        //   backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                        //   onPressed: authProvider.isLoading ? null : _handleGoogleSignup,
                        // ),

                        SizedBox(height: ASizes.spaceBtwInputFields + 20),

                        // Already have account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AText.haveAccount,
                              style: AappTextStyle.roboto(
                                color: Colors.grey,
                                fontSize: 16,
                                weight: FontWeight.w400,
                              ),
                            ),
                            AButton(
                              text: AText.login,
                              buttonType: AButtonType.text,
                              height: 30,
                              width: 70,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              textColor: Colors.lightBlue,
                              onPressed: () {
                                Navigator.pushNamed(context, RouteName.loginScreen);
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: ASizes.spaceBtwInputFields + 20),

                        // Continue as Guest
                        AButton(
                          text: AText.cAGuest,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          textColor: isDark ? Colors.white : Colors.black,
                          backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
                          onPressed: () {
                            // Navigator.pushNamed(context, RouteName.homeScreen);
                          },
                        ),

                        SizedBox(height: ASizes.spaceBtwInputFields + 50),
                      ],
                    ),
                  ),
                ),
              ),

              // Loading Overlay
              if (authProvider.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}