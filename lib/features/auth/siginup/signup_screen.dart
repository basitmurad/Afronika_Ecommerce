import 'package:flutter/material.dart';
import 'package:afronika/common/GButton.dart';
import 'package:afronika/common/app_logo.dart';
import 'package:afronika/common/text_input_widget.dart';
import 'package:afronika/routes/routes_name.dart';
import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/constant/paddings.dart';
import 'package:afronika/utils/constant/text_strings.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            Padding(
              padding: Paddings.sidePd,
              child: TextInputWidget(
                headerText: AText.name,
                hintText: AText.nameHint,
                dark: isDark ? true : false,
              ),
            ),
            Padding(
              padding: Paddings.sidePd,
              child: TextInputWidget(
                headerText: AText.email,
                hintText: AText.emailHint,
                dark: isDark ? true : false,
              ),
            ),
            Padding(
              padding: Paddings.sidePd,
              child: TextInputWidget(
                headerText: AText.pas,
                hintText: AText.passHint,
                dark: isDark ? true : false,
              ),
            ),
            Padding(
              padding: Paddings.sidePd,
              child: TextInputWidget(
                headerText: AText.cPass,
                hintText: AText.cPassHint,
                dark: isDark ? true : false,
              ),
            ),
            Padding(
              padding: Paddings.sidePd,
              child: AButton(
                text: AText.signUp,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 60,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.accountSignup);
                },
              ),
            ),

            Padding(
              padding: Paddings.textPd,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AText.haveAccount,
                    style: AappTextStyle.roboto(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 16,
                      weight: FontWeight.w400,
                    ),
                  ),
                  AButton(
                    text: AText.login,
                    buttonType: AButtonType.text,
                    height: 30,
                    width: 50,
                    textColor: Colors.lightBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    onPressed: () {
                      Navigator.pushNamed(context, RouteName.loginScreen);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: Paddings.sidePd,
              child: AButton(
                text: AText.cAGuest,
                height: 60,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                textColor: isDark ? Colors.white : Colors.black,
                backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.guestScreen);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
