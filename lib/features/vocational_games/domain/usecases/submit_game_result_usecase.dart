import '../entities/game_result_entity.dart';
import '../repositories/vocational_games_repository.dart';

class SubmitGameResultUseCase {
  final VocationalGamesRepository repository;

  SubmitGameResultUseCase(this.repository);

  Future<void> call(GameResultEntity result) {
    return repository.submitGameResult(result);
  }
}
