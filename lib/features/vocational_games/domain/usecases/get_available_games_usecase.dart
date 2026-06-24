import '../entities/game_entity.dart';
import '../repositories/vocational_games_repository.dart';

class GetAvailableGamesUseCase {
  final VocationalGamesRepository repository;

  GetAvailableGamesUseCase(this.repository);

  Future<List<GameEntity>> call() {
    return repository.getAvailableGames();
  }
}
