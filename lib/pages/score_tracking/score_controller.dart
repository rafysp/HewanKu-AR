import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'score_model.dart';
import 'score_services.dart';

class ScoreController extends GetxController {
  final ScoreService _scoreService = ScoreService();
  
  final _scores = <ScoreModel>[].obs;
  final _playerName = 'Player'.obs;
  final _isLoading = false.obs;
  
  List<ScoreModel> get scores => _scores.value;
  String get playerName => _playerName.value;
  bool get isLoading => _isLoading.value;
  
  // Expose service for direct access if needed
  ScoreService get scoreService => _scoreService;

  @override
  void onInit() {
    super.onInit();
    print('ScoreController initialized');
    _initializeData();
  }
  
  Future<void> _initializeData() async {
    _isLoading.value = true;
    await loadScores();
    await loadPlayerName();
    _isLoading.value = false;
  }

  Future<void> loadScores() async {
    try {
      print('ScoreController: Loading scores from service...');
      final loadedScores = await _scoreService.getAllScores();
      _scores.value = loadedScores;
      print('ScoreController: Loaded ${_scores.length} scores');
      
      // Debug: Print loaded scores
      for (int i = 0; i < _scores.length; i++) {
        final score = _scores[i];
        print('ScoreController - Score $i: ${score.category} - ${score.score.toStringAsFixed(0)}/100');
      }
      
    } catch (e) {
      print('ScoreController: Error loading scores: $e');
    }
  }

  Future<void> loadPlayerName() async {
    try {
      _playerName.value = await _scoreService.getPlayerName();
      print('ScoreController: Player name loaded: ${_playerName.value}');
    } catch (e) {
      print('ScoreController: Error loading player name: $e');
    }
  }

  Future<void> savePlayerName(String name) async {
    try {
      await _scoreService.savePlayerName(name);
      _playerName.value = name;
      print('ScoreController: Player name saved: $name');
    } catch (e) {
      print('ScoreController: Error saving player name: $e');
    }
  }

  Future<void> saveScore({
    required int correctAnswers,
    required int totalQuestions,
    required String category,
    required String quizType,
    required int duration,
  }) async {
    try {
      final newScore = ScoreModel(
        playerName: _playerName.value,
        correctAnswers: correctAnswers,
        totalQuestions: totalQuestions,
        dateTime: DateTime.now(),
        category: category,
        duration: duration,
        quizType: quizType,
      );

      print('ScoreController: Saving new score - ${newScore.category}: ${newScore.score.toStringAsFixed(0)}/100');
      
      await _scoreService.saveScore(newScore);
      
      // Reload scores to get updated list
      await loadScores();
      
      Get.snackbar(
        'Score Disimpan! ✅',
        'Nilai: ${newScore.score.toStringAsFixed(0)}/100 (${newScore.predicate}) - Grade ${newScore.grade}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      
      print('ScoreController: Score saved successfully. Total scores: ${_scores.length}');
      
    } catch (e) {
      print('ScoreController: Error saving score: $e');
      Get.snackbar(
        'Error',
        'Gagal menyimpan score',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteAllScores() async {
    try {
      print('ScoreController: Deleting all scores...');
      await _scoreService.deleteAllScores();
      _scores.clear();
      
      Get.snackbar(
        'Berhasil', 
        'Semua score telah dihapus',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      
      print('ScoreController: All scores deleted successfully');
    } catch (e) {
      print('ScoreController: Error deleting scores: $e');
      Get.snackbar(
        'Error', 
        'Gagal menghapus score',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Force refresh scores (useful for external calls)
  Future<void> forceRefresh() async {
    print('ScoreController: Force refreshing scores...');
    await loadScores();
  }

  // Get statistics
  Map<String, dynamic> getStatistics() {
    if (scores.isEmpty) return {};
    
    double avgScore = scores.map((s) => s.score).reduce((a, b) => a + b) / scores.length;
    double maxScore = scores.map((s) => s.score).reduce((a, b) => a > b ? a : b);
    int totalQuizzes = scores.length;
    
    return {
      'average': avgScore,
      'highest': maxScore,
      'total_quizzes': totalQuizzes,
    };
  }
  
  @override
  void onClose() {
    super.onClose();
    print('ScoreController disposed');
  }
}