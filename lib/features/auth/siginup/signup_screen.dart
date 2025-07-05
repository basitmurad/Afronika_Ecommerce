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

import '../../../utils/constant/sizes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = ADeviceUtils.isDarkMode(context);
    bool showPassword = false;
    bool showConfirmPassword = false;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: 44,),

              AppLogo(),
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


              TextInputWidget(
                headerText: AText.name,
                hintText: AText.nameHint,
                dark: isDark,
              ),

              SizedBox(height: ASizes.spaceBtwInputFields),

              TextInputWidget(
                headerText: AText.email,
                hintText: AText.emailHint,
                dark: isDark,
              ),

              SizedBox(height: ASizes.spaceBtwInputFields),

              TextInputWidget(
                headerText: AText.pas,
                hintText: AText.passHint,
                dark: isDark,
                isPassword: true,
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

              TextInputWidget(
                headerText: AText.cPass,
                hintText: AText.cPassHint,
                dark: isDark,
                isPassword: true,
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

              AButton(
                text: AText.signUp,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                textColor: Colors.white,
                onPressed: () {
                  // Navigator.pushNamed(context, RouteName.accountSignup);
                },
              ),

              SizedBox(height: ASizes.spaceBtwInputFields + 30),
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

              SizedBox(height: ASizes.spaceBtwInputFields+20),

              AButton(
                text: AText.cAGuest,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                textColor: isDark ? Colors.white : Colors.black,
                backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
                onPressed: () {
                  // Navigator.pushNamed(context, RouteName.guestScreen);
                },
              ),

              SizedBox(height: ASizes.spaceBtwInputFields+50),

            ],
          ),
        ),
      ),
    );
  }
}
