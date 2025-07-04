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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteName.loginScreen);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          // IconButton(Icons.arrow_back_ios,color: Colors.white,),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 90),
                child: CircleAvatar(
                  radius: 77,
                  child: SvgImage(
                    height: 74.52,
                    width: 54.65,
                    imagePath: GImagePath.lockVector,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                AText.forgotP,
                style: AappTextStyle.roboto(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 36,
                  weight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: Paddings.textPd,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: Text(
                  AText.forgotPGuide,
                  textAlign: TextAlign.center,
                  style: AappTextStyle.roboto(
                    color: Colors.grey,
                    fontSize: 18,
                    weight: FontWeight.w400,
                  ),
                ),
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
              child: AButton(
                text: AText.sendRLink,
                height: 60,
                fontWeight: FontWeight.w400,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.sendResetLink);
                },
              ),
            ),
            Padding(
              padding: Paddings.textPd,
              child: AButton(
                height: 30,
                text: AText.backToLogin,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                buttonType: AButtonType.text,
                textColor: Colors.lightBlue,
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.loginScreen);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
