import 'package:flutter/material.dart';
import 'package:meeting_app/core/constant/string_constant.dart';
import 'package:meeting_app/feature/splash/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: StringConstant.appFontFamily,
      ),
      home: const Splash(),
    );
  }
}
