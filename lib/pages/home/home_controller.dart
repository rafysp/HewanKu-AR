import 'package:flutter_application_2/pages/animals/animal_page.dart';
import 'package:flutter_application_2/pages/camera/camera_page.dart';
import 'package:flutter_application_2/pages/quiz/quiz_page.dart';
import 'package:flutter_application_2/pages/quiz/quiz_controller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  
  void onCategoryTap(int index) {
    // Navigasi ke quiz berdasarkan kategori yang dipilih
    // 0: Tebak Gambar
    // 1: Kategori Hewan
    // 2: Habitat Hewan  
    // 3: Puzzle Hewan
    
    QuizType quizType;
    
    switch(index) {
      case 0:
        quizType = QuizType.tebakGambar;
        break;
      case 1:
        quizType = QuizType.kategoriHewan;
        break;
      case 2:
        quizType = QuizType.habitatHewan;
        break;
      case 3:
        quizType = QuizType.puzzleHewan;
        break;
      default:
        quizType = QuizType.tebakGambar;
    }
    
    Get.to(() => QuizPage(quizType: quizType));
  }

  void onFeaturedImageTap() {
    // Handle featured image tap - navigasi ke halaman hewan
    Get.to(() => AnimalPage());
  }

  void onBannerTap() {
    // Handle banner tap
    Get.snackbar(
      'Banner',
      'You tapped on the banner image',
      snackPosition: SnackPosition.BOTTOM,
    );

    // Add navigation logic here
    // Get.to(() => BannerDetailsPage());
  }
}