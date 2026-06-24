import '../../../domain/entities/game_entity.dart';
import '../../../domain/entities/game_result_entity.dart';
import '../models/game_model.dart';
import '../models/game_result_model.dart';

class GameMapper {
  static GameEntity toEntity(GameModel model) {
    return GameEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      imageUrl: model.imageUrl,
      type: model.type,
    );
  }

  static GameResultModel fromResultEntity(GameResultEntity entity) {
    return GameResultModel(
      gameId: entity.gameId,
      score: entity.score,
      completedAt: entity.completedAt,
      feedback: entity.feedback,
    );
  }
}
