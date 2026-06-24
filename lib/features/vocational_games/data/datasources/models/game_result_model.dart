import '../../../domain/entities/game_result_entity.dart';

class GameResultModel extends GameResultEntity {
  GameResultModel({
    required super.gameId,
    required super.score,
    required super.completedAt,
    required super.feedback,
  });

  factory GameResultModel.fromJson(Map<String, dynamic> json) {
    return GameResultModel(
      gameId: json['gameId'] ?? '',
      score: json['score'] ?? 0,
      completedAt: DateTime.parse(json['completedAt']),
      feedback: Map<String, dynamic>.from(json['feedback'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'score': score,
      'completedAt': completedAt.toIso8601String(),
      'feedback': feedback,
    };
  }
}
