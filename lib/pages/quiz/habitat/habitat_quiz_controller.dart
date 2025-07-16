import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/quiz/habitat/model/animalmodel.dart';
import 'package:flutter_application_2/pages/quiz/habitat/model/habitatmodel.dart';
import 'package:flutter_application_2/pages/score_tracking/score_controller.dart';
import 'package:get/get.dart';

class DragAndDropQuizController extends GetxController {
  final RxList<HabitatModel> habitats = <HabitatModel>[].obs;
  final RxList<AnimalModel> _allAnimals = <AnimalModel>[].obs;
  final RxList<AnimalModel> animals = <AnimalModel>[].obs;
  final RxMap<String, String> animalToHabitatMap = <String, String>{}.obs;
  final RxInt score = 0.obs;
  final RxBool isQuizCompleted = false.obs;

  // Additional properties for single animal quiz mode
  final RxInt currentQuestionIndex = 0.obs;
  final RxString currentAnimalHabitat = ''.obs;
  final RxBool isAnswered = false.obs;

  // Score tracking variables
  final RxInt correctAnswers = 0.obs;
  final RxInt totalQuestions = 0.obs;
  final RxInt startTime = 0.obs;

  // Hint system
  final RxInt currentHintLevel = 0.obs;
  final RxBool showHint = false.obs;

  // Get ScoreController instance
  late ScoreController scoreController;

  // Quiz configuration
  static const int totalQuestionsToShow = 5;
  static const int totalAvailableAnimals = 15;

  // Current question getter for compatibility
  AnimalModel? get currentQuestion =>
      currentQuestionIndex.value < animals.length
          ? animals[currentQuestionIndex.value]
          : null;

  // Questions getter for compatibility
  List<AnimalModel> get questions => animals;

  @override
  void onInit() {
    super.onInit();

    // Initialize ScoreController
    try {
      scoreController = Get.find<ScoreController>();
    } catch (e) {
      scoreController = Get.put(ScoreController());
    }

    // Initialize quiz session
    _initializeQuizSession();

    // Load menggunakan factory methods dari model baru
    loadHabitats();
    loadAllAnimals();
    shuffleAndSelectAnimals();
  }

  void _initializeQuizSession() {
    // Record start time
    startTime.value = DateTime.now().millisecondsSinceEpoch;

    // Set total questions
    totalQuestions.value = totalQuestionsToShow;
    correctAnswers.value = 0;
    score.value = 0;
    isQuizCompleted.value = false;

    print(
      '🎯 Habitat quiz session initialized: ${totalQuestions.value} questions',
    );
  }

  // MENGGUNAKAN FACTORY METHOD DARI HABITATMODEL
  void loadHabitats() {
    // Gunakan factory method untuk 3 habitat sederhana
    habitats.assignAll(HabitatModel.createSimpleHabitats());

    // Validate semua habitat
    for (var habitat in habitats) {
      if (!habitat.isValidHabitat()) {
        print('⚠️ Invalid habitat: ${habitat.name}');
      } else {
        print('✅ Habitat loaded: ${habitat.name} ${habitat.emoji}');
      }
    }
  }

  // MENGGUNAKAN FACTORY METHOD DARI ANIMALMODEL
  void loadAllAnimals() {
    // Gunakan factory method untuk create default animals
    _allAnimals.assignAll(AnimalModel.createDefaultAnimals());

    // Validate semua hewan
    for (var animal in _allAnimals) {
      if (!animal.isValidAnimal()) {
        print('⚠️ Invalid animal: ${animal.name}');
      }
    }

    // Print statistics menggunakan method dari model
    printAnimalStatistics();
  }

  void printAnimalStatistics() {
    print('\n=== STATISTIK HEWAN DENGAN MODEL BARU ===');

    // Distribusi per habitat
    for (var habitat in habitats) {
      var animalsInHabitat = AnimalModel.getAnimalsByHabitat(habitat.name);
      print(
        '${habitat.emoji} ${habitat.name}: ${animalsInHabitat.length} hewan',
      );
      for (var animal in animalsInHabitat) {
        print('  - ${animal.name} (Level ${animal.getDifficultyLevel()})');
      }
    }

    // Distribusi per difficulty
    print('\n=== DISTRIBUSI DIFFICULTY ===');
    for (int i = 1; i <= 4; i++) {
      var animalsAtLevel = AnimalModel.getAnimalsByDifficulty(i);
      print('Level $i: ${animalsAtLevel.length} hewan');
    }

    // Special needs suitability
    var specialNeedsAnimals = AnimalModel.getAnimalsForSpecialNeeds();
    print('\n=== COCOK UNTUK ANAK BERKEBUTUHAN KHUSUS ===');
    print('${specialNeedsAnimals.length} dari ${_allAnimals.length} hewan');

    // Accessibility scores
    print('\n=== ACCESSIBILITY SCORES ===');
    var scores = _allAnimals.map((a) => a.getAccessibilityScore()).toList();
    var avgScore = scores.reduce((a, b) => a + b) / scores.length;
    print('Rata-rata accessibility score: ${avgScore.toStringAsFixed(1)}/5');
  }

  void shuffleAndSelectAnimals() {
    // Untuk anak berkebutuhan khusus, prioritaskan hewan yang suitable
    List<AnimalModel> suitableAnimals = AnimalModel.getAnimalsForSpecialNeeds();

    // Jika hewan suitable tidak cukup, tambahkan dari yang lain
    if (suitableAnimals.length < totalQuestionsToShow) {
      var remaining =
          _allAnimals.where((a) => !suitableAnimals.contains(a)).toList();
      remaining.shuffle();
      suitableAnimals.addAll(
        remaining.take(totalQuestionsToShow - suitableAnimals.length),
      );
    }

    // Shuffle dan ambil sesuai jumlah soal
    suitableAnimals.shuffle();
    animals.assignAll(suitableAnimals.take(totalQuestionsToShow).toList());

    print(
      '🎲 Quiz dimulai dengan ${animals.length} soal dari ${_allAnimals.length} hewan tersedia',
    );
    print('📝 Hewan yang terpilih: ${animals.map((a) => a.name).join(', ')}');

    // Print details setiap hewan terpilih
    for (var animal in animals) {
      print(
        '  - ${animal.name}: ${animal.habitatId} (Difficulty: ${animal.getDifficultyLevel()})',
      );
    }
  }

  // SISTEM HINT MENGGUNAKAN METHOD DARI ANIMALMODEL
  String getCurrentHint() {
    if (currentQuestion == null) return '';

    // Gunakan method getHintByLevel dari AnimalModel
    return currentQuestion!.getHintByLevel(currentHintLevel.value);
  }

  void showNextHint() {
    if (currentHintLevel.value < 3) {
      currentHintLevel.value++;
      showHint.value = true;

      // Auto hide hint after 5 seconds
      Future.delayed(Duration(seconds: 5), () {
        showHint.value = false;
      });
    }
  }

  void resetHintSystem() {
    currentHintLevel.value = 0;
    showHint.value = false;
  }

  // MENGGUNAKAN HABITAT SIMPLE RULE DARI MODEL
  String getHabitatRule(String habitatId) {
    HabitatModel? habitat = habitats.firstWhere(
      (h) => h.name == habitatId,
      orElse: () => habitats.first,
    );

    return habitat.simpleRule ?? 'Aturan tidak tersedia';
  }

  // Method to restart quiz with new random selection
  void startNewRandomQuiz() {
    _initializeQuizSession();
    shuffleAndSelectAnimals();
    resetQuiz();
  }

  // Method for compatibility with HabitatDragQuizPage
  String getQuizTitle() {
    return 'Kuis Habitat Hewan';
  }

  // Method to handle drag and drop for single animal mode
  void onDragAnimalToHabitat(String habitatName) {
    if (isAnswered.value || currentQuestion == null) return;

    currentAnimalHabitat.value = habitatName;
    isAnswered.value = true;

    // Check if answer is correct
    bool isCorrect = currentQuestion!.habitatId == habitatName;
    if (isCorrect) {
      score.value++;
      correctAnswers.value++;
    }

    print(
      '🎯 Answer: ${isCorrect ? "Correct" : "Incorrect"} - Score: ${correctAnswers.value}/${totalQuestions.value}',
    );

    // Wait for dragging animation
    Future.delayed(Duration(milliseconds: 500), () {
      _showHabitatFeedback(habitatName, isCorrect);
    });

    update(['quiz_body']);
  }

  void _showHabitatFeedback(String selectedHabitat, bool isCorrect) {
    if (currentQuestion == null) return;

    String animalName = currentQuestion!.name;
    String correctHabitat = currentQuestion!.habitatId;

    String message =
        isCorrect
            ? "🎉 Pintar sekali! $animalName memang suka tinggal di $correctHabitat. Kamu hebat!"
            : "🤔 Hmm, belum tepat nih. Ternyata $animalName lebih suka tinggal di $correctHabitat, bukan di $selectedHabitat. Ayo coba lagi!";

    // Gunakan method dari HabitatModel untuk mendapatkan habitat
    HabitatModel? correctHabitatModel = habitats.firstWhere(
      (h) => h.name == correctHabitat,
      orElse: () => habitats.first,
    );

    String description =
        correctHabitatModel.description ?? 'Deskripsi tidak tersedia';
    String rule = correctHabitatModel.simpleRule ?? 'Aturan tidak tersedia';

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color:
                isCorrect
                    ? Color.fromRGBO(232, 245, 233, 1.0)
                    : Color.fromRGBO(255, 235, 238, 1.0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Heading with emoji
              Row(
                children: [
                  Text(isCorrect ? "✅ " : "❌ ", style: TextStyle(fontSize: 30)),
                  Expanded(
                    child: Text(
                      isCorrect ? "Hebat!" : "Coba lagi",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:
                            isCorrect
                                ? Color.fromRGBO(46, 125, 50, 1.0)
                                : Color.fromRGBO(183, 28, 28, 1.0),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Animal image
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1.0),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    currentQuestion!.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Color.fromRGBO(244, 67, 54, 0.1),
                        child: Icon(
                          Icons.pets,
                          size: 50,
                          color: Color.fromRGBO(244, 67, 54, 0.8),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Animal characteristics (dari model baru)
              if (currentQuestion!.characteristics != null &&
                  currentQuestion!.characteristics!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: currentQuestion!.getHabitatColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '🐾 Ciri-ciri ${currentQuestion!.name}:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: currentQuestion!.getHabitatColor(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children:
                            currentQuestion!.characteristics!.map((char) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: currentQuestion!
                                      .getHabitatColor()
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  char,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: currentQuestion!.getHabitatColor(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 12),

              // Feedback message
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(69, 90, 100, 1.0),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Habitat rule (aturan sederhana)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '💡 Ingat aturan sederhana:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rule,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Habitat description
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isCorrect
                            ? Color.fromRGBO(76, 175, 80, 0.7)
                            : Color.fromRGBO(244, 67, 54, 0.7),
                    width: 2,
                  ),
                ),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(69, 90, 100, 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 12),

              // Fun fact dari model baru
              if (currentQuestion!.funFact != null &&
                  currentQuestion!.funFact!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '🎯 Fakta Menarik:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentQuestion!.funFact!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Show current progress
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Soal ${currentQuestionIndex.value + 1}/${totalQuestions.value} • Benar: ${correctAnswers.value}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Next button
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  resetHintSystem(); // Reset hint untuk soal berikutnya

                  // Go to next question
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (currentQuestionIndex.value < animals.length - 1) {
                      moveToNextQuestion();
                    } else {
                      completeQuiz();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isCorrect
                          ? Color.fromRGBO(76, 175, 80, 1.0)
                          : Color.fromRGBO(33, 150, 243, 1.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentQuestionIndex.value < animals.length - 1
                          ? "Lanjutkan"
                          : "Selesai",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      currentQuestionIndex.value < animals.length - 1
                          ? Icons.arrow_forward
                          : Icons.check,
                      color: Color.fromRGBO(255, 255, 255, 1.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void moveToNextQuestion() {
    currentQuestionIndex.value++;
    currentAnimalHabitat.value = '';
    isAnswered.value = false;
    resetHintSystem();
    update(['quiz_body']);
  }

  void completeQuiz() {
    isQuizCompleted.value = true;

    // Calculate duration and save score
    int endTime = DateTime.now().millisecondsSinceEpoch;
    int durationSeconds = ((endTime - startTime.value) / 1000).round();
    _saveQuizScore(durationSeconds);

    showResultDialog();
  }

  // Save quiz score to ScoreController
  void _saveQuizScore(int durationSeconds) {
    try {
      scoreController.saveScore(
        correctAnswers: correctAnswers.value,
        totalQuestions: totalQuestions.value,
        category: "Habitat Hewan",
        quizType: "Drag and Drop",
        duration: durationSeconds,
      );

      print(
        '📊 Habitat quiz score saved: ${correctAnswers.value}/${totalQuestions.value} in ${durationSeconds}s',
      );
    } catch (e) {
      print('❌ Error saving habitat quiz score: $e');
    }
  }

  // Function to assign an animal to a habitat (for multi-animal mode)
  void assignAnimalToHabitat(String animalId, String habitatName) {
    animalToHabitatMap[animalId] = habitatName;

    if (animalToHabitatMap.length == animals.length) {
      checkAllAnswers();
    }

    update();
  }

  void checkAllAnswers() {
    int correctAnswersCount = 0;

    animalToHabitatMap.forEach((animalId, habitatName) {
      final animal = animals.firstWhere((a) => a.id == animalId);
      if (animal.habitatId == habitatName) {
        correctAnswersCount++;
      }
    });

    score.value = correctAnswersCount;
    correctAnswers.value = correctAnswersCount;
    isQuizCompleted.value = true;

    // Calculate duration and save score
    int endTime = DateTime.now().millisecondsSinceEpoch;
    int durationSeconds = ((endTime - startTime.value) / 1000).round();
    _saveQuizScore(durationSeconds);

    showResultDialog();
  }

  void showResultDialog() {
    // Pilih emoji berdasarkan skor
    String emoji = '';
    String message = '';
    Color bgColor = Colors.blue[50]!;

    double percentage = (correctAnswers.value / totalQuestions.value) * 100;

    if (correctAnswers.value == totalQuestions.value) {
      emoji = '🌟🎉';
      message = 'Hebat sekali! Kamu mendapat nilai sempurna!';
      bgColor = Colors.amber[50]!;
    } else if (percentage >= 70) {
      emoji = '😊👏';
      message = 'Bagus! Kamu sudah menguasai banyak habitat hewan!';
      bgColor = Colors.green[50]!;
    } else if (percentage >= 40) {
      emoji = '👍';
      message = 'Coba lagi ya! Kamu pasti bisa lebih baik!';
      bgColor = Colors.orange[50]!;
    } else {
      emoji = '💪';
      message = 'Terus belajar ya! Kamu pasti bisa!';
      bgColor = Colors.red[50]!;
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 50)),
              const SizedBox(height: 16),
              Text(
                'Quiz Selesai!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(fontSize: 18, color: Colors.blueGrey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Enhanced info dengan data dari model
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              const SizedBox(height: 16),

              // Skor dengan bintang
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(animals.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.star,
                        color:
                            index < correctAnswers.value
                                ? Colors.amber
                                : Colors.grey[300],
                        size: 30,
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Kamu benar ${correctAnswers.value} dari ${totalQuestions.value}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[600],
                ),
              ),
              const SizedBox(height: 16),

              // Show percentage
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Nilai: ${percentage.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[700],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.close(2); // Close dialog and quiz page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Kembali',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        startNewRandomQuiz(); // Start with new random animals
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Soal Baru',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
      barrierDismissible: false,
    );
  }

  void resetQuiz() {
    animalToHabitatMap.clear();
    score.value = 0;
    correctAnswers.value = 0;
    isQuizCompleted.value = false;
    currentQuestionIndex.value = 0;
    currentAnimalHabitat.value = '';
    isAnswered.value = false;
    resetHintSystem();
    update(['quiz_body']);
  }

  void onBackPressed() {
    // Save current progress if any questions were answered
    if (correctAnswers.value > 0 || currentQuestionIndex.value > 0) {
      int endTime = DateTime.now().millisecondsSinceEpoch;
      int durationSeconds = ((endTime - startTime.value) / 1000).round();
      _saveQuizScore(durationSeconds);
    }

    Get.back();
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '${seconds} detik';
    } else {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      if (remainingSeconds > 0) {
        return '${minutes}m ${remainingSeconds}d';
      } else {
        return '${minutes} menit';
      }
    }
  }
}
