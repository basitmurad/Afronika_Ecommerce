import 'package:afronika/common/GButton.dart';
import 'package:afronika/common/app_logo.dart';
import 'package:afronika/common/text_input_widget.dart';
import 'package:afronika/features/auth/login/widgets/pDivider.dart';
import 'package:afronika/routes/routes_name.dart';
import 'package:afronika/utils/constant/app_test_style.dart';
import 'package:afronika/utils/constant/image_strings.dart';
import 'package:afronika/utils/constant/paddings.dart';
import 'package:afronika/utils/constant/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppLogo(),
            Text(
              AText.welcome,
              style: GoogleFonts.outfit(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w500,
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
              child: AButton(
                text: AText.login,
                height: 60,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.accountLogin);
                },
              ),
            ),
            Padding(
              padding: Paddings.textPd,
              child: AButton(
                height: 30,
                text: AText.forgotP,
                buttonType: AButtonType.text,
                textColor: Colors.lightBlue,
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.forgotPScreen);
                },
              ),
            ),
            Pdivider(title: AText.oContW),
            Padding(
              padding: Paddings.sidePd,
              child: AButton(
                text: AText.cWGoogle,
                prefixImagePath: GImagePath.googleImage,
                height: 60,
                buttonType: AButtonType.outlined,
                backgroundColor: Colors.grey,
                textColor: isDark ? Colors.white : Colors.black,
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.contWG);
                },
              ),
            ),
            Padding(
              padding: Paddings.textPd,
              child: Row(
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
                    textColor: Colors.lightBlue,
                    onPressed: () {
                      Navigator.pushNamed(context, RouteName.signUpScreen);
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
