// pages/quiz/habitat/model/animalmodel.dart
import 'package:flutter/material.dart';

class AnimalModel {
  final String id;
  final String name;
  final String imagePath;
  final String habitatId;
  final String? description;
  final String? hint; // Hint detail untuk membantu anak
  final String? simpleHint; // Hint sederhana dengan aturan dasar
  final List<String>? characteristics; // Karakteristik hewan
  final String? sound; // Suara hewan (untuk audio feedback)
  final String? movement; // Cara bergerak hewan
  final String? food; // Makanan hewan
  final String? funFact; // Fakta menarik tentang hewan

  AnimalModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.habitatId,
    this.description,
    this.hint,
    this.simpleHint,
    this.characteristics,
    this.sound,
    this.movement,
    this.food,
    this.funFact,
  });

  // For compatibility with existing quiz system
  String? get imageUrl => imagePath;
  String get questionText => "Di mana $name hidup?";

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'habitatId': habitatId,
      'description': description,
      'hint': hint,
      'simpleHint': simpleHint,
      'characteristics': characteristics,
      'sound': sound,
      'movement': movement,
      'food': food,
      'funFact': funFact,
    };
  }

  // Create from JSON
  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    return AnimalModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imagePath: json['imagePath'] ?? '',
      habitatId: json['habitatId'] ?? '',
      description: json['description'],
      hint: json['hint'],
      simpleHint: json['simpleHint'],
      characteristics: json['characteristics'] != null 
          ? List<String>.from(json['characteristics'])
          : null,
      sound: json['sound'],
      movement: json['movement'],
      food: json['food'],
      funFact: json['funFact'],
    );
  }

  // Copy with method for updates
  AnimalModel copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? habitatId,
    String? description,
    String? hint,
    String? simpleHint,
    List<String>? characteristics,
    String? sound,
    String? movement,
    String? food,
    String? funFact,
  }) {
    return AnimalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      habitatId: habitatId ?? this.habitatId,
      description: description ?? this.description,
      hint: hint ?? this.hint,
      simpleHint: simpleHint ?? this.simpleHint,
      characteristics: characteristics ?? this.characteristics,
      sound: sound ?? this.sound,
      movement: movement ?? this.movement,
      food: food ?? this.food,
      funFact: funFact ?? this.funFact,
    );
  }

  @override
  String toString() {
    return 'AnimalModel(id: $id, name: $name, imagePath: $imagePath, habitatId: $habitatId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimalModel &&
        other.id == id &&
        other.name == name &&
        other.imagePath == imagePath &&
        other.habitatId == habitatId &&
        other.description == description &&
        other.hint == hint &&
        other.simpleHint == simpleHint;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        imagePath.hashCode ^
        habitatId.hashCode ^
        description.hashCode ^
        hint.hashCode ^
        simpleHint.hashCode;
  }

  // Factory method untuk membuat animal dengan hint otomatis
  factory AnimalModel.withAutoHint({
    required String id,
    required String name,
    required String imagePath,
    required String habitatId,
    String? customHint,
    String? customSimpleHint,
    String? customDescription,
    List<String>? customCharacteristics,
    String? customSound,
    String? customMovement,
    String? customFood,
    String? customFunFact,
  }) {
    return AnimalModel(
      id: id,
      name: name,
      imagePath: imagePath,
      habitatId: habitatId,
      description: customDescription ?? _generateDescription(name, habitatId),
      hint: customHint ?? _generateHint(name, habitatId),
      simpleHint: customSimpleHint ?? _generateSimpleHint(habitatId),
      characteristics: customCharacteristics ?? _generateCharacteristics(name),
      sound: customSound ?? _generateSound(name),
      movement: customMovement ?? _generateMovement(name),
      food: customFood ?? _generateFood(name),
      funFact: customFunFact ?? _generateFunFact(name),
    );
  }

  // Generate hint berdasarkan nama hewan dan habitat
  static String _generateHint(String animalName, String habitatId) {
    String lowerName = animalName.toLowerCase();
    
    switch (habitatId) {
      case 'Air':
        if (lowerName.contains('ikan')) {
          return 'Aku hidup di air dan bernapas dengan insang yang bisa menyaring oksigen dari air';
        } else if (lowerName.contains('katak')) {
          return 'Aku suka melompat dan berenang, kulitku harus selalu lembab agar tidak kering';
        } else if (lowerName.contains('kura-kura')) {
          return 'Aku punya cangkang keras untuk melindungi diri dan suka berenang pelan-pelan';
        } else if (lowerName.contains('kepiting')) {
          return 'Aku berjalan di dasar laut dengan capit yang kuat untuk melindungi diri';
        } else if (lowerName.contains('kerang')) {
          return 'Aku tinggal di dasar laut dalam cangkang yang keras dan menyaring air untuk makan';
        } else if (lowerName.contains('cumi')) {
          return 'Aku berenang di laut dengan tentakel yang lentur dan bisa menyemprotkan tinta';
        } else if (lowerName.contains('spons')) {
          return 'Aku hidup menempel di dasar laut seperti filter alami yang membersihkan air';
        } else if (lowerName.contains('bintang')) {
          return 'Aku berjalan pelan di dasar laut dengan kaki-kaki kecil dan bisa meregenerasi lengan';
        }
        return 'Aku hidup di air dan membutuhkan air untuk bernapas atau bergerak';

      case 'Rumah':
        if (lowerName.contains('anjing')) {
          return 'Aku sahabat terbaik manusia, suka bermain, menjaga rumah, dan setia pada keluarga';
        } else if (lowerName.contains('kucing')) {
          return 'Aku suka bermain, tidur di tempat hangat, dan dimanja oleh keluarga yang merawatku';
        } else if (lowerName.contains('ayam')) {
          return 'Aku berkokok di pagi hari untuk membangunkan keluarga dan bertelur setiap hari';
        }
        return 'Aku dipelihara di rumah dan dirawat dengan baik oleh keluarga manusia';

      case 'Alam':
        if (lowerName.contains('burung')) {
          return 'Aku terbang bebas di langit luas dan membuat sarang di pohon untuk bertelur';
        } else if (lowerName.contains('iguana')) {
          return 'Aku suka memanjat pohon tinggi dan berjemur di bawah sinar matahari hangat';
        } else if (lowerName.contains('kelinci')) {
          return 'Aku suka melompat-lompat di padang rumput dan makan rumput segar';
        } else if (lowerName.contains('laba')) {
          return 'Aku membuat jaring-jaring cantik di antara pohon untuk menangkap serangga kecil';
        }
        return 'Aku hidup bebas di alam dan mencari makanan sendiri tanpa bantuan manusia';

      default:
        return 'Aku hidup di tempat yang sesuai dengan kebutuhan hidupku';
    }
  }

  // Generate simple hint berdasarkan habitat
  static String _generateSimpleHint(String habitatId) {
    switch (habitatId) {
      case 'Air':
        return 'Kalau bisa berenang → Air 💧';
      case 'Rumah':
        return 'Kalau dipelihara di rumah → Rumah 🏠';
      case 'Alam':
        return 'Kalau hidup bebas di darat → Alam 🌳';
      default:
        return 'Pikirkan di mana hewan ini biasa hidup';
    }
  }

  // Generate description
  static String _generateDescription(String animalName, String habitatId) {
    String lowerName = animalName.toLowerCase();
    
    if (lowerName.contains('ikan')) {
      return 'Ikan adalah hewan air yang bernapas dengan insang dan berenang menggunakan sirip.';
    } else if (lowerName.contains('katak')) {
      return 'Katak adalah hewan amfibi yang bisa hidup di air dan di darat, suka tempat lembab.';
    } else if (lowerName.contains('anjing')) {
      return 'Anjing adalah hewan peliharaan yang setia dan suka bermain dengan manusia.';
    } else if (lowerName.contains('kucing')) {
      return 'Kucing adalah hewan peliharaan yang lincah dan suka bermain serta tidur.';
    } else if (lowerName.contains('burung')) {
      return 'Burung adalah hewan yang bisa terbang dan membuat sarang di pohon.';
    }
    
    return '$animalName adalah hewan yang hidup di habitat $habitatId.';
  }

  // Generate characteristics
  static List<String> _generateCharacteristics(String animalName) {
    String lowerName = animalName.toLowerCase();
    
    if (lowerName.contains('ikan')) {
      return ['Punya sirip', 'Bernapas dengan insang', 'Hidup di air', 'Bisa berenang'];
    } else if (lowerName.contains('katak')) {
      return ['Bisa melompat', 'Kulit lembab', 'Kaki seperti dayung', 'Suka air'];
    } else if (lowerName.contains('anjing')) {
      return ['Setia', 'Suka bermain', 'Menjaga rumah', 'Sahabat manusia'];
    } else if (lowerName.contains('kucing')) {
      return ['Lincah', 'Suka tidur', 'Bermain bola', 'Dimanja manusia'];
    } else if (lowerName.contains('burung')) {
      return ['Bisa terbang', 'Punya sayap', 'Membuat sarang', 'Berkicau'];
    }
    
    return ['Ciri khas $animalName'];
  }

  // Generate sound
  static String _generateSound(String animalName) {
    String lowerName = animalName.toLowerCase();
    
    if (lowerName.contains('anjing')) return 'Guk guk!';
    if (lowerName.contains('kucing')) return 'Meow!';
    if (lowerName.contains('ayam')) return 'Kukuruyuk!';
    if (lowerName.contains('katak')) return 'Kroak kroak!';
    if (lowerName.contains('burung')) return 'Cit cit!';
    
    return 'Suara $animalName';
  }

  // Generate movement
  static String _generateMovement(String animalName) {
    String lowerName = animalName.toLowerCase();
    
    if (lowerName.contains('ikan')) return 'Berenang';
    if (lowerName.contains('katak')) return 'Melompat';
    if (lowerName.contains('anjing')) return 'Berlari';
    if (lowerName.contains('kucing')) return 'Berjalan pelan';
    if (lowerName.contains('burung')) return 'Terbang';
    if (lowerName.contains('kelinci')) return 'Melompat';
    if (lowerName.contains('kepiting')) return 'Berjalan menyamping';
    
    return 'Bergerak';
  }

  // Generate food
  static String _generateFood(String animalName) {
    String lowerName = animalName.toLowerCase();
    
    if (lowerName.contains('ikan')) return 'Plankton, cacing';
    if (lowerName.contains('katak')) return 'Serangga, cacing';
    if (lowerName.contains('anjing')) return 'Daging, dog food';
    if (lowerName.contains('kucing')) return 'Ikan, cat food';
    if (lowerName.contains('ayam')) return 'Biji-bijian, cacing';
    if (lowerName.contains('burung')) return 'Biji-bijian, serangga';
    if (lowerName.contains('kelinci')) return 'Rumput, wortel';
    if (lowerName.contains('iguana')) return 'Daun, buah';
    
    return 'Makanan $animalName';
  }

  // Generate fun fact
  static String _generateFunFact(String animalName) {
    String lowerName = animalName.toLowerCase();
    
    if (lowerName.contains('ikan')) return 'Ikan bisa tidur dengan mata terbuka!';
    if (lowerName.contains('katak')) return 'Katak menelan makanan dengan bantuan matanya!';
    if (lowerName.contains('anjing')) return 'Anjing punya penciuman 10,000 kali lebih kuat dari manusia!';
    if (lowerName.contains('kucing')) return 'Kucing punya 32 otot di setiap telinga!';
    if (lowerName.contains('ayam')) return 'Ayam bisa mengingat lebih dari 100 wajah!';
    if (lowerName.contains('burung')) return 'Burung bisa melihat warna lebih banyak dari manusia!';
    if (lowerName.contains('kelinci')) return 'Kelinci bisa melompat setinggi 1 meter!';
    if (lowerName.contains('bintang')) return 'Bintang laut bisa menumbuhkan kembali lengannya!';
    
    return '$animalName punya keunikan tersendiri!';
  }

  // Method untuk mendapatkan hint berdasarkan level
  String getHintByLevel(int level) {
    switch (level) {
      case 1:
        return hint ?? 'Coba pikirkan ciri-ciri hewan ini...';
      case 2:
        return simpleHint ?? 'Gunakan aturan sederhana untuk habitat';
      case 3:
        return 'Jawabannya adalah: $habitatId';
      default:
        return 'Pikirkan di mana $name biasa hidup...';
    }
  }

  // Method untuk mendapatkan emoji sesuai habitat
  String getHabitatEmoji() {
    switch (habitatId) {
      case 'Air':
        return '💧';
      case 'Rumah':
        return '🏠';
      case 'Alam':
        return '🌳';
      default:
        return '🌍';
    }
  }

  // Method untuk mendapatkan warna sesuai habitat
  Color getHabitatColor() {
    switch (habitatId) {
      case 'Air':
        return Colors.blue.withOpacity(0.8);
      case 'Rumah':
        return Colors.pink.withOpacity(0.8);
      case 'Alam':
        return Colors.green.withOpacity(0.8);
      default:
        return Colors.grey.withOpacity(0.8);
    }
  }

  // Method untuk validate apakah animal memiliki hint yang valid
  bool hasValidHints() {
    return hint != null && hint!.isNotEmpty && 
           simpleHint != null && simpleHint!.isNotEmpty;
  }

  // Method untuk mendapatkan karakteristik sebagai string
  String getCharacteristicsString() {
    if (characteristics == null || characteristics!.isEmpty) {
      return 'Tidak ada karakteristik khusus';
    }
    return characteristics!.join(', ');
  }

  // Method untuk mendapatkan detail lengkap hewan
  String getDetailedInfo() {
    StringBuffer info = StringBuffer();
    
    info.writeln('🐾 $name');
    info.writeln('🏠 Habitat: $habitatId');
    
    if (description != null) {
      info.writeln('📝 Deskripsi: $description');
    }
    
    if (characteristics != null && characteristics!.isNotEmpty) {
      info.writeln('✨ Ciri-ciri: ${getCharacteristicsString()}');
    }
    
    if (sound != null) {
      info.writeln('🔊 Suara: $sound');
    }
    
    if (movement != null) {
      info.writeln('🏃 Gerakan: $movement');
    }
    
    if (food != null) {
      info.writeln('🍽️ Makanan: $food');
    }
    
    if (funFact != null) {
      info.writeln('🎯 Fakta Menarik: $funFact');
    }
    
    return info.toString();
  }

  // Method untuk mendapatkan difficulty level berdasarkan nama hewan
  int getDifficultyLevel() {
    String lowerName = name.toLowerCase();
    
    // Level 1: Sangat mudah (hewan peliharaan)
    if (lowerName.contains('anjing') || 
        lowerName.contains('kucing') || 
        lowerName.contains('ayam')) {
      return 1;
    }
    
    // Level 2: Mudah (hewan umum)
    if (lowerName.contains('ikan') || 
        lowerName.contains('katak') || 
        lowerName.contains('burung') || 
        lowerName.contains('kelinci')) {
      return 2;
    }
    
    // Level 3: Sedang (hewan laut/eksotis)
    if (lowerName.contains('iguana') || 
        lowerName.contains('kepiting') || 
        lowerName.contains('kura-kura') || 
        lowerName.contains('laba')) {
      return 3;
    }
    
    // Level 4: Sulit (hewan laut dalam)
    if (lowerName.contains('cumi') || 
        lowerName.contains('spons') || 
        lowerName.contains('bintang') || 
        lowerName.contains('kerang')) {
      return 4;
    }
    
    return 2; // Default medium
  }

  // Method untuk mendapatkan age recommendation
  String getAgeRecommendation() {
    int difficulty = getDifficultyLevel();
    
    switch (difficulty) {
      case 1:
        return '3-5 tahun';
      case 2:
        return '4-7 tahun';
      case 3:
        return '6-9 tahun';
      case 4:
        return '8+ tahun';
      default:
        return '5-8 tahun';
    }
  }

  // Method untuk cek apakah hewan cocok untuk anak berkebutuhan khusus
  bool isSuitableForSpecialNeeds() {
    // Hewan yang mudah dikenali dan tidak menakutkan
    String lowerName = name.toLowerCase();
    
    List<String> suitableAnimals = [
      'anjing', 'kucing', 'ayam', 'ikan', 'katak', 
      'burung', 'kelinci', 'kura-kura'
    ];
    
    return suitableAnimals.any((animal) => lowerName.contains(animal));
  }

  // Method untuk mendapatkan learning objectives
  List<String> getLearningObjectives() {
    List<String> objectives = [];
    
    // Basic objectives untuk semua hewan
    objectives.add('Mengenali nama hewan $name');
    objectives.add('Memahami habitat $habitatId');
    objectives.add('Menerapkan aturan sederhana habitat');
    
    // Specific objectives berdasarkan habitat
    switch (habitatId) {
      case 'Air':
        objectives.add('Memahami konsep "hidup di air"');
        objectives.add('Mengenali ciri-ciri hewan air');
        break;
      case 'Rumah':
        objectives.add('Memahami konsep "hewan peliharaan"');
        objectives.add('Mengenali manfaat hewan peliharaan');
        break;
      case 'Alam':
        objectives.add('Memahami konsep "hidup bebas"');
        objectives.add('Mengenali hewan liar yang tidak berbahaya');
        break;
    }
    
    return objectives;
  }

  // Method untuk mendapatkan related animals (hewan sejenis)
  List<String> getRelatedAnimals() {
    String lowerName = name.toLowerCase();
    
    if (lowerName.contains('ikan')) {
      return ['Ikan Lele', 'Ikan Nila', 'Ikan Patin'];
    } else if (lowerName.contains('katak')) {
      return ['Kodok', 'Katak Hijau', 'Katak Pohon'];
    } else if (lowerName.contains('anjing')) {
      return ['Kucing', 'Hamster', 'Kelinci Peliharaan'];
    } else if (lowerName.contains('burung')) {
      return ['Merpati', 'Burung Pipit', 'Burung Hantu'];
    }
    
    return [];
  }

  // Method untuk mendapatkan quiz questions
  List<String> generateQuizQuestions() {
    List<String> questions = [];
    
    questions.add('Di mana $name hidup?');
    questions.add('Apa ciri khas $name?');
    questions.add('Bagaimana $name bergerak?');
    questions.add('Apa makanan $name?');
    
    if (sound != null) {
      questions.add('Bagaimana suara $name?');
    }
    
    return questions;
  }

  // Static method untuk create default animals dengan 3 habitat sederhana
  static List<AnimalModel> createDefaultAnimals() {
    return [
      // AIR (8 hewan)
      AnimalModel.withAutoHint(
        id: 'ikan_mas',
        name: 'Ikan Mas',
        imagePath: 'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//carp.png',
        habitatId: 'Air',
      ),
      AnimalModel.withAutoHint(
        id: 'katak',
        name: 'Katak',
        imagePath: 'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//frog.png',
        habitatId: 'Air',
      ),
      AnimalModel.withAutoHint(
        id: 'kura-kura',
        name: 'Kura-kura',
        imagePath: 'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//turtle.png',
        habitatId: 'Air',
      ),
      AnimalModel.withAutoHint(
        id: 'kepiting_biru',
        name: 'Kepiting Biru',
        imagePath: 'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//crab.png',
        habitatId: 'Air',
      ),
      AnimalModel.withAutoHint(
        id: 'kerang',
        name: 'Kerang',
        imagePath: 'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//kerang.png',
        habitatId: 'Air',
      ),
      AnimalModel.withAutoHint(
        id: 'cumi_cumi',
        name: 'Cumi-cumi',
        imagePath: 'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//squid.png',
        habitatId: 'Air',
      ),
      AnimalModel.withAutoHint(
        id: 'spons',
        name: 'Spons',
        imagePath: 'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//sponge.png',
        habitatId: 'Air',
      ),
      AnimalModel.withAutoHint(
        id: 'bintang_laut',
        name: 'Bintang Laut',
        imagePath: 'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//star.png',
        habitatId: 'Air',
      ),

      // RUMAH (3 hewan)
      AnimalModel.withAutoHint(
        id: 'anjing',
        name: 'Anjing',
        imagePath: 'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//dog.png',
        habitatId: 'Rumah',
      ),
      AnimalModel.withAutoHint(
        id: 'kucing',
        name: 'Kucing',
        imagePath: 'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//cat.png',
        habitatId: 'Rumah',
      ),
      AnimalModel.withAutoHint(
        id: 'ayam',
        name: 'Ayam',
        imagePath: 'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//chicken.png',
        habitatId: 'Rumah',
      ),

      // ALAM (4 hewan)
      AnimalModel.withAutoHint(
        id: 'burung',
        name: 'Burung',
        imagePath: 'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//bird.png',
        habitatId: 'Alam',
      ),
      AnimalModel.withAutoHint(
        id: 'iguana',
        name: 'Iguana',
        imagePath: 'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//iguana.png',
        habitatId: 'Alam',
      ),
      AnimalModel.withAutoHint(
        id: 'kelinci',
        name: 'Kelinci',
        imagePath: 'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//rabbit.png',
        habitatId: 'Alam',
      ),
      AnimalModel.withAutoHint(
        id: 'laba_laba',
        name: 'Laba-laba',
        imagePath: 'https://qrxebmffwenduztunlbk.supabase.co/storage/v1/object/public/Image//spider.png',
        habitatId: 'Alam',
      ),
    ];
  }

  // Static method untuk get animals by habitat
  static List<AnimalModel> getAnimalsByHabitat(String habitatId) {
    return createDefaultAnimals().where((animal) => animal.habitatId == habitatId).toList();
  }

  // Static method untuk get animals by difficulty
  static List<AnimalModel> getAnimalsByDifficulty(int difficulty) {
    return createDefaultAnimals().where((animal) => animal.getDifficultyLevel() == difficulty).toList();
  }

  // Static method untuk get animals suitable for special needs
  static List<AnimalModel> getAnimalsForSpecialNeeds() {
    return createDefaultAnimals().where((animal) => animal.isSuitableForSpecialNeeds()).toList();
  }

  // Static method untuk get animal by ID
  static AnimalModel? getAnimalById(String id) {
    try {
      return createDefaultAnimals().firstWhere((animal) => animal.id == id);
    } catch (e) {
      return null;
    }
  }

  // Static method untuk search animals by name
  static List<AnimalModel> searchAnimalsByName(String query) {
    if (query.isEmpty) return createDefaultAnimals();
    
    return createDefaultAnimals().where((animal) => 
      animal.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Method untuk validate animal data
  bool isValidAnimal() {
    return id.isNotEmpty && 
           name.isNotEmpty && 
           imagePath.isNotEmpty && 
           habitatId.isNotEmpty &&
           hasValidHints();
  }

  // Method untuk mendapatkan accessibility score (1-5)
  int getAccessibilityScore() {
    int score = 0;
    
    // Base score untuk required fields
    if (isValidAnimal()) score += 1;
    
    // Extra score untuk hint quality
    if (hint != null && hint!.length > 20) score += 1;
    if (simpleHint != null && simpleHint!.isNotEmpty) score += 1;
    
    // Extra score untuk additional info
    if (characteristics != null && characteristics!.isNotEmpty) score += 1;
    if (funFact != null && funFact!.isNotEmpty) score += 1;
    
    return score;
  }

  // Method untuk mendapatkan educational value score
  int getEducationalValueScore() {
    int score = getDifficultyLevel();
    
    // Bonus untuk hewan yang suitable untuk special needs
    if (isSuitableForSpecialNeeds()) score += 1;
    
    // Bonus untuk hewan dengan learning objectives yang lengkap
    if (getLearningObjectives().length >= 4) score += 1;
    
    return score.clamp(1, 5);
  }
}