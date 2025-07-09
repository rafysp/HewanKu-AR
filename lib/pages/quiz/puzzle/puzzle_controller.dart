// controllers/simple_puzzle_controller.dart - COMPLETELY FIXED VERSION WITH SCORE INTEGRATION
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/quiz/puzzle/model/puzzle_model.dart';
import 'package:flutter_application_2/pages/quiz/puzzle/services/image_cropper.dart';
import 'package:flutter_application_2/pages/score_tracking/score_controller.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

// Import score system

class SimplePuzzleController extends GetxController {
  // Score system integration
  late final ScoreController scoreController;

  // Timing untuk score calculation
  final RxInt startTime = 0.obs;
  final RxInt puzzleStartTime = 0.obs;
  final RxBool isScoreSaved = false.obs;

  // Observable variables
  final RxList<PuzzlePiece> allPieces = <PuzzlePiece>[].obs;
  final RxList<PuzzlePiece> availablePieces = <PuzzlePiece>[].obs;
  final RxList<PuzzlePiece?> gridPieces = <PuzzlePiece?>[].obs;
  final RxInt selectedPieceIndex = (-1).obs;
  final RxInt currentAnimalIndex = 0.obs;
  final RxInt score = 0.obs;
  final RxBool isPuzzleCompleted = false.obs;
  final RxBool isLoading = false.obs;
  final RxInt hintsUsed = 0.obs;

  // Score tracking untuk current session
  final RxInt correctPlacements = 0.obs;
  final RxInt totalAttempts = 0.obs;
  final RxInt incorrectAttempts = 0.obs;
  final RxInt globalTotalAttempts = 0.obs;
  final RxInt globalIncorrectAttempts = 0.obs;
  final RxInt globalCorrectPlacements = 0.obs;
  final RxInt puzzleTotalAttempts = 0.obs;
  final RxInt puzzleIncorrectAttempts = 0.obs;
  final RxInt puzzleCorrectPlacements = 0.obs;

  final RxInt globalHintsUsed = 0.obs;

  // Animal data - 15 hewan dari data vertebrata dan invertebrata
  final List<PuzzleAnimal> allAnimals = [
    // Vertebrata Animals
    PuzzleAnimal(
      name: 'Ayam',
      fullImagePath:
          'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image/chicken.png',
      sound: 'Kukuruyuk!',
      animalDescription:
          'Ayam adalah unggas yang sering dipelihara untuk diambil telur dan dagingnya.',
      themeColor: Colors.orange[600]!,
      learningFacts: [
        'Ayam dapat mengingat lebih dari 100 wajah manusia atau hewan',
        'Ayam jantan berkokok untuk menandai wilayah mereka',
        'Ayam dapat berlari dengan kecepatan hingga 14 km/jam',
      ],
      pieceNames: ['Kepala', 'Sayap', 'Badan', 'Kaki'],
      pieceDescriptions: [
        'Kepala ayam memiliki jengger dan paruh untuk mematuk makanan',
        'Sayap ayam pendek untuk terbang jarak dekat dan menjaga keseimbangan',
        'Badan ayam memiliki bulu yang menghangatkan dan melindungi tubuh',
        'Kaki ayam kuat dengan cakar untuk mencari makanan di tanah',
      ],
    ),
    PuzzleAnimal(
      name: 'Anjing',
      fullImagePath:
          'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image/dog.png',
      sound: 'Guk guk!',
      animalDescription:
          'Anjing adalah sahabat setia manusia yang cerdas dan mudah dilatih.',
      themeColor: Colors.brown,
      learningFacts: [
        'Anjing memiliki pendengaran yang sangat tajam',
        'Mereka dapat mengenali emosi manusia dari ekspresi wajah',
        'Anjing berkomunikasi dengan bahasa tubuh dan suara',
      ],
      pieceNames: ['Kepala', 'Telinga', 'Badan', 'Kaki'],
      pieceDescriptions: [
        'Di kepala anjing terdapat otak yang cerdas, mata untuk melihat, dan hidung untuk mencium',
        'Telinga anjing dapat mendengar suara dengan frekuensi tinggi yang tidak bisa didengar manusia',
        'Badan anjing kuat dan fleksibel, memungkinkan mereka berlari cepat dan melompat tinggi',
        'Kaki anjing memiliki bantalan yang membantu mereka berlari di berbagai permukaan',
      ],
    ),
    PuzzleAnimal(
      name: 'Kucing',
      fullImagePath:
          'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image/cat.png',
      sound: 'Meong!',
      animalDescription:
          'Kucing adalah hewan yang lincah dan mandiri dengan kemampuan berburu yang luar biasa.',
      themeColor: Colors.grey,
      learningFacts: [
        'Kucing memiliki penglihatan malam yang sangat baik',
        'Kumis kucing membantu mereka merasakan perubahan di sekitar',
        'Kucing dapat mendarat dengan aman dari ketinggian',
      ],
      pieceNames: ['Kepala', 'Kumis', 'Badan', 'Ekor'],
      pieceDescriptions: [
        'Kepala kucing memiliki mata yang besar untuk penglihatan malam dan telinga yang sensitif',
        'Kumis kucing adalah sensor yang membantu mereka menavigasi dalam gelap',
        'Badan kucing sangat fleksibel, memungkinkan mereka memutar dan melompat dengan lincah',
        'Ekor kucing membantu menjaga keseimbangan saat melompat dan mengekspresikan emosi',
      ],
    ),
    PuzzleAnimal(
      name: 'Katak',
      fullImagePath:
          'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image/frog.png',
      sound: 'Kroak kroak!',
      animalDescription:
          'Katak adalah amfibi yang dapat hidup di air dan di darat.',
      themeColor: Colors.green,
      learningFacts: [
        'Katak bernapas melalui kulit dan paru-paru',
        'Katak mengalami metamorfosis dari kecebong menjadi katak dewasa',
        'Lidah katak sangat panjang dan lengket untuk menangkap serangga',
      ],
      pieceNames: ['Kepala', 'Mata', 'Badan', 'Kaki'],
      pieceDescriptions: [
        'Kepala katak memiliki mata besar yang menonjol untuk melihat ke segala arah',
        'Mata katak dapat bergerak independen dan memiliki kelopak mata ketiga',
        'Badan katak licin dan lembap untuk membantu bernapas melalui kulit',
        'Kaki belakang katak kuat dan berselaput untuk melompat dan berenang',
      ],
    ),
    PuzzleAnimal(
      name: 'Iguana',
      fullImagePath:
          'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image/iguana.png',
      sound: 'Hiss!',
      animalDescription:
          'Iguana adalah reptil besar yang hidup di daerah tropis dan subtropis.',
      themeColor: Colors.green[700]!,
      learningFacts: [
        'Iguana dapat tumbuh hingga 1,5 meter panjangnya',
        'Iguana memiliki mata ketiga di atas kepala untuk mendeteksi bayangan',
        'Iguana adalah herbivora yang hanya makan tumbuhan',
      ],
      pieceNames: ['Kepala', 'Sisik', 'Badan', 'Ekor'],
      pieceDescriptions: [
        'Kepala iguana memiliki mata ketiga dan dapat mengubah warna untuk komunikasi',
        'Sisik iguana keras dan kuat melindungi tubuh dari predator dan cuaca',
        'Badan iguana besar dan kuat dengan otot yang berkembang untuk memanjat',
        'Ekor iguana panjang dan kuat, digunakan untuk keseimbangan dan pertahanan',
      ],
    ),
    PuzzleAnimal(
      name: 'Kelinci',
      fullImagePath:
          'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image/rabbit.png',
      sound: 'Bunyi kelinci!',
      animalDescription:
          'Kelinci adalah hewan herbivora yang cepat dan waspada terhadap bahaya.',
      themeColor: Colors.pink,
      learningFacts: [
        'Kelinci dapat melompat hingga 1 meter tingginya',
        'Mata kelinci dapat melihat hampir 360 derajat',
        'Gigi kelinci terus tumbuh sepanjang hidup mereka',
      ],
      pieceNames: ['Telinga', 'Mata', 'Badan', 'Kaki'],
      pieceDescriptions: [
        'Telinga panjang kelinci dapat berputar untuk mendengar suara dari berbagai arah',
        'Mata kelinci terletak di sisi kepala untuk melihat predator dari segala arah',
        'Badan kelinci berbulu halus yang membantu mengatur suhu tubuh',
        'Kaki belakang kelinci sangat kuat untuk melompat jauh dan cepat saat bahaya',
      ],
    ),
    PuzzleAnimal(
      name: 'Burung',
      fullImagePath:
          'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image/bird.png',
      sound: 'Tweet tweet!',
      animalDescription:
          'Burung adalah hewan yang dapat terbang dengan bulu dan sayap.',
      themeColor: Colors.lightBlue,
      learningFacts: [
        'Burung memiliki tulang yang berongga untuk memudahkan terbang',
        'Bulu burung memberikan isolasi dan membantu terbang',
        'Burung memiliki penglihatan yang sangat tajam',
      ],
      pieceNames: ['Kepala', 'Sayap', 'Badan', 'Kaki'],
      pieceDescriptions: [
        'Kepala burung memiliki paruh untuk makan dan mata tajam untuk terbang',
        'Sayap burung memiliki bulu khusus yang memungkinkan mereka terbang di udara',
        'Badan burung ringan dengan tulang berongga dan otot terbang yang kuat',
        'Kaki burung kuat untuk bertengger, berjalan, dan menangkap makanan',
      ],
    ),
    PuzzleAnimal(
      name: 'Kura-kura',
      fullImagePath:
          'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image/turtle.png',
      sound: 'Hiss!',
      animalDescription:
          'Kura-kura adalah reptil dengan cangkang keras yang hidup lama.',
      themeColor: Colors.green,
      learningFacts: [
        'Kura-kura dapat hidup hingga ratusan tahun',
        'Cangkang kura-kura terbuat dari tulang dan keratin',
        'Kura-kura dapat menarik kepala dan kaki ke dalam cangkang',
      ],
      pieceNames: ['Kepala', 'Cangkang', 'Badan', 'Kaki'],
      pieceDescriptions: [
        'Kepala kura-kura dapat ditarik masuk ke cangkang untuk perlindungan',
        'Cangkang kura-kura keras dan kuat melindungi organ dalam dari bahaya',
        'Badan kura-kura tersembunyi di dalam cangkang yang keras dan aman',
        'Kaki kura-kura pendek dan kuat, beberapa jenis memiliki kaki seperti dayung',
      ],
    ),
    PuzzleAnimal(
      name: 'Ikan Mas',
      fullImagePath:
          'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image/carp.png',
      sound: 'Blub blub!',
      animalDescription:
          'Ikan mas adalah ikan air tawar yang sering dipelihara sebagai hewan peliharaan.',
      themeColor: Colors.orange,
      learningFacts: [
        'Ikan mas dapat mengingat hal-hal hingga 3 bulan',
        'Ikan mas dapat hidup hingga 40 tahun',
        'Ikan mas dapat dilatih untuk melakukan trik sederhana',
      ],
      pieceNames: ['Kepala', 'Insang', 'Badan', 'Ekor'],
      pieceDescriptions: [
        'Kepala ikan mas memiliki mata dan mulut untuk melihat dan makan di dalam air',
        'Insang ikan mas menyaring oksigen dari air untuk bernapas',
        'Badan ikan mas ramping dan bersisik untuk bergerak cepat di dalam air',
        'Ekor ikan mas berfungsi sebagai pendorong utama untuk berenang',
      ],
    ),

    // Invertebrata Animals
    PuzzleAnimal(
      name: 'Kepiting Biru',
      fullImagePath:
          'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image/crab.png',
      sound: 'Click click!',
      animalDescription:
          'Kepiting biru adalah krustasea yang hidup di air asin dan payau.',
      themeColor: Colors.blue[600]!,
      learningFacts: [
        'Kepiting dapat berjalan ke samping karena struktur kakinya',
        'Kepiting dapat meregenerasi cakar yang putus',
        'Kepiting menggunakan cakar untuk berkomunikasi',
      ],
      pieceNames: ['Kepala', 'Cakar', 'Badan', 'Kaki'],
      pieceDescriptions: [
        'Kepala kepiting menyatu dengan dada dan memiliki mata bertangkai',
        'Cakar kepiting kuat untuk menangkap makanan dan melindungi diri',
        'Badan kepiting keras dilindungi cangkang yang kuat',
        'Kaki kepiting dapat bergerak ke samping dengan sangat lincah',
      ],
    ),
    PuzzleAnimal(
      name: 'Kerang',
      fullImagePath:
          'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image/clam.png',
      sound: 'Splash!',
      animalDescription:
          'Kerang adalah moluska yang hidup di dalam cangkang keras.',
      themeColor: Colors.brown[400]!,
      learningFacts: [
        'Kerang dapat hidup hingga 500 tahun',
        'Kerang menyaring air untuk mendapatkan makanan',
        'Beberapa kerang dapat menghasilkan mutiara',
      ],
      pieceNames: ['Cangkang', 'Lidah', 'Badan', 'Mutiara'],
      pieceDescriptions: [
        'Cangkang kerang keras melindungi tubuh lunak di dalamnya',
        'Lidah kerang digunakan untuk menyaring makanan dari air',
        'Badan kerang lunak dan tersembunyi dalam cangkang pelindung',
        'Mutiara terbentuk ketika benda asing masuk ke dalam kerang',
      ],
    ),
    PuzzleAnimal(
      name: 'Laba-laba',
      fullImagePath:
          'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image/spider.png',
      sound: 'Silent!',
      animalDescription:
          'Laba-laba adalah arakhnida yang membuat jaring untuk menangkap mangsa.',
      themeColor: Colors.black,
      learningFacts: [
        'Laba-laba memiliki 8 kaki dan 8 mata',
        'Jaring laba-laba 5 kali lebih kuat dari baja dengan ketebalan yang sama',
        'Laba-laba dapat merasakan getaran di jaring mereka',
      ],
      pieceNames: ['Kepala', 'Kaki', 'Badan', 'Jaring'],
      pieceDescriptions: [
        'Kepala laba-laba memiliki mata majemuk dan mulut dengan racun',
        'Kaki laba-laba berjumlah 8 dan sangat sensitif terhadap getaran',
        'Badan laba-laba memiliki kelenjar untuk memproduksi benang jaring',
        'Jaring laba-laba dibuat dari benang yang sangat kuat dan lengket',
      ],
    ),

    PuzzleAnimal(
      name: 'Spons',
      fullImagePath:
          'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image/sponge.png',
      sound: 'Bubble!',
      animalDescription:
          'Spons adalah hewan sederhana yang hidup menempel di dasar laut.',
      themeColor: Colors.yellow[700]!,
      learningFacts: [
        'Spons tidak memiliki organ atau jaringan khusus',
        'Spons menyaring air untuk mendapatkan makanan',
        'Spons dapat meregenerasi seluruh tubuhnya dari potongan kecil',
      ],
      pieceNames: ['Pori', 'Rongga', 'Badan', 'Filter'],
      pieceDescriptions: [
        'Pori-pori spons adalah lubang kecil tempat air masuk ke dalam tubuh',
        'Rongga spons adalah ruang di dalam tubuh tempat air mengalir',
        'Badan spons berpori dan fleksibel untuk menyaring air laut',
        'Filter spons menyaring partikel makanan dari air yang mengalir',
      ],
    ),
    PuzzleAnimal(
      name: 'Bintang Laut',
      fullImagePath:
          'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image/star.png',
      sound: 'Silent splash!',
      animalDescription:
          'Bintang laut adalah echinodermata yang hidup di dasar laut.',
      themeColor: Colors.red[400]!,
      learningFacts: [
        'Bintang laut dapat meregenerasi lengan yang putus',
        'Bintang laut tidak memiliki otak atau darah',
        'Bintang laut menggunakan kaki tabung untuk bergerak',
      ],
      pieceNames: ['Lengan', 'Mulut', 'Badan', 'Kaki Tabung'],
      pieceDescriptions: [
        'Lengan bintang laut biasanya berjumlah 5 dan dapat tumbuh kembali jika putus',
        'Mulut bintang laut terletak di bagian bawah tubuh untuk makan',
        'Badan bintang laut keras dan dilindungi kulit berduri',
        'Kaki tabung bintang laut membantu bergerak dan menangkap makanan',
      ],
    ),
    PuzzleAnimal(
      name: 'Cumi-cumi',
      fullImagePath:
          'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image/squid.png',
      sound: 'Swoosh!',
      animalDescription:
          'Cumi-cumi adalah moluska cephalopoda yang memiliki tentakel dan tubuh lunak.',
      themeColor: Colors.purple[600]!,
      learningFacts: [
        'Cumi-cumi dapat mengubah warna kulit untuk berkamuflase',
        'Cumi-cumi memiliki otak yang sangat cerdas',
        'Cumi-cumi dapat berenang cepat dengan mengeluarkan air dari tubuhnya',
      ],
      pieceNames: ['Kepala', 'Tentakel', 'Badan', 'Sirip'],
      pieceDescriptions: [
        'Kepala cumi-cumi memiliki mata besar dan mulut dengan paruh keras',
        'Tentakel cumi-cumi digunakan untuk menangkap mangsa dan bergerak',
        'Badan cumi-cumi lunak dan fleksibel, memungkinkan mereka berenang cepat',
        'Sirip cumi-cumi membantu mengarahkan saat berenang di dalam air',
      ],
    ),
  ];

  // Randomly selected animals for current session
  late List<PuzzleAnimal> animals;

  // Asset fallbacks for all animals
  final Map<String, String> assetFallbacks = {
    'Ayam': 'assets/images/chicken.png',
    'Anjing': 'assets/images/dog.png',
    'Kucing': 'assets/images/cat.png',
    'Katak': 'assets/images/frog.png',
    'Iguana': 'assets/images/iguana.png',
    'Kelinci': 'assets/images/rabbit.png',
    'Burung': 'assets/images/bird.png',
    'Kura-kura': 'assets/images/turtle.png',
    'Ikan Mas': 'assets/images/carp.png',
    'Kepiting Biru': 'assets/images/crab.png',
    'Kerang': 'assets/images/clam.png',
    'Laba-laba': 'assets/images/spider.png',
    'Cumi-cumi': 'assets/images/squid.png',
    'Spons': 'assets/images/sponge.png',
    'Bintang Laut': 'assets/images/star.png',
  };

  @override
  void onInit() {
    super.onInit();

    // Initialize score controller
    scoreController = Get.find<ScoreController>();

    // Record start time for overall session
    startTime.value = DateTime.now().millisecondsSinceEpoch;

    // Randomize animals selection every time controller is initialized
    _randomizeAnimals();

    // Initialize grid with safe values
    _initializeEmptyGrid();

    // Initialize score tracking
    _initializeScoreTracking();

    // Delay initialization to avoid build conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializePuzzle();
    });
  }

  void _initializeScoreTracking() {
    _initializePuzzleTracking(); // Hanya reset per-puzzle, bukan global
  }

  void _initializeGlobalTracking() {
    globalTotalAttempts.value = 0;
    globalIncorrectAttempts.value = 0;
    globalCorrectPlacements.value = 0;
    globalHintsUsed.value = 0;
  }

  void _initializePuzzleTracking() {
    puzzleTotalAttempts.value = 0;
    puzzleIncorrectAttempts.value = 0;
    puzzleCorrectPlacements.value = 0;
    puzzleStartTime.value = DateTime.now().millisecondsSinceEpoch;
  }

  void _randomizeAnimals() {
    try {
      print('🎲 Randomizing animals selection...');

      // Shuffle all animals
      List<PuzzleAnimal> shuffledAnimals = List.from(allAnimals);
      shuffledAnimals.shuffle();

      // Take first 5 animals for the puzzle session
      animals = shuffledAnimals.take(5).toList();

      print('🎯 Selected animals for this session:');
      for (int i = 0; i < animals.length; i++) {
        print('   ${i + 1}. ${animals[i].name}');
      }

      // Reset current index
      currentAnimalIndex.value = 0;
      score.value = 0;
    } catch (e) {
      print('❌ Error randomizing animals: $e');
      // Fallback to first 5 animals if randomization fails
      animals = allAnimals.take(5).toList();
    }
  }

  void _initializeEmptyGrid() {
    gridPieces.clear();
    for (int i = 0; i < 4; i++) {
      gridPieces.add(null);
    }
    print('Grid initialized with ${gridPieces.length} slots');
  }

  // ULTRA SAFE: Get grid piece with bounds checking
  PuzzlePiece? getGridPiece(int index) {
    if (index < 0 || index >= gridPieces.length) {
      print(
        'WARNING: getGridPiece called with invalid index: $index (grid length: ${gridPieces.length})',
      );
      return null;
    }
    return gridPieces[index];
  }

  // ULTRA SAFE: Set grid piece with bounds checking
  bool setGridPiece(int index, PuzzlePiece? piece) {
    if (index < 0 || index >= gridPieces.length) {
      print(
        'WARNING: setGridPiece called with invalid index: $index (grid length: ${gridPieces.length})',
      );
      return false;
    }
    gridPieces[index] = piece;
    return true;
  }

  // ULTRA SAFE: Get available piece with bounds checking
  PuzzlePiece? getAvailablePiece(int index) {
    if (index < 0 || index >= availablePieces.length) {
      print(
        'WARNING: getAvailablePiece called with invalid index: $index (available length: ${availablePieces.length})',
      );
      return null;
    }
    return availablePieces[index];
  }

  // ULTRA SAFE: Remove available piece with bounds checking
  bool removeAvailablePiece(int index) {
    if (index < 0 || index >= availablePieces.length) {
      print(
        'WARNING: removeAvailablePiece called with invalid index: $index (available length: ${availablePieces.length})',
      );
      return false;
    }
    availablePieces.removeAt(index);
    return true;
  }

  Future<void> initializePuzzle() async {
    try {
      print('Starting puzzle initialization...');

      // IMPORTANT: Clear any existing dialogs first
      _clearExistingDialogs();

      // Reset completion state
      isPuzzleCompleted.value = false;

      // Reset score tracking for new puzzle
      _initializeScoreTracking();

      isLoading.value = true;
      selectedPieceIndex.value = -1;

      // Validate animal index first
      if (currentAnimalIndex.value < 0 ||
          currentAnimalIndex.value >= animals.length) {
        print(
          'ERROR: Invalid animal index: ${currentAnimalIndex.value}, resetting to 0',
        );
        currentAnimalIndex.value = 0;
      }

      // ULTRA SAFE: Clear and reinitialize all arrays
      print('Clearing arrays...');
      availablePieces.clear();
      allPieces.clear();
      _initializeEmptyGrid();

      hintsUsed.value = 0;

      // Validate animals list
      if (animals.isEmpty) {
        throw Exception('Animals list is empty');
      }

      final currentAnimal = animals[currentAnimalIndex.value];
      print('Current animal: ${currentAnimal.name}');

      // Validate animal data
      if (currentAnimal.pieceNames.length != 4) {
        throw Exception(
          'Animal ${currentAnimal.name} does not have exactly 4 piece names (has ${currentAnimal.pieceNames.length})',
        );
      }

      if (currentAnimal.pieceDescriptions.length != 4) {
        throw Exception(
          'Animal ${currentAnimal.name} does not have exactly 4 piece descriptions (has ${currentAnimal.pieceDescriptions.length})',
        );
      }

      try {
        // Test URL accessibility first
        print('🧪 Testing URL accessibility...');
        bool urlAccessible = await ImageCropperService.testImageUrl(
          currentAnimal.fullImagePath,
        );

        ui.Image? fullImage;

        if (urlAccessible) {
          // Load from URL
          print('🌐 Loading image from URL...');
          fullImage = await ImageCropperService.loadImageFromUrl(
            currentAnimal.fullImagePath,
          ).timeout(
            Duration(seconds: 10),
            onTimeout: () {
              print('⏰ URL loading timeout');
              return null;
            },
          );
        }

        // Fallback to assets if URL failed
        if (fullImage == null &&
            assetFallbacks.containsKey(currentAnimal.name)) {
          print('📁 Falling back to assets...');
          fullImage = await ImageCropperService.loadImageFromAssets(
            assetFallbacks[currentAnimal.name]!,
          );
        }

        if (fullImage == null) {
          throw Exception('Failed to load image from both URL and assets');
        }

        // Create puzzle pieces with cropped images
        print('✂️ Creating puzzle pieces...');
        final pieces = await ImageCropperService.createPuzzlePieces(
          image: fullImage,
          pieceNames: currentAnimal.pieceNames,
          pieceDescriptions: currentAnimal.pieceDescriptions,
          animalName: currentAnimal.name,
        );

        // ULTRA SAFE: Validate pieces
        if (pieces == null || pieces.isEmpty) {
          throw Exception('No puzzle pieces were created');
        }

        if (pieces.length != 4) {
          throw Exception(
            'Invalid number of puzzle pieces created: ${pieces.length}, expected 4',
          );
        }

        // Check if any pieces have images
        int piecesWithImages = pieces.where((p) => p.hasImage).length;
        print('📊 Pieces with images: $piecesWithImages/4');

        // Validate each piece
        for (int i = 0; i < pieces.length; i++) {
          if (pieces[i] == null) {
            throw Exception('Piece $i is null');
          }
          if (pieces[i].pieceName.isEmpty) {
            throw Exception('Piece $i has empty name');
          }
          if (pieces[i].correctPosition < 0 || pieces[i].correctPosition >= 4) {
            throw Exception(
              'Piece $i has invalid position: ${pieces[i].correctPosition}',
            );
          }
        }

        print('✅ All pieces validated successfully');
        allPieces.addAll(pieces);

        _setupPuzzleGrid(pieces);
      } catch (imageError) {
        print('❌ Image loading failed: $imageError');
        print('📝 Falling back to text-only mode...');
        _createTextOnlyPuzzle(currentAnimal);
      }

      print('🧩 Puzzle initialized successfully for ${currentAnimal.name}');
      print('📝 Available pieces count: ${availablePieces.length}');
      print('📝 Grid setup complete');

      // Verify final state
      _verifyPuzzleState();

      await Future.delayed(Duration(milliseconds: 100));
      isLoading.value = false;
    } catch (e, stackTrace) {
      print('CRITICAL ERROR in puzzle initialization: $e');
      print('Stack trace: $stackTrace');
      isLoading.value = false;

      // Last resort fallback
      _createMinimalFallback();
      _showError('Menggunakan mode sederhana karena terjadi masalah teknis.');
    }
  }

  void _setupPuzzleGrid(List<PuzzlePiece> pieces) {
    print('Setting up puzzle grid...');

    // Always 2 missing pieces
    int missingCount = 2;
    print('Missing pieces count: $missingCount');

    // ULTRA SAFE: Create list of all positions and shuffle
    List<int> allIndices = [0, 1, 2, 3]; // All 4 positions
    allIndices.shuffle(); // Randomize the order

    // Take first 2 positions as missing (random selection)
    List<int> missingIndices = allIndices.take(missingCount).toList();

    print('🎲 Randomly selected missing positions: $missingIndices');
    print(
      '🔧 Fixed positions will be: ${allIndices.skip(missingCount).toList()}',
    );

    // ULTRA SAFE: Set up grid with explicit bounds checking
    List<PuzzlePiece> missing = [];
    List<PuzzlePiece> fixed = [];

    for (int i = 0; i < 4; i++) {
      if (i >= pieces.length) {
        print('ERROR: Not enough pieces for position $i');
        continue;
      }

      if (missingIndices.contains(i)) {
        // This position will be empty (missing piece)
        missing.add(pieces[i]);
        if (!setGridPiece(i, null)) {
          print('ERROR: Failed to set grid piece $i to null');
        }
        print('📍 Position $i: MISSING (${pieces[i].pieceName})');
      } else {
        // This position will be pre-filled (fixed piece)
        PuzzlePiece fixedPiece = pieces[i].copyWith(isFixed: true);
        fixed.add(fixedPiece);
        if (!setGridPiece(i, fixedPiece)) {
          print('ERROR: Failed to set grid piece $i to fixed piece');
        }
        print('🔒 Position $i: FIXED (${pieces[i].pieceName})');
      }
    }

    // ULTRA SAFE: Validate we have exactly 2 missing pieces
    if (missing.length != 2) {
      print('ERROR: Expected 2 missing pieces, got ${missing.length}');
      // Force exactly 2 missing pieces if something went wrong
      if (missing.isEmpty && pieces.isNotEmpty) {
        missing.add(pieces[0]);
        missing.add(pieces[1]);
        setGridPiece(0, null);
        setGridPiece(1, null);
        setGridPiece(2, pieces[2].copyWith(isFixed: true));
        setGridPiece(3, pieces[3].copyWith(isFixed: true));
      }
    }

    // Shuffle available pieces so they don't appear in order
    missing.shuffle();
    availablePieces.clear();
    availablePieces.addAll(missing);

    print(
      '✅ Grid setup complete: ${missing.length} missing pieces, ${fixed.length} fixed pieces',
    );
    print('🎯 Available pieces: ${missing.map((p) => p.pieceName).join(', ')}');
    print('🔒 Fixed pieces: ${fixed.map((p) => p.pieceName).join(', ')}');
  }

  void _createTextOnlyPuzzle(PuzzleAnimal animal) {
    print('Creating text-only puzzle for ${animal.name}...');

    allPieces.clear();
    availablePieces.clear();
    _initializeEmptyGrid();

    // Create basic puzzle pieces without images
    List<PuzzlePiece> pieces = [];
    for (int i = 0; i < 4; i++) {
      // Calculate row and col from position (0-3 -> 2x2 grid)
      int row = i ~/ 2; // Integer division: 0,1 -> 0; 2,3 -> 1
      int col = i % 2; // Modulo: 0,2 -> 0; 1,3 -> 1

      final piece = PuzzlePiece(
        id: 'text_${animal.name}_$i',
        pieceName: animal.pieceNames[i],
        description: animal.pieceDescriptions[i],
        animalName: animal.name,
        correctPosition: i,
        croppedImageBytes: null, // No image in text mode
        isFixed: false,
        isPlaced: false,
        row: row,
        col: col,
      );
      pieces.add(piece);
      allPieces.add(piece);
    }

    _setupPuzzleGrid(pieces);
    print('Text-only puzzle created');
  }

  void _createMinimalFallback() {
    print('Creating minimal fallback puzzle...');

    availablePieces.clear();
    allPieces.clear();
    _initializeEmptyGrid();

    // Get current animal safely
    PuzzleAnimal animal =
        animals.isNotEmpty
            ? animals[0]
            : allAnimals[0]; // Default to first animal
    if (currentAnimalIndex.value >= 0 &&
        currentAnimalIndex.value < animals.length) {
      animal = animals[currentAnimalIndex.value];
    }

    // Create all 4 pieces first
    List<PuzzlePiece> allFallbackPieces = [];
    for (int i = 0; i < 4; i++) {
      int row = i ~/ 2;
      int col = i % 2;

      final piece = PuzzlePiece(
        id: 'fallback_$i',
        pieceName:
            i < animal.pieceNames.length
                ? animal.pieceNames[i]
                : 'Bagian ${i + 1}',
        description:
            i < animal.pieceDescriptions.length
                ? animal.pieceDescriptions[i]
                : 'Bagian tubuh hewan',
        animalName: animal.name,
        correctPosition: i,
        croppedImageBytes: null,
        isFixed: false,
        isPlaced: false,
        row: row,
        col: col,
      );
      allFallbackPieces.add(piece);
      allPieces.add(piece);
    }

    // Randomly select 2 positions to be missing
    List<int> positions = [0, 1, 2, 3];
    positions.shuffle();
    List<int> missingPositions = positions.take(2).toList();
    List<int> fixedPositions = positions.skip(2).toList();

    print('🎲 Fallback missing positions: $missingPositions');
    print('🔒 Fallback fixed positions: $fixedPositions');

    // Set up available pieces (missing ones)
    for (int pos in missingPositions) {
      availablePieces.add(allFallbackPieces[pos]);
    }

    // Set up fixed pieces in grid
    for (int pos in fixedPositions) {
      final fixedPiece = allFallbackPieces[pos].copyWith(isFixed: true);
      setGridPiece(pos, fixedPiece);
    }

    // Shuffle available pieces
    availablePieces.shuffle();

    print(
      '✅ Minimal fallback created with ${availablePieces.length} available pieces',
    );
  }

  void _verifyPuzzleState() {
    print('Verifying puzzle state...');
    print('- Grid pieces: ${gridPieces.length}');
    print('- Available pieces: ${availablePieces.length}');
    print('- All pieces: ${allPieces.length}');

    // Check grid integrity
    for (int i = 0; i < gridPieces.length; i++) {
      final piece = getGridPiece(i);
      if (piece != null) {
        print('  Grid[$i]: ${piece.pieceName} (fixed: ${piece.isFixed})');
      } else {
        print('  Grid[$i]: empty');
      }
    }

    // Check available pieces
    for (int i = 0; i < availablePieces.length; i++) {
      final piece = getAvailablePiece(i);
      if (piece != null) {
        print('  Available[$i]: ${piece.pieceName}');
      }
    }
  }

  int _getMissingPiecesCount() {
    // Fixed: Always 2 missing pieces
    return 2;
  }

  PuzzleAnimal get currentAnimal {
    // Safe getter with bounds checking
    if (animals.isNotEmpty &&
        currentAnimalIndex.value >= 0 &&
        currentAnimalIndex.value < animals.length) {
      return animals[currentAnimalIndex.value];
    }
    print(
      'Warning: Invalid animal index ${currentAnimalIndex.value}, returning first animal',
    );
    return animals.isNotEmpty ? animals.first : allAnimals.first;
  }

  String _getEfficiencyLevel(double efficiency) {
    if (efficiency >= 90) return "Master 🌟";
    if (efficiency >= 80) return "Expert 👏";
    if (efficiency >= 70) return "Good 👍";
    if (efficiency >= 60) return "Average 😊";
    return "Needs Practice 💪";
  }

  void _logEfficiencyState(String attemptType) {
    print('');
    print('═══════════════════════════════════════');
    print('📊 EFFICIENCY STATE - $attemptType');
    print('═══════════════════════════════════════');
    print('🎯 Current Performance:');
    print('   - Completed puzzles: ${score.value}/${animals.length}');
    print('   - Total attempts: ${totalAttempts.value}');
    print('   - Correct placements: ${correctPlacements.value}');
    print('   - Incorrect attempts: ${incorrectAttempts.value}');
    print('   - Hints used: ${hintsUsed.value}');

    if (totalAttempts.value > 0) {
      double efficiency = (correctPlacements.value / totalAttempts.value) * 100;
      double errorRate = (incorrectAttempts.value / totalAttempts.value) * 100;
      print('📈 Efficiency Metrics:');
      print('   - Success rate: ${efficiency.toStringAsFixed(1)}%');
      print('   - Error rate: ${errorRate.toStringAsFixed(1)}%');
      print('   - Efficiency level: ${_getEfficiencyLevel(efficiency)}');
    }
    print('═══════════════════════════════════════');
    print('');
  }

  void selectPiece(int index) {
    print('Attempting to select piece at index: $index');

    if (availablePieces.isEmpty) {
      print('Cannot select piece: availablePieces is empty');
      _showHint("Tidak ada bagian yang bisa dipilih!");
      return;
    }

    if (index < 0 || index >= availablePieces.length) {
      print(
        'Invalid piece selection: index $index, available pieces: ${availablePieces.length}',
      );
      _showHint("Pilihan tidak valid!");
      return;
    }

    // ULTRA SAFE: Verify piece exists before selecting
    final piece = getAvailablePiece(index);
    if (piece == null) {
      print('Selected piece is null at index $index');
      _showHint("Bagian tidak ditemukan!");
      return;
    }

    selectedPieceIndex.value = selectedPieceIndex.value == index ? -1 : index;
    print('Selected piece index: ${selectedPieceIndex.value}');
  }

  void placePiece(int gridPosition) {
    print('🎯 Attempting to place piece at grid position: $gridPosition');

    // ULTRA SAFE: Comprehensive validation
    if (selectedPieceIndex.value == -1) {
      _showHint("Pilih bagian hewan yang hilang terlebih dahulu!");
      return;
    }

    if (availablePieces.isEmpty) {
      print('Cannot place piece: availablePieces is empty');
      selectedPieceIndex.value = -1;
      _showHint("Tidak ada bagian yang bisa ditempatkan!");
      return;
    }

    if (selectedPieceIndex.value < 0 ||
        selectedPieceIndex.value >= availablePieces.length) {
      print(
        'Invalid selected piece index: ${selectedPieceIndex.value}, available: ${availablePieces.length}',
      );
      selectedPieceIndex.value = -1;
      _showHint("Bagian yang dipilih tidak valid!");
      return;
    }

    if (gridPosition < 0 || gridPosition >= 4) {
      print('Invalid grid position: $gridPosition');
      _showHint("Posisi tidak valid!");
      return;
    }

    try {
      // Get the selected piece first
      final selectedPiece = getAvailablePiece(selectedPieceIndex.value);
      if (selectedPiece == null) {
        print('Selected piece is null');
        selectedPieceIndex.value = -1;
        _showHint("Bagian yang dipilih tidak ditemukan!");
        return;
      }

      // Check if grid position is already occupied
      final existingPiece = getGridPiece(gridPosition);
      if (existingPiece != null) {
        // TYPE 1: OCCUPIED SPOT ATTEMPT - Count as inefficiency
        puzzleTotalAttempts.value++;
        globalTotalAttempts.value++;

        puzzleIncorrectAttempts.value++;
        globalIncorrectAttempts.value++;

        print('❌ OCCUPIED SPOT - Wrong attempt');
        print(
          '📊 Puzzle Stats: Total: ${puzzleTotalAttempts.value}, Wrong: ${puzzleIncorrectAttempts.value}',
        );
        print(
          '📊 Global Stats: Total: ${globalTotalAttempts.value}, Wrong: ${globalIncorrectAttempts.value}',
        );

        _showHint("Tempat sudah terisi! Pilih tempat yang kosong.");
        return;
      }

      // Track ALL placement attempts (BOTH per-puzzle AND global)
      puzzleTotalAttempts.value++;
      globalTotalAttempts.value++;

      // Check if placement is correct
      bool isCorrect = selectedPiece.correctPosition == gridPosition;

      print(
        '🔍 Placement: ${selectedPiece.pieceName} → Position $gridPosition (correct: ${selectedPiece.correctPosition})',
      );

      if (isCorrect) {
        // TYPE 2: CORRECT PLACEMENT - Progress the game
        puzzleCorrectPlacements.value++;
        globalCorrectPlacements.value++;

        print('✅ CORRECT PLACEMENT');
        print(
          '📊 Puzzle Progress: ${puzzleCorrectPlacements.value} correct placements',
        );
        print(
          '📊 Global Progress: ${globalCorrectPlacements.value} correct placements',
        );

        PuzzlePiece placedPiece = selectedPiece.copyWith(isPlaced: true);

        if (!setGridPiece(gridPosition, placedPiece)) {
          print('Failed to set grid piece');
          // Rollback counters if placement fails
          puzzleTotalAttempts.value--;
          globalTotalAttempts.value--;
          puzzleCorrectPlacements.value--;
          globalCorrectPlacements.value--;
          _showError('Gagal menempatkan bagian');
          return;
        }

        if (!removeAvailablePiece(selectedPieceIndex.value)) {
          print('Failed to remove available piece');
          // Rollback everything if removal fails
          setGridPiece(gridPosition, null);
          puzzleTotalAttempts.value--;
          globalTotalAttempts.value--;
          puzzleCorrectPlacements.value--;
          globalCorrectPlacements.value--;
          _showError('Gagal menghapus bagian dari daftar');
          return;
        }

        selectedPieceIndex.value = -1;
        _showCorrectFeedback(selectedPiece);

        // Check completion
        Future.delayed(Duration(milliseconds: 200), () {
          _checkPuzzleCompletion();
        });
      } else {
        // TYPE 3: WRONG POSITION ATTEMPT - Count as inefficiency
        puzzleIncorrectAttempts.value++;
        globalIncorrectAttempts.value++;

        print('❌ WRONG POSITION - Wrong attempt');
        print(
          '📊 Puzzle Stats: Total: ${puzzleTotalAttempts.value}, Wrong: ${puzzleIncorrectAttempts.value}',
        );
        print(
          '📊 Global Stats: Total: ${globalTotalAttempts.value}, Wrong: ${globalIncorrectAttempts.value}',
        );

        _showIncorrectFeedback(selectedPiece, gridPosition);
        selectedPieceIndex.value = -1;
      }

      // Log current efficiency after each attempt
      _logCurrentEfficiency();
    } catch (e) {
      print('❌ Error placing piece: $e');
      // Rollback counters on error
      if (puzzleTotalAttempts.value > 0) {
        puzzleTotalAttempts.value--;
        globalTotalAttempts.value--;
      }
      selectedPieceIndex.value = -1;
      _showError('Terjadi kesalahan saat menempatkan bagian.');
    }
  }

  void _showCorrectFeedback(PuzzlePiece piece) {
    Get.snackbar(
      '',
      '',
      titleText: Row(
        children: [
          Icon(Icons.celebration, color: Colors.white, size: 24),
          SizedBox(width: 8),
          Text(
            'Pintar sekali!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      messageText: Text(
        '${piece.pieceName} ${piece.animalName} sudah di tempat yang benar!\n${piece.description}',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      snackPosition: SnackPosition.TOP,
    );
  }

  void _showIncorrectFeedback(PuzzlePiece piece, int gridPosition) {
    try {
      String correctPieceName = 'bagian lain';

      // ULTRA SAFE: Get correct piece name
      final animal = currentAnimal;
      if (gridPosition >= 0 && gridPosition < animal.pieceNames.length) {
        correctPieceName = animal.pieceNames[gridPosition];
      }

      Get.snackbar(
        '',
        '',
        titleText: Row(
          children: [
            Icon(Icons.lightbulb, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'Coba lagi!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        messageText: Text(
          'Tempat itu untuk $correctPieceName. ${piece.pieceName} ada di tempat lain!',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print('Error showing incorrect feedback: $e');
    }
  }

  void _showHint(String message) {
    Get.snackbar(
      '',
      '',
      titleText: Row(
        children: [
          Icon(Icons.info, color: Colors.white, size: 24),
          SizedBox(width: 8),
          Text(
            'Petunjuk',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      messageText: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      snackPosition: SnackPosition.TOP,
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  void _checkPuzzleCompletion() {
    try {
      print(
        'Checking puzzle completion: ${availablePieces.length} pieces remaining',
      );

      if (availablePieces.isEmpty && !isPuzzleCompleted.value) {
        isPuzzleCompleted.value = true;
        score.value++;

        print('Puzzle completed! Score: ${score.value}');

        // Clear any existing dialogs before showing completion
        _clearExistingDialogs();

        // Add longer delay to ensure UI state is stable
        Future.delayed(Duration(milliseconds: 800), () {
          if (isPuzzleCompleted.value && availablePieces.isEmpty) {
            // Double check to avoid multiple dialogs
            _showCompletionDialog();
          }
        });
      }
    } catch (e) {
      print('Error checking puzzle completion: $e');
    }
  }

  int _calculateDisplayScore() {
    int baseScore = 70; // Base score for completion

    if (globalTotalAttempts.value == 0) return baseScore;

    // Efficiency calculation menggunakan global stats
    double efficiency =
        globalCorrectPlacements.value / globalTotalAttempts.value;
    int efficiencyScore = (efficiency * 30).round();

    // Penalty menggunakan global stats
    int hintPenalty = globalHintsUsed.value * 2;
    int excessAttemptsPenalty = _calculateExcessAttemptsPenalty();
    int timePenalty = _calculateTimePenalty();

    int finalScore = (baseScore +
            efficiencyScore -
            hintPenalty -
            excessAttemptsPenalty -
            timePenalty)
        .clamp(0, 100);

    print('📊 Global Efficiency Score Calculation:');
    print('   - Base completion score: $baseScore');
    print('   - Efficiency score: $efficiencyScore');
    print(
      '   - Global efficiency rate: ${(efficiency * 100).toStringAsFixed(1)}%',
    );
    print('   - Global hint penalty: -$hintPenalty');
    print('   - Final score: $finalScore/100');

    return finalScore;
  }

  int _calculateExcessAttemptsPenalty() {
    int expectedAttempts = globalCorrectPlacements.value;
    int actualAttempts = globalTotalAttempts.value;
    int excessAttempts = actualAttempts - expectedAttempts;

    if (excessAttempts <= 0) return 0;
    return (excessAttempts / 2).floor();
  }

  int _calculateTimePenalty() {
    int duration = getCurrentDuration();
    int expectedTime = score.value * 60; // 1 minute per puzzle

    if (duration <= expectedTime) return 0;

    // Penalty: 1 point per extra minute
    return ((duration - expectedTime) / 60).floor();
  }

  void _logCurrentEfficiency() {
    if (globalTotalAttempts.value == 0) return;

    double efficiency =
        (globalCorrectPlacements.value / globalTotalAttempts.value) * 100;
    String level = _getEfficiencyLevel(efficiency);

    print('📈 Global Efficiency: ${efficiency.toStringAsFixed(1)}% ($level)');
    print(
      '   Global Correct: ${globalCorrectPlacements.value}, Total: ${globalTotalAttempts.value}, Wrong: ${globalIncorrectAttempts.value}',
    );
  }

  // Calculate final score based on performance
  int _calculateFinalScore() {
    // Use the new efficiency-based calculation
    return _calculateDisplayScore();
  }

  // Save score to score system
  // REPLACE: Save score - Single save with protection
  Future<void> _saveScoreToSystem() async {
    if (isScoreSaved.value) {
      print('💾 Score already saved, skipping...');
      return;
    }

    try {
      isScoreSaved.value = true;

      int currentTime = DateTime.now().millisecondsSinceEpoch;
      int duration = ((currentTime - startTime.value) / 1000).round();

      print('💾 Saving puzzle score (GLOBAL TRACKING):');
      print('  - Completed puzzles: ${score.value}/${animals.length}');
      print('  - Global wrong attempts: ${globalIncorrectAttempts.value}');
      print('  - Global hints used: ${globalHintsUsed.value}');
      print('  - Global total attempts: ${globalTotalAttempts.value}');
      print('  - Duration: ${duration}s');

      await scoreController.saveScore(
        correctAnswers: score.value,
        totalQuestions: animals.length,
        category: 'Puzzle Hewan',
        quizType: 'Interactive Puzzle',
        duration: duration,
      );

      print('✅ Score saved successfully!');
    } catch (e) {
      print('❌ Error saving score: $e');
      isScoreSaved.value = false;
    }
  }

  void _showCompletionDialog() {
    // Make sure no other dialogs are open
    _clearExistingDialogs();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🎉✨', style: const TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              Text(
                'Hebat Sekali!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kamu sudah tahu semua bagian tubuh ${currentAnimal.name}!',
                style: TextStyle(fontSize: 16, color: Colors.green[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // SOLUSI 1: Gunakan Column untuk teks panjang
              Row(
                children: [
                  // TOMBOL KIRI: Main Lagi
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.until((route) => !Get.isDialogOpen!);
                        isPuzzleCompleted.value = false;
                        Future.delayed(Duration(milliseconds: 200), () {
                          resetCurrentPuzzle();
                        });
                      },
                      icon: Icon(Icons.refresh, color: Colors.white, size: 18),
                      label: const Text(
                        'Main Lagi',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // TOMBOL KANAN: Hewan Berikutnya dengan layout yang diperbaiki
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.until((route) => !Get.isDialogOpen!);
                        isPuzzleCompleted.value = false;
                        Future.delayed(Duration(milliseconds: 200), () {
                          if (currentAnimalIndex.value < animals.length - 1) {
                            nextPuzzle();
                          } else {
                            _showFinalCompletion();
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currentAnimalIndex.value < animals.length - 1
                                ? 'Hewan\nBerikutnya'
                                : 'Selesai',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.1, // Line height yang lebih rapat
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
      name: 'completion_dialog',
    );
  }

  void _showFinalCompletion() {
    if (!isScoreSaved.value) {
      _saveScoreToSystem();
    }

    // BENAR: Menggunakan GLOBAL tracking
    int finalScore = _calculateDisplayScore();
    double efficiency =
        globalTotalAttempts.value > 0
            ? (globalCorrectPlacements.value /
                globalTotalAttempts.value *
                100) // ← GLOBAL TRACKING
            : 100.0;
    int totalPiecesPlaced = globalCorrectPlacements.value; // ← GLOBAL TRACKING
    int expectedPieces = animals.length * 2;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🏆🎉', style: const TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              Text(
                'Semua Puzzle Selesai!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kamu berhasil menyelesaikan semua ${animals.length} puzzle hewan!',
                style: TextStyle(fontSize: 16, color: Colors.amber[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Container dengan statistik GLOBAL
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.amber[300]!, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'Analisis Performa Global:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                      ),
                    ),
                    SizedBox(height: 12),

                    // BENAR: Menggunakan GLOBAL tracking
                    _buildEfficiencyRow(
                      'Puzzle Selesai:',
                      '${score.value}/${animals.length} hewan 🎉',
                      Icons.check_circle,
                    ),
                    _buildEfficiencyRow(
                      'Percobaan Benar:',
                      '$totalPiecesPlaced/$expectedPieces bagian ✅',
                      Icons.extension,
                    ),
                    _buildEfficiencyRow(
                      'Total Coba:',
                      '${globalTotalAttempts.value} kali',
                      Icons.touch_app,
                    ), // ← GLOBAL
                    _buildEfficiencyRow(
                      'Percobaan Salah:',
                      '${globalIncorrectAttempts.value} kali',
                      Icons.error_outline,
                    ), // ← GLOBAL

                    _buildEfficiencyRow(
                      'Waktu Main:',
                      '${_formatDurationForKids(getCurrentDuration())}',
                      Icons.timer,
                    ),

                    Divider(color: Colors.amber[400], thickness: 2, height: 20),

                    // Performance level indicator
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getPerformanceColor(efficiency),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.emoji_events,
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Level: ${_getEfficiencyLevel(efficiency)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Skor Akhir: $finalScore/100',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      _getEfficiencyMessage(efficiency),
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.amber[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        Future.delayed(Duration(milliseconds: 100), () {
                          resetAllPuzzles();
                        });
                      },
                      icon: Icon(Icons.refresh, color: Colors.white),
                      label: const Text(
                        'Coba Lagi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        Future.delayed(Duration(milliseconds: 100), () {
                          Get.back();
                        });
                      },
                      icon: Icon(Icons.home, color: Colors.white),
                      label: const Text(
                        'Selesai',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
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

  Widget _buildEfficiencyRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.amber[700]),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.amber[700]),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.amber[800],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPerformanceColor(double efficiency) {
    if (efficiency >= 90) return Colors.green[600]!;
    if (efficiency >= 80) return Colors.blue[600]!;
    if (efficiency >= 70) return Colors.orange[600]!;
    if (efficiency >= 60) return Colors.amber[600]!;
    return Colors.red[600]!;
  }

  String _getEfficiencyMessage(double efficiency) {
    if (efficiency >= 90) return "Luar biasa! Kamu sangat pintar! 🌟⭐✨";
    if (efficiency >= 80) return "Hebat! Kamu hampir tidak salah! 👏🎉";
    if (efficiency >= 70) return "Bagus! Kamu bisa lebih baik lagi! 👍😊";
    if (efficiency >= 60) return "Baik! Terus berlatih ya! 😊📚";
    return "Semangat! Kamu pasti bisa! 💪🚀";
  }

  void showHint() {
    try {
      if (selectedPieceIndex.value >= 0 &&
          selectedPieceIndex.value < availablePieces.length &&
          availablePieces.isNotEmpty) {
        final selectedPiece = getAvailablePiece(selectedPieceIndex.value);
        if (selectedPiece == null) {
          _showHint("Bagian yang dipilih tidak ditemukan!");
          return;
        }

        int correctPosition = selectedPiece.correctPosition;
        if (correctPosition < 0 || correctPosition >= 4) {
          _showHint("Posisi bagian tidak valid!");
          return;
        }

        String hintMessage =
            "Petunjuk: ${selectedPiece.pieceName} cocok untuk posisi ${_getPositionName(correctPosition)}. ${selectedPiece.description}";
        _showHint(hintMessage);

        // Track hints in both counters
        hintsUsed.value++;
        globalHintsUsed.value++;
      } else {
        _showHint(
          "Pilih bagian tubuh terlebih dahulu untuk mendapat petunjuk!",
        );
      }
    } catch (e) {
      print('Error showing hint: $e');
      _showHint("Tidak dapat menampilkan petunjuk saat ini.");
    }
  }

  String _getPositionName(int position) {
    switch (position) {
      case 0:
        return "kiri atas";
      case 1:
        return "kanan atas";
      case 2:
        return "kiri bawah";
      case 3:
        return "kanan bawah";
      default:
        return "tidak diketahui";
    }
  }

  // Enhanced method to clear any existing dialogs
  void _clearExistingDialogs() {
    try {
      // Force close all dialogs
      while (Get.isDialogOpen == true) {
        Get.back();
      }

      // Alternative approach - close until we reach a route that isn't a dialog
      if (Get.isDialogOpen == true) {
        Get.until((route) => !Get.isDialogOpen!);
      }
    } catch (e) {
      print('Error clearing dialogs: $e');
    }
  }

  // Game control methods
  void nextPuzzle() {
    try {
      _clearExistingDialogs(); // Clear any existing dialogs first

      if (currentAnimalIndex.value < animals.length - 1) {
        currentAnimalIndex.value++;
        print('Moving to next puzzle: ${currentAnimalIndex.value}');
        initializePuzzle();
      } else {
        print('Already at last puzzle');
      }
    } catch (e) {
      print('Error in nextPuzzle: $e');
      _showError('Gagal melanjutkan ke puzzle berikutnya');
    }
  }

  void resetCurrentPuzzle() {
    try {
      _clearExistingDialogs();
      print('Resetting current puzzle (keeping global tracking)');

      // Reset hanya per-puzzle tracking
      _initializePuzzleTracking();

      initializePuzzle();
    } catch (e) {
      print('Error resetting puzzle: $e');
      _showError('Gagal mereset puzzle');
    }
  }

  void resetAllPuzzles() {
    try {
      _clearExistingDialogs();
      print('Resetting all puzzles with new randomization...');

      // Reset semua tracking termasuk global
      score.value = 0;
      _initializeGlobalTracking(); // Reset global tracking
      _initializePuzzleTracking(); // Reset per-puzzle tracking
      isScoreSaved.value = false;
      startTime.value = DateTime.now().millisecondsSinceEpoch;

      _randomizeAnimals();
      initializePuzzle();
    } catch (e) {
      print('Error resetting all puzzles: $e');
      _showError('Gagal mereset semua puzzle');
    }
  }

  String _formatDurationForKids(int seconds) {
    if (seconds < 60) {
      return '$seconds detik';
    } else if (seconds < 3600) {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      if (remainingSeconds == 0) {
        return '$minutes menit';
      } else {
        return '$minutes menit $remainingSeconds detik';
      }
    } else {
      int hours = seconds ~/ 3600;
      int remainingMinutes = (seconds % 3600) ~/ 60;
      return '$hours jam $remainingMinutes menit';
    }
  }

  void onBackPressed() {
    try {
      // Don't auto-save on back - only save on completion
      Get.back();
    } catch (e) {
      print('Error going back: $e');
    }
  }

  // Method to manually randomize animals (can be called from UI)
  void shuffleAnimals() {
    try {
      print('🎲 Manually shuffling animals...');

      // Reset score tracking
      score.value = 0;
      correctPlacements.value = 0;
      totalAttempts.value = 0;
      incorrectAttempts.value = 0;
      hintsUsed.value = 0;
      startTime.value = DateTime.now().millisecondsSinceEpoch;

      _randomizeAnimals();
      initializePuzzle();
    } catch (e) {
      print('Error shuffling animals: $e');
      _showError('Gagal mengacak hewan');
    }
  }

  // Method to get info about current animal selection
  String getAnimalSelectionInfo() {
    if (animals.isEmpty) return 'Tidak ada hewan dipilih';

    List<String> animalNames = animals.map((animal) => animal.name).toList();
    return 'Hewan sesi ini: ${animalNames.join(", ")}';
  }

  // ULTRA SAFE getter methods untuk UI
  String getGameTitle() {
    return 'Puzzle Hewan';
  }

  int getMissingPiecesCount() {
    try {
      return availablePieces.length;
    } catch (e) {
      print('Error getting missing pieces count: $e');
      return 0;
    }
  }

  // ULTRA SAFE: Additional helper methods for UI
  bool isValidGridPosition(int position) {
    return position >= 0 && position < gridPieces.length;
  }

  bool isValidAvailableIndex(int index) {
    return index >= 0 && index < availablePieces.length;
  }

  bool hasAvailablePieces() {
    return availablePieces.isNotEmpty;
  }

  bool isGridPositionEmpty(int position) {
    if (!isValidGridPosition(position)) return false;
    return getGridPiece(position) == null;
  }

  PuzzlePiece? getSafeSelectedPiece() {
    if (selectedPieceIndex.value >= 0 &&
        isValidAvailableIndex(selectedPieceIndex.value)) {
      return getAvailablePiece(selectedPieceIndex.value);
    }
    return null;
  }

  // Get total number of available animals
  int getTotalAnimalsCount() {
    return allAnimals.length;
  }

  // Get current session animals count
  int getSessionAnimalsCount() {
    return animals.length;
  }

  // Score system getter methods
  double getCurrentAccuracy() {
    if (globalTotalAttempts.value == 0) return 0.0;
    return (globalCorrectPlacements.value / globalTotalAttempts.value * 100);
  }

  String getScoreStatistics() {
    if (globalTotalAttempts.value == 0) {
      return 'Puzzle: ${score.value}/${animals.length} | Belum ada percobaan';
    }

    double efficiency =
        (globalCorrectPlacements.value / globalTotalAttempts.value) * 100;
    int currentScore = _calculateDisplayScore();

    return 'Puzzle: ${score.value}/${animals.length} | Efisiensi: ${efficiency.toStringAsFixed(1)}% | Salah: ${globalIncorrectAttempts.value} | Score: $currentScore';
  }

  String getDetailedStats() {
    if (globalTotalAttempts.value == 0) {
      return 'Belum ada percobaan';
    }

    double efficiency =
        (globalCorrectPlacements.value / globalTotalAttempts.value) * 100;
    return 'Global: ${globalTotalAttempts.value} attempts | ✅${globalCorrectPlacements.value} | ❌${globalIncorrectAttempts.value} | 💡${globalHintsUsed.value} | Efficiency: ${efficiency.toStringAsFixed(1)}%';
  }

  int getEstimatedScore() {
    return _calculateFinalScore();
  }

  // Method to manually save score (for testing or early exit)
  Future<void> saveCurrentScore() async {
    await _saveScoreToSystem();
  }

  // Method to get current game duration in seconds
  int getCurrentDuration() {
    return ((DateTime.now().millisecondsSinceEpoch - startTime.value) / 1000)
        .round();
  }

  // Method to get progress percentage
  double getProgress() {
    if (animals.isEmpty) return 0.0;
    return (currentAnimalIndex.value + (availablePieces.isEmpty ? 1 : 0)) /
        animals.length;
  }

  // Method to get detailed progress info
  String getProgressInfo() {
    int completed =
        currentAnimalIndex.value + (availablePieces.isEmpty ? 1 : 0);
    return '$completed/${animals.length} puzzle selesai';
  }

  @override
  void onClose() {
    // Don't auto-save when controller is disposed
    // Only save on explicit completion
    super.onClose();
  }
}
