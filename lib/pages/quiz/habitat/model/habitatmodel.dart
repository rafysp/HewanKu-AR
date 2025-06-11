// pages/quiz/habitat/model/habitatmodel.dart
import 'package:flutter/material.dart';

class HabitatModel {
  final String name;
  final String imagePath;
  final Color color;
  final String? description;
  final IconData? icon;

  HabitatModel({
    required this.name,
    required this.imagePath,
    required this.color,
    this.description,
    this.icon,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imagePath': imagePath,
      'color': color.value,
      'description': description,
      'icon': icon?.codePoint,
    };
  }

  // Create from JSON
  factory HabitatModel.fromJson(Map<String, dynamic> json) {
    return HabitatModel(
      name: json['name'] ?? '',
      imagePath: json['imagePath'] ?? '',
      color: Color(json['color'] ?? Colors.grey.value),
      description: json['description'],
      icon: json['icon'] != null ? IconData(json['icon']) : null,
    );
  }

  // Copy with method for updates
  HabitatModel copyWith({
    String? name,
    String? imagePath,
    Color? color,
    String? description,
    IconData? icon,
  }) {
    return HabitatModel(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      color: color ?? this.color,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }

  @override
  String toString() {
    return 'HabitatModel(name: $name, imagePath: $imagePath, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HabitatModel &&
        other.name == name &&
        other.imagePath == imagePath &&
        other.color == color &&
        other.description == description &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        imagePath.hashCode ^
        color.hashCode ^
        description.hashCode ^
        icon.hashCode;
  }

  // Predefined habitat colors for consistency
  static const Map<String, Color> habitatColors = {
    'Hutan': Color.fromRGBO(76, 175, 80, 0.8),
    'Air': Color.fromRGBO(33, 150, 243, 0.8),
    'Padang Rumput': Color.fromRGBO(139, 195, 74, 0.8),
    'Rumah': Color.fromRGBO(233, 30, 99, 0.8),
    'Laut': Color.fromRGBO(0, 188, 212, 0.8),
    'Peternakan': Color.fromRGBO(121, 85, 72, 0.8),
    'Kutub': Color.fromRGBO(96, 125, 139, 0.8),
    'Gurun': Color.fromRGBO(255, 152, 0, 0.8),
  };

  // Predefined habitat icons
  static const Map<String, IconData> habitatIcons = {
    'Hutan': Icons.forest,
    'Air': Icons.water_drop,
    'Padang Rumput': Icons.grass,
    'Rumah': Icons.home,
    'Laut': Icons.water,
    'Peternakan': Icons.agriculture,
    'Kutub': Icons.ac_unit,
    'Gurun': Icons.wb_sunny,
  };

  // Factory method to create habitat with predefined colors and icons
  factory HabitatModel.withDefaults({
    required String name,
    required String imagePath,
    String? description,
  }) {
    return HabitatModel(
      name: name,
      imagePath: imagePath,
      color: habitatColors[name] ?? Colors.grey.withOpacity(0.8),
      description: description,
      icon: habitatIcons[name],
    );
  }
}