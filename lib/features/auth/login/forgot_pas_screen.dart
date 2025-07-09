import 'package:afronika/features/auth/login/widgets/svg_image.dart';
import 'package:afronika/routes/routes_name.dart';
import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/constant/image_strings.dart';
import 'package:afronika/utils/constant/paddings.dart';
import 'package:afronika/utils/constant/text_strings.dart';
import 'package:afronika/common/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:afronika/common/GButton.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasScreen extends StatefulWidget {
  const ForgotPasScreen({super.key});

  @override
  State<ForgotPasScreen> createState() => _ForgotPasScreenState();
}

class _ForgotPasScreenState extends State<ForgotPasScreen> {
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
              Navigator.pop(context); // Use pop instead of pushNamed for back navigation
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                  AText.forgotPGuide,
                  textAlign: TextAlign.center,
                  style: AappTextStyle.roboto(
                    color: isDark ? Colors.grey[400]! : Colors.grey[600]!,
                    fontSize: 16,
                    weight: FontWeight.w400,
                    height: 1.5, // Line height for better readability
                  ),
                ),

                // Spacing before email field
                SizedBox(height: 48),

                // Email input field
                TextInputWidget(
                  headerText: AText.email,
                  hintText: AText.emailHint,
                  dark: isDark,
                ),

                // Spacing before send button
                SizedBox(height: 32),

                // Send reset link button
                AButton(
                  text: AText.sendRLink,
                  fontWeight: FontWeight.w400,
                  textColor: Colors.white,
                  onPressed: () {
                    // Add your send reset link logic here
                    // Navigator.pushNamed(context, RouteName.sendResetLink);
                  },
                ),

                // Spacing before back to login
                SizedBox(height: 24),

                // Back to login section
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Use pop to go back
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}