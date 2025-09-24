import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meeting_app/core/constant/color_constant.dart';
import 'package:meeting_app/core/constant/image_constant.dart';
import 'package:meeting_app/core/constant/string_constant.dart';
import 'package:meeting_app/core/helper/navigation_helper.dart';
import 'package:meeting_app/feature/auth/presentation/pages/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToScreen();
  }

  void _navigateToScreen() async {
    await Future.delayed(Duration(seconds: 2));
    NavigationHelper.pushRemoveUntil(context, Login());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.redColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 30,
            children: [
              Image.asset(ImageConstant.ballon1Img),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.center,
                child: Text(
                  StringConstant.splashName.toUpperCase(),
                  style: TextStyle(
                    fontFamily: GoogleFonts.novaScript().fontFamily,
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerRight,
                child: Image.asset(ImageConstant.ballon2Img),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
