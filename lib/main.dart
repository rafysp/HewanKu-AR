import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/home/home_page.dart';
import 'package:flutter_application_2/pages/score_tracking/score_controller.dart';
import 'package:get/get.dart';
import 'constants/color_constant.dart';

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
      
      // Inisialisasi controller global di sini
      initialBinding: BindingsBuilder(() {
        // Put ScoreController sebagai dependency global
        Get.put(ScoreController(), permanent: true);
        print('ScoreController initialized globally');
      }),
      
      home: const HomePage(),
    );
  }
}