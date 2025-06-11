import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/home/home_page.dart';
import 'package:get/get.dart';
import 'constants/color_constant.dart';
import 'pages/onboarding/onboarding_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,

        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: ColorPrimary.primary500,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
