// pages/quiz/habitat/model/habitatmodel.dart
import 'package:flutter/material.dart';

class HabitatModel {
  final String id;
  final String name;
  final String imagePath;
  final Color color;
  final String? description;
  final IconData? icon;
  final String? emoji;
  final String? simpleRule; // Aturan sederhana untuk anak berkebutuhan khusus

  HabitatModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.color,
    this.description,
    this.icon,
    this.emoji,
    this.simpleRule,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'color': color.value,
      'description': description,
      'icon': icon?.codePoint,
      'emoji': emoji,
      'simpleRule': simpleRule,
    };
  }

  // Create from JSON
  factory HabitatModel.fromJson(Map<String, dynamic> json) {
    return HabitatModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imagePath: json['imagePath'] ?? '',
      color: Color(json['color'] ?? Colors.grey.value),
      description: json['description'],
      icon: json['icon'] != null ? IconData(json['icon']) : null,
      emoji: json['emoji'],
      simpleRule: json['simpleRule'],
    );
  }

  // Copy with method for updates
  HabitatModel copyWith({
    String? id,
    String? name,
    String? imagePath,
    Color? color,
    String? description,
    IconData? icon,
    String? emoji,
    String? simpleRule,
  }) {
    return HabitatModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      color: color ?? this.color,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      emoji: emoji ?? this.emoji,
      simpleRule: simpleRule ?? this.simpleRule,
    );
  }

  @override
  String toString() {
    return 'HabitatModel(id: $id, name: $name, imagePath: $imagePath, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HabitatModel &&
        other.id == id &&
        other.name == name &&
        other.imagePath == imagePath &&
        other.color == color &&
        other.description == description &&
        other.icon == icon &&
        other.emoji == emoji &&
        other.simpleRule == simpleRule;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        imagePath.hashCode ^
        color.hashCode ^
        description.hashCode ^
        icon.hashCode ^
        emoji.hashCode ^
        simpleRule.hashCode;
  }

  // PREDEFINED COLORS UNTUK 3 HABITAT SEDERHANA
  static const Map<String, Color> habitatColors = {
    'Air': Color.fromRGBO(33, 150, 243, 0.8), // Biru
    'Rumah': Color.fromRGBO(233, 30, 99, 0.8), // Pink
    'Alam': Color.fromRGBO(76, 175, 80, 0.8), // Hijau
    
    // Legacy colors untuk backward compatibility
    'Hutan': Color.fromRGBO(76, 175, 80, 0.8),
    'Padang Rumput': Color.fromRGBO(139, 195, 74, 0.8),
    'Laut': Color.fromRGBO(0, 188, 212, 0.8),
    'Peternakan': Color.fromRGBO(121, 85, 72, 0.8),
    'Kutub': Color.fromRGBO(96, 125, 139, 0.8),
    'Gurun': Color.fromRGBO(255, 152, 0, 0.8),
  };

  // PREDEFINED ICONS UNTUK 3 HABITAT SEDERHANA
  static const Map<String, IconData> habitatIcons = {
    'Air': Icons.water_drop,
    'Rumah': Icons.home,
    'Alam': Icons.forest,
    
    // Legacy icons untuk backward compatibility
    'Hutan': Icons.forest,
    'Padang Rumput': Icons.grass,
    'Laut': Icons.water,
    'Peternakan': Icons.agriculture,
    'Kutub': Icons.ac_unit,
    'Gurun': Icons.wb_sunny,
  };

  // EMOJI UNTUK 3 HABITAT SEDERHANA
  static const Map<String, String> habitatEmojis = {
    'Air': '💧',
    'Rumah': '🏠',
    'Alam': '🌳',
    
    // Legacy emojis
    'Hutan': '🌳',
    'Padang Rumput': '🌾',
    'Laut': '🌊',
    'Peternakan': '🚜',
    'Kutub': '🧊',
    'Gurun': '🏜️',
  };

  // ATURAN SEDERHANA UNTUK ANAK BERKEBUTUHAN KHUSUS
  static const Map<String, String> habitatSimpleRules = {
    'Air': 'Kalau bisa berenang → Air',
    'Rumah': 'Kalau dipelihara di rumah → Rumah',
    'Alam': 'Kalau hidup bebas di darat → Alam',
    
    // Legacy rules
    'Hutan': 'Kalau hidup bebas di hutan → Hutan',
    'Padang Rumput': 'Kalau hidup di padang rumput → Padang Rumput',
    'Laut': 'Kalau hidup di laut → Laut',
    'Peternakan': 'Kalau dipelihara di peternakan → Peternakan',
    'Kutub': 'Kalau hidup di kutub → Kutub',
    'Gurun': 'Kalau hidup di gurun → Gurun',
  };

  // DESKRIPSI HABITAT UNTUK ANAK-ANAK
  static const Map<String, String> habitatDescriptions = {
    'Air': 'Tempat untuk semua hewan yang bisa berenang dan hidup di air. Seperti sungai, danau, kolam, atau laut.',
    'Rumah': 'Tempat untuk semua hewan yang dipelihara dan dirawat oleh manusia di rumah atau sekitar rumah.',
    'Alam': 'Tempat untuk semua hewan yang hidup bebas di darat, seperti di hutan, padang rumput, atau gunung.',
    
    // Legacy descriptions
    'Hutan': 'Tempat yang sejuk dengan pohon-pohon tinggi dan rindang. Di sini banyak binatang bermain dan mencari makan!',
    'Padang Rumput': 'Lapangan luas yang hijau penuh rumput. Enak banget buat lari-larian dan bermain kejar-kejaran!',
    'Laut': 'Tempat yang luas dengan air asin. Banyak ikan dan makhluk laut yang cantik!',
    'Peternakan': 'Tempat yang ramai dengan kandang-kandang. Di sini ada paman dan bibi yang baik yang memberi makan setiap hari!',
    'Kutub': 'Tempat yang sangat dingin dengan es dan salju. Brrr... dingin sekali!',
    'Gurun': 'Tempat yang panas dan kering dengan pasir. Panasnya seperti sedang di bawah sinar matahari terik!',
  };

  // Factory method untuk membuat habitat dengan predefined values
  factory HabitatModel.withDefaults({
    required String name,
    required String imagePath,
    String? customDescription,
  }) {
    return HabitatModel(
      id: name.toLowerCase().replaceAll(' ', '_'),
      name: name,
      imagePath: imagePath,
      color: habitatColors[name] ?? Colors.grey.withOpacity(0.8),
      description: customDescription ?? habitatDescriptions[name],
      icon: habitatIcons[name],
      emoji: habitatEmojis[name],
      simpleRule: habitatSimpleRules[name],
    );
  }

  // Factory method untuk membuat 3 habitat sederhana
  static List<HabitatModel> createSimpleHabitats() {
    return [
      HabitatModel.withDefaults(
        name: 'Air',
        imagePath: 'assets/habitats/water.png',
      ),
      HabitatModel.withDefaults(
        name: 'Rumah',
        imagePath: 'assets/habitats/house.png',
      ),
      HabitatModel.withDefaults(
        name: 'Alam',
        imagePath: 'assets/habitats/nature.png',
      ),
    ];
  }

  // Factory method untuk membuat legacy habitats (backward compatibility)
  static List<HabitatModel> createLegacyHabitats() {
    return [
      HabitatModel.withDefaults(
        name: 'Hutan',
        imagePath: 'assets/habitats/forest.png',
      ),
      HabitatModel.withDefaults(
        name: 'Air',
        imagePath: 'assets/habitats/water.png',
      ),
      HabitatModel.withDefaults(
        name: 'Padang Rumput',
        imagePath: 'assets/habitats/grassland.png',
      ),
      HabitatModel.withDefaults(
        name: 'Rumah',
        imagePath: 'assets/habitats/house.png',
      ),
      HabitatModel.withDefaults(
        name: 'Peternakan',
        imagePath: 'assets/habitats/farm.png',
      ),
    ];
  }

  // Method untuk mendapatkan habitat berdasarkan ID
  static HabitatModel? getHabitatById(String id, {bool useSimpleHabitats = true}) {
    final habitats = useSimpleHabitats ? createSimpleHabitats() : createLegacyHabitats();
    try {
      return habitats.firstWhere((habitat) => habitat.id == id);
    } catch (e) {
      return null;
    }
  }

  // Method untuk mendapatkan habitat berdasarkan nama
  static HabitatModel? getHabitatByName(String name, {bool useSimpleHabitats = true}) {
    final habitats = useSimpleHabitats ? createSimpleHabitats() : createLegacyHabitats();
    try {
      return habitats.firstWhere((habitat) => habitat.name == name);
    } catch (e) {
      return null;
    }
  }

  // Method untuk validasi habitat
  bool isValidHabitat() {
    return name.isNotEmpty && 
           imagePath.isNotEmpty && 
           color != null &&
           icon != null &&
           emoji != null &&
           simpleRule != null;
  }

  // Method untuk mendapatkan kontras warna text
  Color getContrastTextColor() {
    // Hitung luminance dari warna background
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  // Method untuk mendapatkan warna yang lebih terang
  Color getLighterColor() {
    return Color.fromRGBO(
      (color.red + 50).clamp(0, 255),
      (color.green + 50).clamp(0, 255),
      (color.blue + 50).clamp(0, 255),
      color.opacity,
    );
  }

  // Method untuk mendapatkan warna yang lebih gelap
  Color getDarkerColor() {
    return Color.fromRGBO(
      (color.red - 50).clamp(0, 255),
      (color.green - 50).clamp(0, 255),
      (color.blue - 50).clamp(0, 255),
      color.opacity,
    );
  }
}