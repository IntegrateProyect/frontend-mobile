import '../entities/game_question_entity.dart';
import '../repositories/vocational_games_repository.dart';

class GetGameQuestionsUseCase {
  final VocationalGamesRepository repository;

  GetGameQuestionsUseCase(this.repository);

  Future<List<GameQuestionEntity>> call(String gameId) {
    return repository.getGameQuestions(gameId);
  }
}