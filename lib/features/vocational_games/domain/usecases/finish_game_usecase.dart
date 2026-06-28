import '../repositories/vocational_games_repository.dart';

class FinishGameUseCase {
  final VocationalGamesRepository repository;

  FinishGameUseCase(this.repository);

  Future<Map<String, dynamic>> call(String gameId, String sessionId) {
    return repository.finishGame(gameId, sessionId);
  }
}
