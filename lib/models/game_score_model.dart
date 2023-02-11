/// Stores high score for a mini-game.
class GameScoreModel {
  final String gameId;
  int highScore;
  int totalPlays;
  int totalCoinsEarned;

  GameScoreModel({
    required this.gameId,
    this.highScore = 0,
    this.totalPlays = 0,
    this.totalCoinsEarned = 0,
  });

  /// Returns true if [score] is a new high score.
  bool submitScore(int score) {
    totalPlays++;
    if (score > highScore) {
      highScore = score;
      return true;
    }
    return false;
  }

  Map<String, dynamic> toMap() => {
        'gameId': gameId,
        'highScore': highScore,
        'totalPlays': totalPlays,
        'totalCoinsEarned': totalCoinsEarned,
      };

  factory GameScoreModel.fromMap(Map<dynamic, dynamic> map) => GameScoreModel(
        gameId: map['gameId'] as String,
        highScore: map['highScore'] as int? ?? 0,
        totalPlays: map['totalPlays'] as int? ?? 0,
        totalCoinsEarned: map['totalCoinsEarned'] as int? ?? 0,
      );
}
