import 'package:ccosvg/widgets/my_home_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAnalytics.instance.logAppOpen();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Color palette generated by:
  // http://mcg.mbitson.com/#!?mcgpalette0=%23555555
  static const MaterialColor mcgpalette0 = MaterialColor(_mcgpalette0PrimaryValue, <int, Color>{
    50: Color(0xFFEBEBEB),
    100: Color(0xFFCCCCCC),
    200: Color(0xFFAAAAAA),
    300: Color(0xFF888888),
    400: Color(0xFF6F6F6F),
    500: Color(_mcgpalette0PrimaryValue),
    600: Color(0xFF4E4E4E),
    700: Color(0xFF444444),
    800: Color(0xFF3B3B3B),
    900: Color(0xFF2A2A2A),
  });
  static const int _mcgpalette0PrimaryValue = 0xFF555555;
  static const MaterialColor mcgpalette0Accent = MaterialColor(_mcgpalette0AccentValue, <int, Color>{
    100: Color(0xFFF28989),
    200: Color(_mcgpalette0AccentValue),
    400: Color(0xFFFF1616),
    700: Color(0xFFFC0000),
  });
  static const int _mcgpalette0AccentValue = 0xFFED5B5B;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CCoSVG',
      theme: ThemeData(
        primarySwatch: mcgpalette0,
      ),
      home: const MyHomePage(),
    );
  }
}
