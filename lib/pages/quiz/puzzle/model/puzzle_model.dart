// models/puzzle_model.dart - FIXED VERSION WITH GETTERS
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class PuzzlePiece {
  final String id;
  final String pieceName;
  final String description;
  final String animalName;
  final int correctPosition;
  final Uint8List? croppedImageBytes;
  final bool isFixed;
  final bool isPlaced;
  final int row;
  final int col;

  const PuzzlePiece({
    required this.id,
    required this.pieceName,
    required this.description,
    required this.animalName,
    required this.correctPosition,
    this.croppedImageBytes,
    this.isFixed = false,
    this.isPlaced = false,
    required this.row,
    required this.col,
  });

  // Getter for pieceImage - returns ImageProvider
  ImageProvider? get pieceImage {
    if (croppedImageBytes != null) {
      return MemoryImage(croppedImageBytes!);
    }
    return null;
  }

  // Getter for hasImage - check if piece has image data
  bool get hasImage => croppedImageBytes != null;

  // Getter for imageBytes - alias for croppedImageBytes
  Uint8List? get imageBytes => croppedImageBytes;

  // Future getter for ui.Image if needed
  Future<ui.Image?> get uiImage async {
    if (croppedImageBytes == null) return null;
    
    try {
      final codec = await ui.instantiateImageCodec(croppedImageBytes!);
      final frame = await codec.getNextFrame();
      return frame.image;
    } catch (e) {
      print('Error creating ui.Image: $e');
      return null;
    }
  }

  // Widget getter for displaying the piece image
  Widget get imageWidget {
    if (croppedImageBytes != null) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.memory(
          croppedImageBytes!,
          fit: BoxFit.cover, // Changed from BoxFit.cover to contain
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackWidget();
          },
        ),
      );
    }
    return _buildFallbackWidget();
  }

  // Fallback widget when no image is available
  Widget _buildFallbackWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getPieceIcon(),
            size: 32,
            color: Colors.grey[600],
          ),
          SizedBox(height: 4),
          Text(
            pieceName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Get appropriate icon based on piece name
  IconData _getPieceIcon() {
    String lowerName = pieceName.toLowerCase();
    
    if (lowerName.contains('kepala') || lowerName.contains('head')) {
      return Icons.face;
    } else if (lowerName.contains('mata') || lowerName.contains('eye')) {
      return Icons.visibility;
    } else if (lowerName.contains('telinga') || lowerName.contains('ear')) {
      return Icons.hearing;
    } else if (lowerName.contains('kumis') || lowerName.contains('whisker')) {
      return Icons.linear_scale;
    } else if (lowerName.contains('badan') || lowerName.contains('body')) {
      return Icons.fitness_center;
    } else if (lowerName.contains('kaki') || lowerName.contains('leg') || lowerName.contains('foot')) {
      return Icons.directions_walk;
    } else if (lowerName.contains('ekor') || lowerName.contains('tail')) {
      return Icons.timeline;
    } else {
      return Icons.pets;
    }
  }

  PuzzlePiece copyWith({
    String? id,
    String? pieceName,
    String? description,
    String? animalName,
    int? correctPosition,
    Uint8List? croppedImageBytes,
    bool? isFixed,
    bool? isPlaced,
    int? row,
    int? col,
  }) {
    return PuzzlePiece(
      id: id ?? this.id,
      pieceName: pieceName ?? this.pieceName,
      description: description ?? this.description,
      animalName: animalName ?? this.animalName,
      correctPosition: correctPosition ?? this.correctPosition,
      croppedImageBytes: croppedImageBytes ?? this.croppedImageBytes,
      isFixed: isFixed ?? this.isFixed,
      isPlaced: isPlaced ?? this.isPlaced,
      row: row ?? this.row,
      col: col ?? this.col,
    );
  }

  @override
  String toString() {
    return 'PuzzlePiece(id: $id, name: $pieceName, position: $correctPosition, hasImage: $hasImage)';
  }
}

class PuzzleAnimal {
  final String name;
  final String fullImagePath;
  final String sound;
  final String animalDescription;
  final Color themeColor;
  final List<String> learningFacts;
  final List<String> pieceNames;
  final List<String> pieceDescriptions;

  const PuzzleAnimal({
    required this.name,
    required this.fullImagePath,
    required this.sound,
    required this.animalDescription,
    required this.themeColor,
    required this.learningFacts,
    required this.pieceNames,
    required this.pieceDescriptions,
  });
}