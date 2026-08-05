import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';

import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_question_entity.dart';
import '../../domain/entities/game_result_entity.dart';
import '../../domain/repositories/vocational_games_repository.dart';

import '../datasources/models/game_model.dart';
import '../datasources/models/game_question_model.dart';

class VocationalGamesRepositoryImpl
    implements VocationalGamesRepository {
  final IApi api;
  final UserService userService;

  VocationalGamesRepositoryImpl({
    required this.api,
    required this.userService,
  });

  // =========================================================
  // TOKEN
  // =========================================================

  Future<String> _getToken() async {
    final token = await userService.getToken();

    if (token == null || token.trim().isEmpty) {
      throw Exception(
        'No hay una sesión activa',
      );
    }

    return token.trim();
  }

  // =========================================================
  // JUEGOS DISPONIBLES
  // =========================================================

  @override
  Future<List<GameEntity>> getAvailableGames() async {
    final data = await api.getGames();

    return data
        .whereType<Map>()
        .map(
          (item) => GameModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  // =========================================================
  // INICIAR JUEGO
  // =========================================================

  @override
  Future<Map<String, dynamic>> startGame(
      String gameId,
      ) async {
    final token = await _getToken();
    final cleanGameId = gameId.trim();

    if (cleanGameId.isEmpty) {
      throw ArgumentError(
        'El identificador del juego es obligatorio',
      );
    }

    return api.startGame(
      token,
      cleanGameId,
    );
  }

  // =========================================================
  // PREGUNTAS DEL JUEGO
  // =========================================================

  @override
  Future<List<GameQuestionEntity>> getGameQuestions(
      String gameId,
      ) async {
    final token = await _getToken();
    final cleanGameId = gameId.trim();

    if (cleanGameId.isEmpty) {
      throw ArgumentError(
        'El identificador del juego es obligatorio',
      );
    }

    final data = await api.getGameQuestions(
      token,
      cleanGameId,
    );

    return data
        .whereType<Map>()
        .map(
          (item) => GameQuestionModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();
  }

  // =========================================================
  // ENVIAR RESPUESTA
  // =========================================================

  @override
  Future<void> sendAnswer(
      String gameId,
      Map<String, dynamic> answerData,
      ) async {
    final token = await _getToken();
    final cleanGameId = gameId.trim();

    if (cleanGameId.isEmpty) {
      throw ArgumentError(
        'El identificador del juego es obligatorio',
      );
    }

    await api.sendAnswer(
      token,
      cleanGameId,
      answerData,
    );
  }

  // =========================================================
  // FINALIZAR JUEGO
  // =========================================================

  @override
  Future<Map<String, dynamic>> finishGame(
      String gameId,
      String sessionId,
      ) async {
    final token = await _getToken();
    final cleanGameId = gameId.trim();
    final cleanSessionId = sessionId.trim();

    if (cleanGameId.isEmpty) {
      throw ArgumentError(
        'El identificador del juego es obligatorio',
      );
    }

    if (cleanSessionId.isEmpty) {
      throw ArgumentError(
        'El identificador de la sesión es obligatorio',
      );
    }

    return api.finishGame(
      cleanGameId,
      token,
      cleanSessionId,
    );
  }

  // =========================================================
  // HISTORIAL DE JUEGOS
  // =========================================================

  @override
  Future<List<dynamic>> getGameHistory() async {
    final token = await _getToken();

    return api.getGameResults(token);
  }

  // =========================================================
  // GUARDAR RESULTADO
  // =========================================================

  @override
  Future<void> submitGameResult(
      GameResultEntity result,
      ) async {
    /*
     * El resultado ya se almacena en el backend cuando se
     * ejecuta finishGame(). Por eso no se realiza otra petición.
     */
  }
}