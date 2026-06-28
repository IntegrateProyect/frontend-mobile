import '../entities/game_entity.dart';
import '../entities/game_result_entity.dart';
import '../entities/game_question_entity.dart';

abstract class VocationalGamesRepository {
  Future<List<GameEntity>> getAvailableGames();
  Future<Map<String, dynamic>> startGame(String gameId);
  Future<List<GameQuestionEntity>> getGameQuestions(String gameId);
  Future<void> sendAnswer(String gameId, Map<String, dynamic> answerData);
  Future<Map<String, dynamic>> finishGame(String gameId, String sessionId);
  Future<List<dynamic>> getGameHistory();
  Future<void> submitGameResult(GameResultEntity result);
}