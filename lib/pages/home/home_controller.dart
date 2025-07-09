// pages/home/home_controller.dart - Updated with Score History Navigation
import 'package:flutter_application_2/pages/animals/animal_page.dart';
import 'package:flutter_application_2/pages/camera/camera_page.dart';
import 'package:flutter_application_2/pages/home/score_history/score_history_page.dart';
import 'package:flutter_application_2/pages/quiz/habitat/habitat_drag_quiz.dart';
import 'package:flutter_application_2/pages/quiz/puzzle/puzzle_game_page.dart';
import 'package:flutter_application_2/pages/quiz/quiz_page.dart';
import 'package:flutter_application_2/pages/quiz/quiz_controller.dart';
import 'package:flutter_application_2/pages/score_tracking/score_controller.dart'; // TAMBAHAN: Import score controller

import 'package:get/get.dart';

class HomeController extends GetxController {
  
  // ============ TAMBAHAN: Inisialisasi Score Controller ============
  @override
  void onInit() {
    super.onInit();
    // Pastikan ScoreController sudah diinisialisasi
    if (!Get.isRegistered<ScoreController>()) {
      Get.put(ScoreController());
    }
  }
  
  void onCategoryTap(int index) {
    // Navigasi ke quiz berdasarkan kategori yang dipilih
    // 0: Tebak Gambar
    // 1: Kategori Hewan
    // 2: Habitat Hewan  
    // 3: Puzzle Hewan
    
    switch(index) {
      case 0:
        // Tebak Gambar Quiz
        Get.to(() => QuizPage(quizType: QuizType.tebakGambar));
        break;
        
      case 1:
        // Kategori Hewan Quiz
        Get.to(() => QuizPage(quizType: QuizType.kategoriHewan));
        break;
        
      case 2:
        // Habitat Hewan - Drag and Drop Quiz
        Get.to(() => HabitatDragQuizPage());
        break;
        
      case 3:
        // Puzzle Hewan - New 2x2 Accessible Puzzle Game
        Get.to(() => SimplePuzzlePage());
        break;
        
      default:
        // Default ke Tebak Gambar
        Get.to(() => QuizPage(quizType: QuizType.tebakGambar));
        break;
    }
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

  // ============ TAMBAHAN: Navigation ke Score History ============
  void navigateToScoreHistory() {
    Get.to(() => ScoreHistoryPage());
  }

  // Helper method untuk debugging kategori
  String getCategoryName(int index) {
    switch(index) {
      case 0: return 'Tebak Gambar';
      case 1: return 'Kategori Hewan';
      case 2: return 'Habitat Hewan';
      case 3: return 'Puzzle Hewan';
      default: return 'Unknown';
    }
  }

  // Method untuk navigation langsung ke specific games (jika diperlukan)
  void navigateToTebakGambar() {
    Get.to(() => QuizPage(quizType: QuizType.tebakGambar));
  }

  void navigateToKategoriHewan() {
    Get.to(() => QuizPage(quizType: QuizType.kategoriHewan));
  }

  void navigateToHabitatQuiz() {
    Get.to(() => HabitatDragQuizPage());
  }

  void navigateToPuzzleGame() {
    Get.to(() => SimplePuzzlePage());
  }

  void navigateToAnimalPage() {
    Get.to(() => AnimalPage());
  }

  void navigateToCameraPage() { 
    Get.to(() => KidFriendlyCameraPage());
  }
}