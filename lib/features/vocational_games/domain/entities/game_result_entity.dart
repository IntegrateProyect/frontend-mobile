class GameResultEntity {
  final String gameId;
  final int score;
  final DateTime completedAt;
  final Map<String, dynamic> feedback;

  GameResultEntity({
    required this.gameId,
    required this.score,
    required this.completedAt,
    required this.feedback,
  });
}
