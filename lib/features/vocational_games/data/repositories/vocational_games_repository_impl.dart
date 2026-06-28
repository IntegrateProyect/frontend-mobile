import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';

import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_question_entity.dart';
import '../../domain/entities/game_result_entity.dart';
import '../../domain/repositories/vocational_games_repository.dart';

import '../datasources/models/game_model.dart';
import '../datasources/models/game_question_model.dart';

class VocationalGamesRepositoryImpl implements VocationalGamesRepository {
  final IApi api;
  final UserService userService;

  VocationalGamesRepositoryImpl({
    required this.api,
    required this.userService,
  });

  @override
  Future<List<GameEntity>> getAvailableGames() async {
    final data = await api.getGames();

    return data
        .map((item) => GameModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> startGame(String gameId) async {
    final token = await userService.getToken();
    return api.startGame(token ?? '', gameId);
  }

  @override
  Future<List<GameQuestionEntity>> getGameQuestions(String gameId) async {
    final token = await userService.getToken();

    final data = await api.getGameQuestions(token ?? '', gameId);

    return data
        .map((item) => GameQuestionModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  @override
  Future<void> sendAnswer(String gameId, Map<String, dynamic> answerData) async {
    final token = await userService.getToken();
    await api.sendAnswer(token ?? '', gameId, answerData);
  }

  @override
  Future<Map<String, dynamic>> finishGame(String gameId, String sessionId) async {
    final token = await userService.getToken();
    return api.finishGame(token ?? '', gameId, sessionId);
  }

  @override
  Future<List<dynamic>> getGameHistory() async {
    final token = await userService.getToken();
    return api.getGameResults(token ?? '');
  }

  @override
  Future<void> submitGameResult(GameResultEntity result) async {}
}