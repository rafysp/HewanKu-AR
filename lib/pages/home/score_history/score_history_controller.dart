// pages/score_history/score_history_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_2/pages/score_tracking/score_controller.dart';
import 'package:flutter_application_2/pages/score_tracking/score_model.dart';

class ScoreHistoryController extends GetxController {
  // Instance of ScoreController
  late ScoreController scoreController;
  
  // Reactive variables
  final RxList<ScoreModel> _scores = <ScoreModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  
  // Getters
  List<ScoreModel> get scores => _scores.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get hasScores => _scores.isNotEmpty;
  
  @override
  void onInit() {
    super.onInit();
    print('ScoreHistoryController initialized');
    _initializeScoreController();
    _loadScores();
  }
  
  @override
  void onReady() {
    super.onReady();
    // Refresh scores when page is ready
    refreshScores();
  }
  
  void _initializeScoreController() {
    try {
      scoreController = Get.find<ScoreController>();
      print('ScoreController found successfully');
    } catch (e) {
      print('Error finding ScoreController: $e');
      // Create new instance if not found
      scoreController = Get.put(ScoreController());
      print('New ScoreController created');
    }
  }
  
  Future<void> _loadScores() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      print('Loading scores from ScoreController...');
      
      // Load scores from ScoreController
      await scoreController.loadScores();
      
      // Update local scores
      _scores.value = List.from(scoreController.scores);
      
      print('Loaded ${_scores.length} scores');
      
      // Debug: Print each score
      for (int i = 0; i < _scores.length; i++) {
        final score = _scores[i];
        print('Score $i: ${score.category} - ${score.score.toStringAsFixed(0)}/100');
      }
      
    } catch (e) {
      print('Error loading scores: $e');
      _errorMessage.value = 'Gagal memuat riwayat score';
    } finally {
      _isLoading.value = false;
    }
  }
  
  Future<void> refreshScores() async {
    print('Refreshing scores...');
    await _loadScores();
  }
  
  Future<void> deleteAllScores() async {
    try {
      _isLoading.value = true;
      
      print('Deleting all scores...');
      
      // Delete from ScoreController
      await scoreController.deleteAllScores();
      
      // Clear local scores
      _scores.clear();
      
      print('All scores deleted successfully');
      
    } catch (e) {
      print('Error deleting scores: $e');
      _errorMessage.value = 'Gagal menghapus riwayat score';
    } finally {
      _isLoading.value = false;
    }
  }
  
  // Get statistics
  Map<String, dynamic> getStatistics() {
    if (_scores.isEmpty) return {};
    
    double avgScore = _scores.map((s) => s.score).reduce((a, b) => a + b) / _scores.length;
    double maxScore = _scores.map((s) => s.score).reduce((a, b) => a > b ? a : b);
    int totalQuizzes = _scores.length;
    
    return {
      'average': avgScore,
      'highest': maxScore,
      'total_quizzes': totalQuizzes,
    };
  }
  
  // Filter scores by category
  List<ScoreModel> getScoresByCategory(String category) {
    return _scores.where((score) => score.category == category).toList();
  }
  
  // Get recent scores (last 10)
  List<ScoreModel> getRecentScores() {
    return _scores.take(10).toList();
  }
  
  // Get best scores
  List<ScoreModel> getBestScores() {
    List<ScoreModel> sortedScores = List.from(_scores);
    sortedScores.sort((a, b) => b.score.compareTo(a.score));
    return sortedScores.take(5).toList();
  }
  
  // Navigation methods
  void navigateToHome() {
    Get.back();
  }
  
  void navigateToCamera() {
    // Add camera navigation logic
    print('Navigate to camera');
  }
  
  void navigateToAnimals() {
    // Add animals navigation logic
    print('Navigate to animals');
  }
  
  // Show delete confirmation dialog
  void showDeleteConfirmation() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 60,
                color: Colors.orange[600],
              ),
              SizedBox(height: 16),
              Text(
                'Hapus Semua Riwayat?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Aksi ini tidak dapat dibatalkan. Semua riwayat score akan terhapus.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        deleteAllScores();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Hapus',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}