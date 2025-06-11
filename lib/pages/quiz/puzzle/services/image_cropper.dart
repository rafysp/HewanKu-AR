// services/image_cropper.dart - COMPLETE IMPLEMENTATION
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/pages/quiz/puzzle/model/puzzle_model.dart';

class ImageCropperService {
  static Future<ui.Image?> loadImageFromUrl(String url) async {
    try {
      // Fix double slash in URL
      String cleanUrl = url.replaceAll('//', '/').replaceFirst('http:/', 'http://').replaceFirst('https:/', 'https://');
      print('🔄 Loading image from: $url');
      print('🔧 Cleaned URL: $cleanUrl');
      
      // Download image from URL
      final response = await http.get(Uri.parse(cleanUrl)).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Image download timeout');
        },
      );
      
      print('📡 HTTP Status: ${response.statusCode}');
      print('📏 Content Length: ${response.contentLength}');
      print('📋 Headers: ${response.headers}');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
      
      if (response.bodyBytes.isEmpty) {
        throw Exception('Downloaded image is empty');
      }
      
      print('✅ Image downloaded: ${response.bodyBytes.length} bytes');
      
      // Convert bytes to ui.Image
      final codec = await ui.instantiateImageCodec(response.bodyBytes);
      final frame = await codec.getNextFrame();
      
      print('✅ Image decoded: ${frame.image.width}x${frame.image.height}');
      
      return frame.image;
    } catch (e) {
      print('❌ Error loading image: $e');
      return null;
    }
  }

  static Future<List<PuzzlePiece>> createPuzzlePieces({
    required ui.Image? image,
    required List<String> pieceNames,
    required List<String> pieceDescriptions,
    required String animalName,
  }) async {
    try {
      print('🧩 Creating puzzle pieces for $animalName');
      
      if (image == null) {
        print('⚠️ No image provided, creating text-only pieces');
        return _createTextOnlyPieces(
          pieceNames: pieceNames,
          pieceDescriptions: pieceDescriptions,
          animalName: animalName,
        );
      }

      print('🔄 Cropping image into 4 pieces...');
      List<PuzzlePiece> pieces = [];
      
      for (int i = 0; i < 4; i++) {
        int row = i ~/ 2; // 0,1 -> 0; 2,3 -> 1
        int col = i % 2;  // 0,2 -> 0; 1,3 -> 1
        
        print('📐 Cropping piece $i at row:$row, col:$col');
        
        // Crop image piece
        Uint8List? croppedBytes = await _cropImagePiece(image, row, col);
        
        if (croppedBytes != null) {
          print('✅ Piece $i cropped successfully: ${croppedBytes.length} bytes');
        } else {
          print('❌ Failed to crop piece $i');
        }
        
        final piece = PuzzlePiece(
          id: '${animalName}_piece_$i',
          pieceName: pieceNames[i],
          description: pieceDescriptions[i],
          animalName: animalName,
          correctPosition: i,
          croppedImageBytes: croppedBytes,
          isFixed: false,
          isPlaced: false,
          row: row,
          col: col,
        );
        
        pieces.add(piece);
      }
      
      print('✅ Created ${pieces.length} puzzle pieces');
      return pieces;
    } catch (e) {
      print('❌ Error creating puzzle pieces: $e');
      // Fallback to text-only pieces
      return _createTextOnlyPieces(
        pieceNames: pieceNames,
        pieceDescriptions: pieceDescriptions,
        animalName: animalName,
      );
    }
  }

  static Future<Uint8List?> _cropImagePiece(ui.Image image, int row, int col) async {
    try {
      // Calculate crop dimensions with proper bounds
      double pieceWidth = image.width / 2.0;
      double pieceHeight = image.height / 2.0;
      double srcX = col * pieceWidth;
      double srcY = row * pieceHeight;
      
      // Ensure we don't exceed image bounds
      if (srcX + pieceWidth > image.width) {
        pieceWidth = image.width - srcX;
      }
      if (srcY + pieceHeight > image.height) {
        pieceHeight = image.height - srcY;
      }
      
      print('📏 Image size: ${image.width}x${image.height}');
      print('📏 Piece size: ${pieceWidth.toInt()}x${pieceHeight.toInt()}');
      print('📏 Cropping from ($srcX,$srcY) size ${pieceWidth}x$pieceHeight');
      
      // Create picture recorder with exact dimensions
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      // Fill background with white to avoid transparency issues
      canvas.drawRect(
        Rect.fromLTWH(0, 0, pieceWidth, pieceHeight),
        Paint()..color = Colors.white,
      );
      
      // Create source and destination rectangles
      Rect srcRect = Rect.fromLTWH(srcX, srcY, pieceWidth, pieceHeight);
      Rect dstRect = Rect.fromLTWH(0, 0, pieceWidth, pieceHeight);
      
      // Draw the cropped portion
      canvas.drawImageRect(image, srcRect, dstRect, Paint()..filterQuality = FilterQuality.high);
      
      // Convert to image with proper dimensions
      final picture = recorder.endRecording();
      final croppedImage = await picture.toImage(
        pieceWidth.toInt(), 
        pieceHeight.toInt()
      );
      
      // Convert to bytes
      final byteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) {
        throw Exception('Failed to convert image to bytes');
      }
      
      print('✅ Piece cropped successfully: ${byteData.lengthInBytes} bytes');
      return byteData.buffer.asUint8List();
    } catch (e) {
      print('❌ Error cropping image piece at row:$row, col:$col - $e');
      return null;
    }
  }

  static List<PuzzlePiece> _createTextOnlyPieces({
    required List<String> pieceNames,
    required List<String> pieceDescriptions,
    required String animalName,
  }) {
    print('📝 Creating text-only pieces for $animalName');
    
    List<PuzzlePiece> pieces = [];
    
    for (int i = 0; i < 4; i++) {
      int row = i ~/ 2;
      int col = i % 2;
      
      final piece = PuzzlePiece(
        id: '${animalName}_text_$i',
        pieceName: i < pieceNames.length ? pieceNames[i] : 'Bagian ${i + 1}',
        description: i < pieceDescriptions.length ? pieceDescriptions[i] : 'Bagian tubuh hewan',
        animalName: animalName,
        correctPosition: i,
        croppedImageBytes: null, // No image data
        isFixed: false,
        isPlaced: false,
        row: row,
        col: col,
      );
      
      pieces.add(piece);
    }
    
    print('✅ Created ${pieces.length} text-only pieces');
    return pieces;
  }

  // Test method to verify URL accessibility
  static Future<bool> testImageUrl(String url) async {
    try {
      // Fix double slash in URL
      String cleanUrl = url.replaceAll('//', '/').replaceFirst('http:/', 'http://').replaceFirst('https:/', 'https://');
      print('🧪 Testing image URL: $url');
      print('🔧 Clean URL: $cleanUrl');
      
      final response = await http.head(Uri.parse(cleanUrl)).timeout(
        Duration(seconds: 5),
      );
      
      print('📡 HEAD Response: ${response.statusCode}');
      print('📋 Headers: ${response.headers}');
      
      bool isAccessible = response.statusCode == 200;
      print(isAccessible ? '✅ URL is accessible' : '❌ URL not accessible: ${response.statusCode}');
      
      return isAccessible;
    } catch (e) {
      print('❌ URL test failed: $e');
      return false;
    }
  }

  // Alternative: Load from assets if URL fails
  static Future<ui.Image?> loadImageFromAssets(String assetPath) async {
    try {
      print('📁 Loading image from assets: $assetPath');
      
      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List();
      
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      
      print('✅ Asset image loaded: ${frame.image.width}x${frame.image.height}');
      return frame.image;
    } catch (e) {
      print('❌ Error loading asset image: $e');
      return null;
    }
  }
} 