import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

// Model Score dengan skala 0-100
class ScoreModel {
  final String id;
  final String playerName;
  final int correctAnswers;
  final int totalQuestions;
  final DateTime dateTime;
  final String category;
  final int duration;
  final String quizType;

  ScoreModel({
    String? id,
    required this.playerName,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.dateTime,
    required this.category,
    required this.duration,
    required this.quizType,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player_name': playerName,
      'correct_answers': correctAnswers,
      'total_questions': totalQuestions,
      'date_time': dateTime.toIso8601String(),
      'category': category,
      'duration': duration,
      'quiz_type': quizType,
    };
  }

  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      id: json['id'],
      playerName: json['player_name'] ?? 'Player',
      correctAnswers: json['correct_answers'] ?? 0,
      totalQuestions: json['total_questions'] ?? 1,
      dateTime: DateTime.parse(json['date_time']),
      category: json['category'] ?? 'Quiz',
      duration: json['duration'] ?? 0,
      quizType: json['quiz_type'] ?? 'Unknown',
    );
  }

  // Score dalam skala 0-100
  double get score => totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0.0;
  
  // Grade berdasarkan sistem Indonesia
  String get grade {
    if (score >= 90) return 'A'; // Sangat Baik
    if (score >= 80) return 'B'; // Baik
    if (score >= 70) return 'C'; // Cukup
    if (score >= 60) return 'D'; // Kurang
    return 'E'; // Sangat Kurang
  }

  // Predikat berdasarkan grade
  String get predicate {
    switch (grade) {
      case 'A': return 'Sangat Baik';
      case 'B': return 'Baik';
      case 'C': return 'Cukup';
      case 'D': return 'Kurang';
      default: return 'Sangat Kurang';
    }
  }
}