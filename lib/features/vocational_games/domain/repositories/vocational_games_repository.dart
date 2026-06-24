import '../entities/game_entity.dart';
import '../entities/game_result_entity.dart';

abstract class VocationalGamesRepository {
  Future<List<GameEntity>> getAvailableGames();
  Future<void> submitGameResult(GameResultEntity result);
}
