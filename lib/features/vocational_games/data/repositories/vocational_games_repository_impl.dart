import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_result_entity.dart';
import '../../domain/repositories/vocational_games_repository.dart';

class VocationalGamesRepositoryImpl implements VocationalGamesRepository {
  @override
  Future<List<GameEntity>> getAvailableGames() async {
    // TODO: Implement actual data fetch
    return [];
  }

  @override
  Future<void> submitGameResult(GameResultEntity result) async {
    // TODO: Implement actual submit
  }
}
