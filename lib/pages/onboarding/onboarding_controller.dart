import 'package:flutter_application_2/pages/home/home_page.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  void onStartLearning() {
    // Navigate to HomePage when button is pressed
    Get.to(() => const HomePage());
  }
}