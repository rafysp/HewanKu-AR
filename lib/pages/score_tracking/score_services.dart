import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'score_model.dart';

class ScoreService {
  static const String _scoresKey = 'hewanku_scores';
  static const String _playerNameKey = 'player_name';

  // Simpan score
  Future<void> saveScore(ScoreModel score) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Ambil scores yang ada
    List<ScoreModel> scores = await getAllScores();
    scores.add(score);
    
    // Urutkan berdasarkan tanggal (terbaru dulu)
    scores.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    
    // Batasi maksimal 50 score
    if (scores.length > 50) {
      scores = scores.take(50).toList();
    }
    
    // Simpan
    List<String> scoreStrings = scores.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(_scoresKey, scoreStrings);
  }

  // Ambil semua scores
  Future<List<ScoreModel>> getAllScores() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? scoreStrings = prefs.getStringList(_scoresKey);
    
    if (scoreStrings == null) return [];
    
    try {
      return scoreStrings
          .map((s) => ScoreModel.fromJson(jsonDecode(s)))
          .toList();
    } catch (e) {
      print('Error loading scores: $e');
      return [];
    }
  }

  // Player name methods
  Future<void> savePlayerName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_playerNameKey, name);
  }

  Future<String> getPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_playerNameKey) ?? 'Player';
  }

  // Delete all scores
  Future<void> deleteAllScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scoresKey);
  }
}
