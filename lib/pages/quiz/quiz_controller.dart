// pages/quiz/quiz_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/quiz/widgets/animal_info_dialog.dart';
import 'package:get/get.dart';

enum QuizType { tebakGambar, kategoriHewan, habitatHewan, puzzleHewan }

class QuizQuestion {
  final String questionText;
  final String? imageUrl;
  final List<String> options;
  final int correctAnswer;
  final QuizType type;

  QuizQuestion({
    required this.questionText,
    this.imageUrl,
    required this.options,
    required this.correctAnswer,
    required this.type,
  });
}

class QuizController extends GetxController {
  final QuizType quizType;
  final int categoryIndex;

  QuizController({required this.quizType, this.categoryIndex = 0});

  // Observable variables
  QuizQuestion? _currentQuestion;
  QuizQuestion? get currentQuestion => _currentQuestion;
  set currentQuestion(QuizQuestion? value) {
    _currentQuestion = value;
    update(['quiz_body']); // Update UI
  }

  int _currentQuestionIndex = 0;
  int get currentQuestionIndex => _currentQuestionIndex;
  set currentQuestionIndex(int value) {
    _currentQuestionIndex = value;
    update(['quiz_body']);
  }

  int _score = 0;
  int get score => _score;
  set score(int value) {
    _score = value;
    update(['quiz_body']);
  }

  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;
  set isAnswered(bool value) {
    _isAnswered = value;
    update(['quiz_body']);
  }

  int _selectedAnswer = -1;
  int get selectedAnswer => _selectedAnswer;
  set selectedAnswer(int value) {
    _selectedAnswer = value;
    update(['quiz_body']);
  }

  // Questions list
  List<QuizQuestion> questions = [];

  @override
  void onInit() {
    super.onInit();
    generateQuestions();
    loadQuestion();
  }

  void generateQuestions() {
    switch (quizType) {
      case QuizType.tebakGambar:
        generateTebakGambarQuestions();
        break;
      case QuizType.kategoriHewan:
        generateKategoriHewanQuestions();
        break;
      case QuizType.habitatHewan:
        generateHabitatHewanQuestions();
        break;
      case QuizType.puzzleHewan:
        generatePuzzleHewanQuestions();
        break;
    }
  }

  void generateTebakGambarQuestions() {
    questions = [
      QuizQuestion(
        questionText: "Apa nama hewan diatas?",
        imageUrl:
            "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-siberian-husky-dog-png-image_16179695.png",
        options: ["Kucing", "Anjing", "Kelinci", "Kuda"],
        correctAnswer: 1,
        type: QuizType.tebakGambar,
      ),
      QuizQuestion(
        questionText: "Apa nama hewan diatas?",
        imageUrl:
            "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-orange-cat-cute-little-kitty-png-image_14519124.png",
        options: ["Anjing", "Kelinci", "Kucing", "Singa"],
        correctAnswer: 2,
        type: QuizType.tebakGambar,
      ),
      QuizQuestion(
        questionText: "Apa nama hewan diatas?",
        imageUrl:
            "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-horse-png-with-ai-generated-png-image_14576200.png",
        options: ["Kuda", "Zebra", "Jerapah", "Sapi"],
        correctAnswer: 0,
        type: QuizType.tebakGambar,
      ),
      QuizQuestion(
        questionText: "Apa nama hewan diatas?",
        imageUrl:
            "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//ayam.jpg",
        options: ["Ayam", "Bebek", "Burung", "Angsa"],
        correctAnswer: 0,
        type: QuizType.tebakGambar,
      ),
      QuizQuestion(
        questionText: "Apa nama hewan diatas?",
        imageUrl:
            "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-tiger-walking-wildlife-scene-transparent-background-png-image_9153495.png",
        options: ["Singa", "Harimau", "Cheetah", "Macan"],
        correctAnswer: 1,
        type: QuizType.tebakGambar,
      ),
    ];
  }

  void generateKategoriHewanQuestions() {
    questions = [
      QuizQuestion(
        questionText: "Ke kategori manakah hewan ini termasuk?",
        imageUrl:
            "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-siberian-husky-dog-png-image_16179695.png",
        options: ["Mamalia", "Unggas", "Reptil", "Amphibi"],
        correctAnswer: 0,
        type: QuizType.kategoriHewan,
      ),
      QuizQuestion(
        questionText: "Ke kategori manakah hewan ini termasuk?",
        imageUrl:
            "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//ayam.jpg",
        options: ["Mamalia", "Unggas", "Reptil", "Ikan"],
        correctAnswer: 1,
        type: QuizType.kategoriHewan,
      ),
      QuizQuestion(
        questionText: "Ke kategori manakah hewan ini termasuk?",
        imageUrl:
            "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-tiger-walking-wildlife-scene-transparent-background-png-image_9153495.png",
        options: ["Reptil", "Mamalia", "Unggas", "Ikan"],
        correctAnswer: 1,
        type: QuizType.kategoriHewan,
      ),
    ];
  }

  void generateHabitatHewanQuestions() {
    questions = [
      QuizQuestion(
        questionText: "Di mana habitat alami hewan ini?",
        imageUrl:
            "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-tiger-walking-wildlife-scene-transparent-background-png-image_9153495.png",
        options: ["Hutan", "Laut", "Kutub", "Gurun"],
        correctAnswer: 0,
        type: QuizType.habitatHewan,
      ),
      QuizQuestion(
        questionText: "Di mana habitat alami hewan ini?",
        imageUrl:
            "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-horse-png-with-ai-generated-png-image_14576200.png",
        options: ["Padang rumput", "Hutan", "Laut", "Gunung"],
        correctAnswer: 0,
        type: QuizType.habitatHewan,
      ),
      QuizQuestion(
        questionText: "Di mana habitat alami hewan ini?",
        imageUrl:
            "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-siberian-husky-dog-png-image_16179695.png",
        options: ["Di mana saja", "Hutan", "Gurun", "Air"],
        correctAnswer: 0,
        type: QuizType.habitatHewan,
      ),
    ];
  }

  void generatePuzzleHewanQuestions() {
    questions = [
      QuizQuestion(
        questionText: "Manakah gambar hewan yang sama?",
        imageUrl:
            "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-siberian-husky-dog-png-image_16179695.png",
        options: ["A", "B", "C", "D"],
        correctAnswer: 1,
        type: QuizType.puzzleHewan,
      ),
      QuizQuestion(
        questionText: "Mana yang merupakan bagian dari hewan ini?",
        imageUrl:
            "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-orange-cat-cute-little-kitty-png-image_14519124.png",
        options: ["Ekor panjang", "Sirip", "Sayap", "Cangkang"],
        correctAnswer: 0,
        type: QuizType.puzzleHewan,
      ),
      QuizQuestion(
        questionText: "Manakah suara yang dibuat hewan ini?",
        imageUrl:
            "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//pngtree-tiger-walking-wildlife-scene-transparent-background-png-image_9153495.png",
        options: ["Kukuruyuk", "Guk guk", "Aummm", "Meong"],
        correctAnswer: 2,
        type: QuizType.puzzleHewan,
      ),
    ];
  }

  void loadQuestion() {
    if (currentQuestionIndex < questions.length) {
      currentQuestion = questions[currentQuestionIndex];
      isAnswered = false;
      selectedAnswer = -1;
    } else {
      showQuizResult();
    }
  }

  void onAnswerTap(int answerIndex) {
    if (!isAnswered) {
      selectedAnswer = answerIndex;
      isAnswered = true;

      // Wait for color transition animation
      Future.delayed(const Duration(milliseconds: 500), () {
        _showAnimalInfoDialog(answerIndex);
      });
    }
  }

  Color getOptionColor(int index) {
    if (!isAnswered) {
      return Colors.white;
    }

    if (index == currentQuestion!.correctAnswer) {
      return Colors.green.withOpacity(0.5);
    } else if (index == selectedAnswer &&
        index != currentQuestion!.correctAnswer) {
      return Colors.red.withOpacity(0.5);
    } else {
      return Colors.white.withOpacity(0.5);
    }
  }

  // Update method _showAnimalInfoDialog in quiz_controller.dart
  void _showAnimalInfoDialog(int selectedIndex) {
    String correctAnswer =
        currentQuestion!.options[currentQuestion!.correctAnswer];
    String selectedAnswer = currentQuestion!.options[selectedIndex];
    bool isCorrect = selectedIndex == currentQuestion!.correctAnswer;

    // Create description including the animal name
    String animalDescription = _getAnimalDescription(correctAnswer);
    String fullDescription =
        "Hewan pada gambar diatas adalah $correctAnswer, ${animalDescription.toLowerCase()}";

    Get.dialog(
      AnimalInfoDialog(
        animalName: correctAnswer,
        description: fullDescription,
        imageUrl: currentQuestion!.imageUrl,
        isCorrect: isCorrect,
        selectedAnswer: selectedAnswer, // Tambahkan ini
        onNext: () {
          Get.back(); // Close dialog

          if (isCorrect) {
            score++;
          }

          // Wait for dialog to close before moving to next question
          Future.delayed(const Duration(milliseconds: 500), () {
            currentQuestionIndex++;
            loadQuestion();
          });
        },
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  String _getAnimalDescription(String animalName) {
    // Gunakan kapitalisasi yang benar untuk setiap nama hewan
    String properAnimalName = animalName.toLowerCase();
    properAnimalName =
        properAnimalName[0].toUpperCase() + properAnimalName.substring(1);

    switch (properAnimalName) {
      case "Kucing":
        return "merupakan hewan mamalia berkaki empat yang suka bermain dengan bola dan sering mengeluarkan suara 'meong'.";
      case "Anjing":
        return "adalah hewan setia yang suka bermain tangkap bola dan menggonggong 'guk guk'.";
      case "Kuda":
        return "hewan besar yang bisa ditunggangi dan menghasilkan suara 'hiiihiii'.";
      case "Ayam":
        return "burung yang bisa berkokok kukuruyuk di pagi hari dan menghasilkan telur.";
      case "Harimau":
        return "hewan kucing besar dengan loreng hitam-oranye yang berburu di hutan.";
      default:
        return "salah satu hewan yang bisa kita pelajari.";
    }
  }

  void showQuizResult() {
    // Pilih emoji berdasarkan skor
    String emoji = '';
    String message = '';
    Color bgColor = Colors.blue[50]!;

    if (score == questions.length) {
      emoji = '🌟🎉';
      message = 'Hebat sekali! Kamu mendapat nilai sempurna!';
      bgColor = Colors.amber[50]!;
    } else if (score >= questions.length * 0.7) {
      emoji = '😊👏';
      message = 'Bagus! Kamu sudah menguasai banyak!';
      bgColor = Colors.green[50]!;
    } else if (score >= questions.length * 0.4) {
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
              const SizedBox(height: 16),
              // Skor dengan bintang
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(questions.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.star,
                        color: index < score ? Colors.amber : Colors.grey[300],
                        size: 30,
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Kamu benar $score dari ${questions.length}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[600],
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
                        resetQuiz();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Main Lagi',
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
    currentQuestionIndex = 0;
    score = 0;
    loadQuestion();
  }

  void onBackPressed() {
    Get.back();
  }

  String getQuizTitle() {
    switch (quizType) {
      case QuizType.tebakGambar:
        return "Tebak Gambar";
      case QuizType.kategoriHewan:
        return "Kategori Hewan";
      case QuizType.habitatHewan:
        return "Habitat Hewan";
      case QuizType.puzzleHewan:
        return "Puzzle Hewan";
    }
  }
}
