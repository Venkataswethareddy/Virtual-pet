import 'package:flutter/material.dart';
import '../models/game_score_model.dart';
import '../services/storage_service.dart';

/// Manages mini-game scores and coin rewards.
class GameProvider extends ChangeNotifier {
  final Map<String, GameScoreModel> _scores = {};

  GameScoreModel getScore(String gameId) {
    if (!_scores.containsKey(gameId)) {
      _scores[gameId] = StorageService.loadScore(gameId);
    }
    return _scores[gameId]!;
  }

  int highScore(String gameId) => getScore(gameId).highScore;
  int totalPlays(String gameId) => getScore(gameId).totalPlays;

  /// Submit a game result. Returns coins earned.
  Future<int> submitResult(String gameId, int score) async {
    final model = getScore(gameId);
    model.submitScore(score);

    // Coin calculation: 1 coin per 10 points, minimum 1
    final coins = (score / 10).ceil().clamp(1, 999);
    model.totalCoinsEarned += coins;

    await StorageService.saveScore(model);
    notifyListeners();
    return coins;
  }
}
