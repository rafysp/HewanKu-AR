// pages/quiz/drag_and_drop_quiz_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/quiz/habitat/model/animalmodel.dart';
import 'package:flutter_application_2/pages/quiz/habitat/model/habitatmodel.dart';
import 'package:get/get.dart';

class DragAndDropQuizController extends GetxController {
  final List<HabitatModel> habitats = [];
  final List<AnimalModel> _allAnimals = []; // All 14 animals
  final List<AnimalModel> animals = []; // Selected 10 animals for quiz
  final RxMap<String, String> animalToHabitatMap = <String, String>{}.obs;
  final RxInt score = 0.obs;
  final RxBool isQuizCompleted = false.obs;

  // Additional properties for single animal quiz mode
  final RxInt currentQuestionIndex = 0.obs;
  final RxString currentAnimalHabitat = ''.obs;
  final RxBool isAnswered = false.obs;

  // Quiz configuration
  static const int totalQuestionsToShow = 10;
  static const int totalAvailableAnimals = 14;

  // Current question getter for compatibility
  AnimalModel? get currentQuestion =>
      currentQuestionIndex.value < animals.length
          ? animals[currentQuestionIndex.value]
          : null;

  // Questions getter for compatibility
  List<AnimalModel> get questions => animals;

  DragAndDropQuizController() {
    loadHabitats();
    loadAllAnimals();
    shuffleAndSelectAnimals();
  }

  void loadHabitats() {
    habitats.assignAll([
      HabitatModel(
        name: 'Hutan',
        imagePath: 'assets/habitats/forest.png',
        color: Colors.green.withOpacity(0.7),
      ),
      HabitatModel(
        name: 'Air',
        imagePath: 'assets/habitats/water.png',
        color: Colors.blue.withOpacity(0.7),
      ),
      HabitatModel(
        name: 'Padang Rumput',
        imagePath: 'assets/habitats/grassland.png',
        color: Colors.yellow.withOpacity(0.7),
      ),
      HabitatModel(
        name: 'Rumah',
        imagePath: 'assets/habitats/house.png',
        color: Colors.pink.withOpacity(0.7),
      ),
     
    
      HabitatModel(
        name: 'Peternakan',
        imagePath: 'assets/habitats/farm.png',
        color: Colors.brown.withOpacity(0.7),
      ),
    ]);
  }

  void loadAllAnimals() {
    _allAnimals.assignAll([
      AnimalModel(
        id: 'ayam',
        name: 'Ayam',
        imagePath:
            'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//chicken.png',
        habitatId: 'Peternakan',
      ),
      AnimalModel(
        id: 'anjing',
        name: 'Anjing',
        imagePath:
            'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//dog.png',
        habitatId: 'Rumah',
      ),
      AnimalModel(
        id: 'kucing',
        name: 'Kucing',
        imagePath:
            'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//cat.png',
        habitatId: 'Rumah',
      ),
      AnimalModel(
        id: 'katak',
        name: 'Katak',
        imagePath:
            'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//frog.png',
        habitatId: 'Air',
      ),
      AnimalModel(
        id: 'iguana',
        name: 'Iguana',
        imagePath:
            'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//iguana.png',
        habitatId: 'Hutan',
      ),
      AnimalModel(
        id: 'kelinci',
        name: 'Kelinci',
        imagePath:
            'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//rabbit.png',
        habitatId: 'Padang Rumput',
      ),
      AnimalModel(
        id: 'burung',
        name: 'Burung',
        imagePath:
            'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//bird.png',
        habitatId: 'Hutan',
      ),
      AnimalModel(
        id: 'kura-kura',
        name: 'Kura-kura',
        imagePath:
            'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//turtle.png',
        habitatId: 'Air',
      ),
      AnimalModel(
        id: 'ikan_mas',
        name: 'Ikan Mas',
        imagePath:
            'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//carp.png',
        habitatId: 'Air',
      ),
      AnimalModel(
        id: 'kepiting_biru',
        name: 'Kepiting Biru',
        imagePath:
            'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//crab.png',
        habitatId: 'Air',
      ),
      AnimalModel(
        id: 'kerang',
        name: 'Kerang',
        imagePath:
            'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//kerang.png',
        habitatId: 'Air',
      ),
      AnimalModel(
        id: 'laba_laba',
        name: 'Laba-laba',
        imagePath:
            'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//spider.png',
        habitatId: 'Rumah',
      ),
      AnimalModel(
        id: 'cumi_cumi',
        name: 'Cumi-cumi',
        imagePath:
            'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//squid.png',
        habitatId: 'Air',
      ),
      AnimalModel(
        id: 'spons',
        name: 'Spons',
        imagePath:
            'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//sponge.png',
        habitatId: 'Air',
      ),
      AnimalModel(
        id: 'bintang_laut',
        name: 'Bintang Laut',
        imagePath:
            'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//star.png',
        habitatId: 'Air',
      ),
    ]);
  }

  void shuffleAndSelectAnimals() {
    // Create a copy of all animals and shuffle it
    List<AnimalModel> shuffledAnimals = List.from(_allAnimals);
    shuffledAnimals.shuffle();

    // Take only the first 10 animals from the shuffled list
    animals.assignAll(shuffledAnimals.take(totalQuestionsToShow).toList());

    print(
      '🎲 Quiz dimulai dengan ${animals.length} soal dari ${_allAnimals.length} hewan tersedia',
    );
    print('📝 Hewan yang terpilih: ${animals.map((a) => a.name).join(', ')}');
  }

  // Method to restart quiz with new random selection
  void startNewRandomQuiz() {
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
    }

    // Wait for dragging animation
    Future.delayed(Duration(milliseconds: 500), () {
      _showHabitatFeedback(habitatName, isCorrect);
    });

    update(['quiz_body']);
  }

  void _showHabitatFeedback(String selectedHabitat, bool isCorrect) {
    String animalName = currentQuestion!.name;
    String correctHabitat = currentQuestion!.habitatId;

    String message =
        isCorrect
            ? "🎉 Pintar sekali! $animalName memang suka tinggal di $correctHabitat. Kamu hebat!"
            : "🤔 Hmm, belum tepat nih. Ternyata $animalName lebih suka tinggal di $correctHabitat, bukan di $selectedHabitat. Ayo coba lagi!";

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
                    currentQuestion!.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Color.fromRGBO(244, 67, 54, 0.1),
                        child: Icon(
                          Icons.pets,
                          size: 60,
                          color: Color.fromRGBO(244, 67, 54, 0.8),
                        ),
                      );
                    },
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
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // Next button
              ElevatedButton(
                onPressed: () {
                  Get.back();

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
                      "Lanjutkan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                      ),
                    ),
                    const SizedBox(width: 8),
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

  void moveToNextQuestion() {
    currentQuestionIndex.value++;
    currentAnimalHabitat.value = '';
    isAnswered.value = false;
    update(['quiz_body']);
  }

  void completeQuiz() {
    isQuizCompleted.value = true;
    showResultDialog();
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
    int correctAnswers = 0;

    animalToHabitatMap.forEach((animalId, habitatName) {
      final animal = animals.firstWhere((a) => a.id == animalId);
      if (animal.habitatId == habitatName) {
        correctAnswers++;
      }
    });

    score.value = correctAnswers;
    isQuizCompleted.value = true;

    showResultDialog();
  }

  void showResultDialog() {
    // Pilih emoji berdasarkan skor
    String emoji = '';
    String message = '';
    Color bgColor = Colors.blue[50]!;

    if (score.value == animals.length) {
      emoji = '🌟🎉';
      message = 'Hebat sekali! Kamu mendapat nilai sempurna!';
      bgColor = Colors.amber[50]!;
    } else if (score.value >= animals.length * 0.7) {
      emoji = '😊👏';
      message = 'Bagus! Kamu sudah menguasai banyak habitat hewan!';
      bgColor = Colors.green[50]!;
    } else if (score.value >= animals.length * 0.4) {
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
              // Info soal yang dimainkan
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Dimainkan ${animals.length} dari ${_allAnimals.length} soal tersedia',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blueGrey[600],
                    fontWeight: FontWeight.w500,
                  ),
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
                            index < score.value
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
                'Kamu benar ${score.value} dari ${animals.length}',
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

  String _getHabitatDescription(String habitatName) {
    String animalName = currentQuestion?.name ?? '';

    switch (habitatName) {
      case 'Hutan':
        if (animalName == 'Iguana') {
          return '🌳 Iguana suka tinggal di hutan karena bisa memanjat pohon tinggi dan berjemur di bawah sinar matahari yang masuk lewat dedaunan!';
        } else if (animalName == 'Burung') {
          return '🌳 Burung senang di hutan karena ada banyak pohon untuk membuat sarang dan mencari serangga kecil untuk dimakan!';
        }
        return '🌳 Tempat yang sejuk dengan pohon-pohon tinggi dan rindang. Di sini banyak binatang bermain dan mencari makan!';

      case 'Air':
        if (animalName == 'Katak') {
          return '💧 Katak sangat suka air karena kulitnya harus selalu lembab, dan di air dia bisa berenang dengan kaki yang lebar seperti dayung!';
        } else if (animalName == 'Kura-kura') {
          return '💧 Kura-kura suka berenang di air yang tenang. Cangkangnya yang keras melindunginya, dan kakinya seperti dayung untuk berenang!';
        } else if (animalName == 'Ikan Mas') {
          return '💧 Ikan Mas hidup di air tawar yang jernih. Mereka bernapas dengan insang dan berenang dengan sirip yang cantik!';
        }
        else if (animalName == 'Kepiting Biru') {
          return '🌊 Kepiting Biru suka hidup di laut karena bisa berjalan di dasar laut dengan kaki-kakinya yang kuat dan capit untuk melindungi diri!';
        } else if (animalName == 'Kerang') {
          return '🌊 Kerang tinggal di dasar laut dalam cangkang yang keras. Mereka menyaring air laut untuk mencari makanan kecil-kecil!';
        } else if (animalName == 'Cumi-cumi') {
          return '🌊 Cumi-cumi pandai berenang di laut dengan tentakel yang lentur. Kalau ada bahaya, mereka bisa menyemprotkan tinta hitam!';
        } else if (animalName == 'Spons') {
          return '🌊 Spons laut hidup menempel di dasar laut. Mereka seperti filter alami yang membersihkan air laut!';
        } else if (animalName == 'Bintang Laut') {
          return '🌊 Bintang Laut berjalan pelan di dasar laut dengan kaki-kaki kecilnya. Kalau kakinya putus, bisa tumbuh lagi lho!';
        }
        return '💧 Sungai, danau, atau kolam yang airnya jernih dan segar. Tempat favorit untuk berenang dan bermain air!';

      case 'Padang Rumput':
        if (animalName == 'Kelinci') {
          return '🌾 Kelinci suka padang rumput karena ada banyak rumput segar untuk dimakan dan lubang-lubang untuk bersembunyi dari bahaya!';
        }
        return '🌾 Lapangan luas yang hijau penuh rumput. Enak banget buat lari-larian dan bermain kejar-kejaran!';

      case 'Rumah':
        if (animalName == 'Anjing') {
          return '🏠 Anjing adalah sahabat terbaik manusia! Di rumah, anjing dilindungi, diberi makan, dan bisa bermain dengan keluarga yang menyayanginya!';
        } else if (animalName == 'Laba-laba') {
          return '🏠 Laba-laba kecil suka tinggal di sudut-sudut rumah yang tenang. Mereka membuat jaring-jaring cantik untuk menangkap serangga kecil!';
        }
        return '🏠 Tempat tinggal kita yang hangat dan nyaman. Di sini ada keluarga yang sayang dan merawat kita!';


      case 'Peternakan':
        if (animalName == 'Ayam') {
          return '🚜 Ayam senang di peternakan karena ada kandang yang aman, makanan yang cukup setiap hari, dan bisa berkokok dengan bebas!';
        }
        return '🚜 Tempat yang ramai dengan kandang-kandang. Di sini ada paman dan bibi yang baik yang memberi makan setiap hari!';

      case 'Kutub':
        return '❄️ Tempat yang dingin banget dengan es dan salju putih. Brrr... butuh bulu tebal supaya tidak kedinginan!';

      case 'Gurun':
        return '🏜️ Tempat yang panas dan berpasir. Wah, harus pintar cari air dan tempat teduh di sini!';

      default:
        return '🌍 Tempat istimewa di mana aku suka tinggal dan bermain dengan teman-teman!';
    }
  }

  void resetQuiz() {
    animalToHabitatMap.clear();
    score.value = 0;
    isQuizCompleted.value = false;
    currentQuestionIndex.value = 0;
    currentAnimalHabitat.value = '';
    isAnswered.value = false;
    update(['quiz_body']);
  }

  void onBackPressed() {
    Get.back();
  }
}
