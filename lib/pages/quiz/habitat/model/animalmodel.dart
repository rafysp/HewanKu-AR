// pages/quiz/habitat/model/animalmodel.dart
class AnimalModel {
  final String id;
  final String name;
  final String imagePath;
  final String habitatId;
  final String? description;

  AnimalModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.habitatId,
    this.description,
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
    );
  }

  // Copy with method for updates
  AnimalModel copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? habitatId,
    String? description,
  }) {
    return AnimalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      habitatId: habitatId ?? this.habitatId,
      description: description ?? this.description,
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
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        imagePath.hashCode ^
        habitatId.hashCode ^
        description.hashCode;
  }
}