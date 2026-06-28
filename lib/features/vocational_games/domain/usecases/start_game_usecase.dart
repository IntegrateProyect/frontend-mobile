import '../repositories/vocational_games_repository.dart';

class StartGameUseCase {
  final VocationalGamesRepository repository;

  StartGameUseCase(this.repository);

  Future<Map<String, dynamic>> call(String gameId) {
    return repository.startGame(gameId);
  }
}
