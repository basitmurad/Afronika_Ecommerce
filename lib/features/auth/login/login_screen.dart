import 'package:afronika/common/GButton.dart';
import 'package:afronika/common/app_logo.dart';
import 'package:afronika/common/text_input_widget.dart';
import 'package:afronika/features/auth/login/widgets/p_divider.dart';
import 'package:afronika/routes/routes_name.dart';
import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/constant/image_strings.dart';
import 'package:afronika/utils/constant/paddings.dart';
import 'package:afronika/utils/constant/sizes.dart';
import 'package:afronika/utils/constant/text_strings.dart';
import 'package:afronika/utils/device/device_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Clear any previous errors
      authProvider.clearError();

      bool success = await authProvider.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (success && mounted) {
        // Check the user's verification status
        if (authProvider.user!.emailVerified) {
          // Email is verified, go to main app
          Navigator.pushReplacementNamed(context, RouteName.navigationMenu);
        } else {
          // Email not verified, go to verification screen
          Navigator.pushReplacementNamed(context, RouteName.emailVerificationScreen1);
        }
      }
      // If login failed, error message will be shown via Consumer
    }
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
    final bool isDark = ADeviceUtils.isDarkMode(context);

    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Show error message if there's an error
          if (authProvider.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showErrorSnackBar(authProvider.errorMessage!);
              authProvider.clearError();
            });
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 44),
                    const AppLogo(),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 10),
                      child: Text(
                        AText.welcome,
                        style: AappTextStyle.roboto(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 30,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Text(
                      AText.loginGuide,
                      style: AappTextStyle.roboto(
                        color: Colors.grey,
                        fontSize: 18,
                        weight: FontWeight.w200,
                      ),
                    ),
                    SizedBox(height: ASizes.spaceBtwInputFields),

                    // Email Input
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
                    SizedBox(height: ASizes.spaceBtwInputFields),

                    // Password Input
                    TextInputWidget(
                      controller: _passwordController,
                      headerText: AText.pas,
                      hintText: AText.passHint,
                      dark: isDark,
                      isPassword: true,
                      suffixIcon: Icon(
                        _showPassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                      ),
                      onSuffixIconPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    Container(
                      alignment: Alignment.bottomCenter,
                      child: AButton(
                        height: 30,
                        text: AText.forgotP,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        buttonType: AButtonType.text,
                        textColor: Colors.lightBlue,
                        onPressed: () {
                          Navigator.pushNamed(context, RouteName.forgotPasScreen);
                        },
                      ),
                    ),

                    SizedBox(height: ASizes.spaceBtwInputFields + 16),

                    // Login Button with Loading State
                    AButton(
                      text:authProvider.isLoading ? 'Logging in...' : AText.login,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      textColor: Colors.white,
                      onPressed: authProvider.isLoading ? null : _handleLogin,
                    ),
                    SizedBox(height: ASizes.spaceBtwInputFields),

                    Pdivider(title: AText.oContW),
                    SizedBox(height: ASizes.spaceBtwInputFields),

                    // Google Sign In Button
                    AButton(
                      text: AText.cWGoogle,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      prefixImagePath: GImagePath.googleImage,
                      buttonType: AButtonType.outlined,
                      backgroundColor: Colors.grey,
                      textColor: isDark ? Colors.white : Colors.black,
                      onPressed: authProvider.isLoading
                          ? null
                          : () {
                        // TODO: Implement Google Sign In
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Google Sign In coming soon!'),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: ASizes.spaceBtwInputFields),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AText.noAccount,
                          style: AappTextStyle.roboto(
                            color: Colors.grey,
                            fontSize: 16,
                            weight: FontWeight.w400,
                          ),
                        ),
                        AButton(
                          text: AText.signUp,
                          buttonType: AButtonType.text,
                          height: 30,
                          width: 70,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          textColor: Colors.lightBlue,
                          onPressed: () {
                            Navigator.pushNamed(context, RouteName.signUpScreen);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: ASizes.spaceBtwInputFields),

                    AButton(
                      text: AText.cAGuest,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      textColor: isDark ? Colors.white : Colors.black,
                      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
                      onPressed: authProvider.isLoading
                          ? null
                          : () {
                        // TODO: Implement guest access
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Guest access coming soon!'),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: ASizes.spaceBtwInputFields),
                    SizedBox(height: ASizes.spaceBtwInputFields),
                    SizedBox(height: ASizes.spaceBtwInputFields),
                    SizedBox(height: ASizes.spaceBtwInputFields),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}