import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/quiz/widgets/animal_info_dialog.dart';
import 'package:get/get.dart';
import 'dart:math';

enum QuizType { tebakGambar, kategoriHewan, habitatHewan, puzzleHewan }

// Model untuk habitat - updated to match HabitatModel
class Habitat {
  final String name;
  final String imagePath;
  final Color color;
  final String description;

  Habitat({
    required this.name,
    required this.imagePath,
    required this.color,
    required this.description,
  });
}

class QuizQuestion {
  final String questionText;
  final String? imageUrl;
  final List<String> options;
  final int correctAnswer;
  final QuizType type;
  final String? correctHabitat;

  QuizQuestion({
    required this.questionText,
    this.imageUrl,
    required this.options,
    required this.correctAnswer,
    required this.type,
    this.correctHabitat,
  });
}

class QuizController extends GetxController {
  final QuizType quizType;

  QuizController({required this.quizType});

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

  final RxString currentAnimalHabitat = "".obs;

  // Animal data from your lists
  final List<Map<String, dynamic>> vertebrateAnimals = [
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//Chicken_Quad.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//chicken.png",
      "name": "Ayam",
      "category": "Unggas",
      "habitat": "Peternakan",
      "sound": "Kukuruyuk",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//dog_001.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//dog.png",
      "name": "Anjing",
      "category": "Mamalia",
      "habitat": "Rumah",
      "sound": "Guk guk",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//cat.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//cat.png",
      "name": "Kucing",
      "category": "Mamalia",
      "habitat": "Rumah",
      "sound": "Meong",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//Frog_Quad.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//frog.png",
      "name": "Katak",
      "category": "Amphibi",
      "habitat": "Air",
      "sound": "Ribbit",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//iguana.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//iguana.png",
      "name": "Iguana",
      "category": "Reptil",
      "habitat": "Hutan",
      "sound": "Desisan",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//rabbit.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//rabbit.png",
      "name": "Kelinci",
      "category": "Mamalia",
      "habitat": "Padang Rumput",
      "sound": "Mencicit",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//bird.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//bird.png",
      "name": "Burung",
      "category": "Unggas",
      "habitat": "Hutan",
      "sound": "Berkicau",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//turtle2.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//turtle.png",
      "name": "Kura-kura",
      "category": "Reptil",
      "habitat": "Air",
      "sound": "Tidak bersuara",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//carp.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//carp.png",
      "name": "Ikan Mas",
      "category": "Ikan",
      "habitat": "Air",
      "sound": "Tidak bersuara",
    },
  ];

  final List<Map<String, dynamic>> invertebrateAnimals = [
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//blue_crab.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//crab.png",
      "name": "Kepiting Biru",
      "category": "Invertebrata",
      "habitat": "Laut",
      "sound": "Tidak bersuara",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//clam_with_tongue_and_pearl.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//clam.png",
      "name": "Kerang",
      "category": "Invertebrata",
      "habitat": "Laut",
      "sound": "Tidak bersuara",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//spider.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//spider.png",
      "name": "Laba-laba",
      "category": "Invertebrata",
      "habitat": "Rumah",
      "sound": "Tidak bersuara",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//squid.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//squid.png",
      "name": "Cumi-cumi",
      "category": "Invertebrata",
      "habitat": "Laut",
      "sound": "Tidak bersuara",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//sponge_recent_demosponge.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//sponge.png",
      "name": "Spons",
      "category": "Invertebrata",
      "habitat": "Laut",
      "sound": "Tidak bersuara",
    },
    {
      "model3dUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Model3d//cushion_star.glb",
      "photoUrl":
          "https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//star.png",
      "name": "Bintang Laut",
      "category": "Invertebrata",
      "habitat": "Laut",
      "sound": "Tidak bersuara",
    },
  ];

  // Updated habitats list to match HabitatModel
  final List<Habitat> habitats = [
    Habitat(
      name: "Hutan",
      imagePath: "assets/habitats/forest.png",
      color: Colors.green.withOpacity(0.7),
      description: "Daerah yang ditumbuhi pepohonan dan tumbuhan lebat",
    ),
    Habitat(
      name: "Air",
      imagePath: "assets/habitats/water.png",
      color: Colors.blue.withOpacity(0.7),
      description: "Perairan tawar seperti sungai, danau, dan kolam",
    ),
    Habitat(
      name: "Padang Rumput",
      imagePath: "assets/habitats/grassland.png",
      color: Colors.yellow.withOpacity(0.7),
      description: "Daerah berumput luas dengan sedikit pepohonan",
    ),
    Habitat(
      name: "Rumah",
      imagePath: "assets/habitats/house.png",
      color: Colors.pink.withOpacity(0.7),
      description: "Tempat tinggal manusia, biasanya untuk hewan peliharaan",
    ),
    Habitat(
      name: "Peternakan",
      imagePath: "assets/habitats/farm.png",
      color: Colors.orange.withOpacity(0.7),
      description: "Area khusus untuk memelihara hewan ternak",
    ),
    Habitat(
      name: "Laut",
      imagePath: "assets/habitats/sea.png",
      color: Colors.cyan.withOpacity(0.7),
      description: "Perairan asin yang luas tempat hidup berbagai makhluk laut",
    ),
  ];

  // Questions list
  List<QuizQuestion> questions = [];
  List<QuizQuestion> allQuestions = [];

  final Random _random = Random();

  @override
  void onInit() {
    super.onInit();
    generateAllQuestions();
    selectRandomQuestions();
    loadQuestion();
  }

  List<Map<String, dynamic>> get allAnimals => [
    ...vertebrateAnimals,
    ...invertebrateAnimals,
  ];

  void generateAllQuestions() {
    allQuestions.clear();

    switch (quizType) {
      case QuizType.tebakGambar:
        generateAllTebakGambarQuestions();
        break;
      case QuizType.kategoriHewan:
        generateAllKategoriHewanQuestions();
        break;
      case QuizType.habitatHewan:
        generateAllHabitatHewanQuestions();
        break;
      case QuizType.puzzleHewan:
        generateAllPuzzleHewanQuestions();
        break;
    }
  }

  void selectRandomQuestions() {
    // Shuffle all questions and take only 10
    allQuestions.shuffle(_random);
    questions = allQuestions.take(10).toList();
  }

  void generateAllTebakGambarQuestions() {
    for (var animal in allAnimals) {
      // Generate 3 wrong options by picking random animals
      List<String> wrongOptions =
          allAnimals
              .where((a) => a["name"] != animal["name"])
              .map((a) => a["name"] as String)
              .toList();
      wrongOptions.shuffle(_random);
      wrongOptions = wrongOptions.take(3).toList();

      // Create options list with correct answer
      List<String> options = [...wrongOptions, animal["name"]];
      options.shuffle(_random);

      int correctIndex = options.indexOf(animal["name"]);

      allQuestions.add(
        QuizQuestion(
          questionText: "Apa nama hewan diatas?",
          imageUrl: animal["photoUrl"],
          options: options,
          correctAnswer: correctIndex,
          type: QuizType.tebakGambar,
        ),
      );
    }
  }

  void generateAllKategoriHewanQuestions() {
    List<String> categories = [
      "Mamalia",
      "Unggas",
      "Reptil",
      "Amphibi",
      "Ikan",
      "Invertebrata",
    ];

    for (var animal in allAnimals) {
      String correctCategory = animal["category"];

      // Generate wrong categories
      List<String> wrongCategories =
          categories.where((c) => c != correctCategory).toList();
      wrongCategories.shuffle(_random);
      wrongCategories = wrongCategories.take(3).toList();

      // Create options list
      List<String> options = [...wrongCategories, correctCategory];
      options.shuffle(_random);

      int correctIndex = options.indexOf(correctCategory);

      allQuestions.add(
        QuizQuestion(
          questionText: "Hewan ini termasuk kategori apa?",
          imageUrl: animal["photoUrl"],
          options: options,
          correctAnswer: correctIndex,
          type: QuizType.kategoriHewan,
        ),
      );
    }
  }

  void generateAllHabitatHewanQuestions() {
    for (var animal in allAnimals) {
      String correctHabitat = animal["habitat"];

      allQuestions.add(
        QuizQuestion(
          questionText: "Tarik hewan ke habitat tempat ia hidup",
          imageUrl: animal["photoUrl"],
          options: habitats.map((h) => h.name).toList(),
          correctAnswer: habitats.indexWhere((h) => h.name == correctHabitat),
          correctHabitat: correctHabitat,
          type: QuizType.habitatHewan,
        ),
      );
    }
  }

  void generateAllPuzzleHewanQuestions() {
    for (var animal in allAnimals) {
      String correctSound = animal["sound"];

      // Generate sound options
      List<String> soundOptions = [
        "Guk guk",
        "Meong",
        "Kukuruyuk",
        "Ribbit",
        "Berkicau",
        "Desisan",
        "Mencicit",
      ];
      List<String> wrongSounds =
          soundOptions.where((s) => s != correctSound).toList();
      wrongSounds.shuffle(_random);
      wrongSounds = wrongSounds.take(3).toList();

      List<String> options = [...wrongSounds, correctSound];
      options.shuffle(_random);

      int correctIndex = options.indexOf(correctSound);

      allQuestions.add(
        QuizQuestion(
          questionText: "Manakah suara yang dibuat hewan ini?",
          imageUrl: animal["photoUrl"],
          options: options,
          correctAnswer: correctIndex,
          type: QuizType.puzzleHewan,
        ),
      );

      // Add another type of puzzle question - body parts
      if (animal["category"] != "Invertebrata") {
        List<String> bodyParts = ["Ekor", "Kaki", "Mata", "Telinga"];
        bodyParts.shuffle(_random);

        String correctBodyPart = _getAnimalBodyPart(animal["name"]);
        List<String> wrongBodyParts =
            bodyParts.where((p) => p != correctBodyPart).take(3).toList();

        List<String> bodyOptions = [...wrongBodyParts, correctBodyPart];
        bodyOptions.shuffle(_random);

        int bodyCorrectIndex = bodyOptions.indexOf(correctBodyPart);

        allQuestions.add(
          QuizQuestion(
            questionText: "Bagian tubuh apa yang menonjol dari hewan ini?",
            imageUrl: animal["photoUrl"],
            options: bodyOptions,
            correctAnswer: bodyCorrectIndex,
            type: QuizType.puzzleHewan,
          ),
        );
      }
    }
  }

  String _getAnimalBodyPart(String animalName) {
    switch (animalName) {
      case "Kelinci":
        return "Telinga";
      case "Anjing":
      case "Kucing":
        return "Ekor";
      case "Burung":
        return "Sayap";
      case "Katak":
        return "Kaki";
      default:
        return "Mata";
    }
  }

  void loadQuestion() {
    if (currentQuestionIndex < questions.length) {
      currentQuestion = questions[currentQuestionIndex];
      isAnswered = false;
      selectedAnswer = -1;
      currentAnimalHabitat.value = ""; // Reset habitat saat ganti soal
    } else {
      showQuizResult();
    }
  }

  // For habitat drag and drop
  void onDragAnimalToHabitat(String habitatName) {
    if (currentQuestion != null && !isAnswered) {
      currentAnimalHabitat.value = habitatName;
      isAnswered = true;

      // Check if habitat is correct
      bool isCorrect = habitatName == currentQuestion!.correctHabitat;

      // Wait for dragging animation
      Future.delayed(const Duration(milliseconds: 500), () {
        _showHabitatFeedback(habitatName, isCorrect);
      });
    }
  }

  void _showHabitatFeedback(String selectedHabitat, bool isCorrect) {
    String animalName = _getAnimalNameFromImage(currentQuestion!.imageUrl!);
    String correctHabitat = currentQuestion!.correctHabitat!;

    String message =
        isCorrect
            ? "Benar! $animalName memang hidup di $correctHabitat."
            : "Belum tepat. $animalName hidup di $correctHabitat, bukan di $selectedHabitat.";

    String description = _getHabitatDescription(correctHabitat);

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
                  isCorrect
                      ? Text("✅ ", style: TextStyle(fontSize: 30))
                      : Text("❌ ", style: TextStyle(fontSize: 30)),
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
                height: 150,
                width: 150,
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
                    currentQuestion!.imageUrl!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 16),

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
                ),
              ),

              const SizedBox(height: 20),

              // Next button
              ElevatedButton(
                onPressed: () {
                  Get.back();

                  if (isCorrect) {
                    score++;
                  }

                  // Go to next question
                  Future.delayed(const Duration(milliseconds: 300), () {
                    currentQuestionIndex++;
                    loadQuestion();
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
                      "Lanjutkan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
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

  String _getAnimalNameFromImage(String imageUrl) {
    // Find animal by image URL
    for (var animal in allAnimals) {
      if (imageUrl.contains(
        animal["photoUrl"].split('/').last.split('.').first,
      )) {
        return animal["name"];
      }
    }
    return "Hewan ini";
  }

  String _getHabitatDescription(String habitatName) {
    final habitat = habitats.firstWhere(
      (h) => h.name == habitatName,
      orElse:
          () => Habitat(
            name: "Unknown",
            imagePath: "",
            color: Colors.grey,
            description: "Tidak ada deskripsi",
          ),
    );
    return habitat.description;
  }

  // Mengubah metode untuk menangani jawaban
  void onAnswerTap(int answerIndex) {
    if (!isAnswered) {
      selectedAnswer = answerIndex;
      isAnswered = true;

      // Tunggu animasi transisi warna
      Future.delayed(const Duration(milliseconds: 500), () {
        _showAnimalInfoDialog(answerIndex);
      });
    }
  }

  // Mengambil warna opsi jawaban
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

  // Menampilkan informasi hewan saat jawaban dipilih
  void _showAnimalInfoDialog(int selectedIndex) {
    String correctAnswer =
        currentQuestion!.options[currentQuestion!.correctAnswer];
    String selectedAnswer = currentQuestion!.options[selectedIndex];
    bool isCorrect = selectedIndex == currentQuestion!.correctAnswer;

    // Untuk quiz kategori hewan, ambil nama hewan dari gambar, bukan kategori
    String animalName;
    String fullDescription;

    if (quizType == QuizType.kategoriHewan) {
      // Ambil nama hewan yang sebenarnya dari URL gambar
      animalName = _getAnimalNameFromImage(currentQuestion!.imageUrl!);
      String animalDescription = _getAnimalDescription(animalName);
      fullDescription =
          "Hewan pada gambar diatas adalah $animalName, ${animalDescription.toLowerCase()} $animalName termasuk dalam kategori $correctAnswer.";
    } else {
      // Untuk quiz selain kategori hewan
      animalName = correctAnswer;
      String animalDescription = _getAnimalDescription(correctAnswer);
      fullDescription =
          "Hewan pada gambar diatas adalah $correctAnswer, ${animalDescription.toLowerCase()}";
    }

    Get.dialog(
      AnimalInfoDialog(
        animalName: animalName,
        description: fullDescription,
        imageUrl: currentQuestion!.imageUrl,
        isCorrect: isCorrect,
        selectedAnswer: selectedAnswer,
        onNext: () {
          Get.back(); // Menutup dialog

          if (isCorrect) {
            score++;
          }

          // Tunggu dialog menutup sebelum melanjutkan ke pertanyaan berikutnya
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

  // Mengembalikan deskripsi berdasarkan nama hewan
  String _getAnimalDescription(String animalName) {
    // Normalisasi nama hewan untuk matching yang akurat
    String normalizedName = animalName.trim();

    switch (normalizedName) {
      case "Kucing":
        return "merupakan hewan mamalia berkaki empat yang suka bermain dengan bola dan sering mengeluarkan suara 'meong'.";
      case "Anjing":
        return "adalah hewan setia yang suka bermain tangkap bola dan menggonggong 'guk guk'.";
      case "Kuda":
        return "hewan besar yang bisa ditunggangi dan menghasilkan suara 'hiiihiii'.";
      case "Ayam":
        return "burung yang bisa berkokok kukuruyuk di pagi hari dan menghasilkan telur.";
      case "Katak":
        return "hewan amfibi yang terkenal dengan loncatannya dan suara 'ribbit'.";
      case "Iguana":
        return "reptil besar yang sering dijumpai di daerah tropis, dikenal dengan ekornya yang panjang.";
      case "Kelinci":
        return "hewan mamalia berkaki empat yang terkenal dengan telinganya yang panjang dan suka makan wortel.";
      case "Burung":
        return "hewan yang memiliki sayap dan dapat terbang, terdapat banyak spesies yang berbeda di seluruh dunia.";
      case "Kura-kura":
        return "hewan reptil yang memiliki cangkang keras dan seringkali hidup di air dan darat.";
      case "Ikan Mas":
        return "ikan air tawar yang populer dalam aquaria dan sering dipelihara untuk keindahannya.";
      case "Kepiting Biru":
        return "hewan laut yang memiliki kaki bagian depan yang besar, sering ditemukan di perairan.";
      case "Kerang":
        return "hewan laut dengan cangkang yang sering ditemukan di pantai.";
      case "Laba-laba":
        return "hewan arakhnida yang memiliki delapan kaki dan sering membuat jaring untuk menangkap mangsa.";
      case "Cumi-cumi":
        return "hewan laut yang memiliki tentakel dan dikenal dengan kemampuannya berenang cepat.";
      case "Spons":
        return "hewan laut yang memiliki tubuh berpori dan sering ditemukan di dasar laut.";
      case "Bintang Laut":
        return "hewan laut yang memiliki bentuk seperti bintang dan dapat ditemukan di dasar laut.";
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
              // Skor dengan bintang - maksimal 2 baris
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: List.generate(questions.length, (index) {
                  return Icon(
                    Icons.star,
                    color: index < score ? Colors.amber : Colors.grey[300],
                    size: 30,
                  );
                }),
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
    // Generate new random questions when resetting
    selectRandomQuestions();
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
