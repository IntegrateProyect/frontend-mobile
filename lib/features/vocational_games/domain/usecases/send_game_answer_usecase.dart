import '../repositories/vocational_games_repository.dart';

class SendGameAnswerUseCase {
  final VocationalGamesRepository repository;

  SendGameAnswerUseCase(this.repository);

  Future<void> call(String gameId, Map<String, dynamic> answerData) {
    return repository.sendAnswer(gameId, answerData);
  }
}
