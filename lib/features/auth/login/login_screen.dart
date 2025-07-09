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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isDark =ADeviceUtils.isDarkMode(context);
    bool showPassword = false;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: 44,),
              AppLogo(),
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
              SizedBox(height: ASizes.spaceBtwInputFields,),

              TextInputWidget(
                headerText: AText.email,
                hintText: AText.emailHint,
                dark: isDark ? true : false,
              ),
              SizedBox(height: ASizes.spaceBtwInputFields,),

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

              SizedBox(height: ASizes.spaceBtwInputFields+16,),

              AButton(
                text: AText.login,
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.navigationMenu);
                },
              ),
              SizedBox(height: ASizes.spaceBtwInputFields,),



              Pdivider(title: AText.oContW),
              SizedBox(height: ASizes.spaceBtwInputFields,),

              AButton(
                text: AText.cWGoogle,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                prefixImagePath: GImagePath.googleImage,
                buttonType: AButtonType.outlined,
                backgroundColor: Colors.grey,
                textColor: isDark ? Colors.white : Colors.black,
                onPressed: () {
                },
              ),
              SizedBox(height: ASizes.spaceBtwInputFields,),

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
              SizedBox(height: ASizes.spaceBtwInputFields,),

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
              SizedBox(height: ASizes.spaceBtwInputFields,),
              SizedBox(height: ASizes.spaceBtwInputFields,),
              SizedBox(height: ASizes.spaceBtwInputFields,),
              SizedBox(height: ASizes.spaceBtwInputFields,),

            ],
          ),
        ),
      ),
    );
  }
}