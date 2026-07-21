import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/mappers/game_mapper.dart';

import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_question_entity.dart';
import '../../domain/entities/vocational_mini_game_entity.dart';

import '../../domain/usecases/finish_game_usecase.dart';
import '../../domain/usecases/get_available_games_usecase.dart';
import '../../domain/usecases/get_game_questions_usecase.dart';
import '../../domain/usecases/send_game_answer_usecase.dart';
import '../../domain/usecases/start_game_usecase.dart';

class GamesProvider extends ChangeNotifier {
  final GetAvailableGamesUseCase _getGamesUseCase;
  final GetGameQuestionsUseCase _getQuestionsUseCase;
  final StartGameUseCase _startGameUseCase;
  final SendGameAnswerUseCase _sendAnswerUseCase;
  final FinishGameUseCase _finishGameUseCase;

  GamesProvider({
    required GetAvailableGamesUseCase getGamesUseCase,
    required GetGameQuestionsUseCase getQuestionsUseCase,
    required StartGameUseCase startGameUseCase,
    required SendGameAnswerUseCase sendAnswerUseCase,
    required FinishGameUseCase finishGameUseCase,
  })  : _getGamesUseCase = getGamesUseCase,
        _getQuestionsUseCase = getQuestionsUseCase,
        _startGameUseCase = startGameUseCase,
        _sendAnswerUseCase = sendAnswerUseCase,
        _finishGameUseCase = finishGameUseCase;

  static const Duration _cacheDuration =
  Duration(minutes: 5);

  static const Duration _rateLimitDuration =
  Duration(minutes: 15);

  List<GameEntity> _games = [];
  List<GameQuestionEntity> _questions = [];
  List<VocationalMiniGameEntity> _miniGames = [];

  bool _isLoading = false;
  bool _isLoadingQuestions = false;

  String? _sessionId;
  String? _activeSessionStatusKey;
  String? _errorMessage;

  GameEntity? _activeGame;

  int _savedIndex = 0;

  DateTime? _lastFetchAt;
  DateTime? _rateLimitBlockedUntil;

  final Map<String, MiniGameStatus> _miniGameStatus = {};
  final Map<String, int> _savedIndexes = {};

  List<GameEntity> get games =>
      List<GameEntity>.unmodifiable(_games);

  List<GameQuestionEntity> get questions =>
      List<GameQuestionEntity>.unmodifiable(
        _questions,
      );

  List<VocationalMiniGameEntity> get miniGames =>
      List<VocationalMiniGameEntity>.unmodifiable(
        _miniGames,
      );

  bool get isLoading => _isLoading;

  bool get isLoadingQuestions =>
      _isLoadingQuestions;

  String? get errorMessage => _errorMessage;

  GameEntity? get activeGame => _activeGame;

  int get savedIndex => _savedIndex;

  String? get sessionId => _sessionId;

  bool get isRateLimited {
    final blockedUntil = _rateLimitBlockedUntil;

    if (blockedUntil == null) {
      return false;
    }

    return DateTime.now().isBefore(
      blockedUntil,
    );
  }

  int get rateLimitMinutesRemaining {
    final blockedUntil = _rateLimitBlockedUntil;

    if (blockedUntil == null) {
      return 0;
    }

    final remaining = blockedUntil.difference(
      DateTime.now(),
    );

    if (remaining.isNegative) {
      return 0;
    }

    final minutes =
    (remaining.inSeconds / 60).ceil();

    return minutes < 1 ? 1 : minutes;
  }

  MiniGameStatus getMiniGameStatus(
      String miniGameKey,
      ) {
    return _miniGameStatus[miniGameKey] ??
        MiniGameStatus.notStarted;
  }

  double getMiniGameProgress(
      String key,
      int total,
      ) {
    if (total <= 0) {
      return 0;
    }

    final status = getMiniGameStatus(key);

    if (status == MiniGameStatus.completed) {
      return 1;
    }

    final currentIndex =
        _savedIndexes[key] ?? 0;

    return (currentIndex / total)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  /// Carga los juegos y las preguntas desde el backend.
  ///
  /// force = false:
  /// reutiliza los datos durante cinco minutos.
  ///
  /// force = true:
  /// intenta actualizar los datos, excepto cuando el
  /// servidor haya aplicado el límite de solicitudes.
  Future<void> fetchGames({
    bool force = false,
  }) async {
    if (_isLoading || _isLoadingQuestions) {
      return;
    }

    final now = DateTime.now();

    _clearExpiredRateLimit(now);

    if (isRateLimited) {
      _errorMessage = _buildRateLimitMessage();

      notifyListeners();
      return;
    }

    final hasFreshCache =
        _miniGames.isNotEmpty &&
            _lastFetchAt != null &&
            now.difference(_lastFetchAt!) <
                _cacheDuration;

    if (!force && hasFreshCache) {
      await refreshLocalStatuses();
      return;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final loadedGames =
      await _getGamesUseCase();

      if (loadedGames.isEmpty) {
        _games = [];
        _questions = [];
        _miniGames = [];
        _activeGame = null;

        _errorMessage =
        'No hay juegos disponibles actualmente.';

        return;
      }

      _games = List<GameEntity>.from(
        loadedGames,
      );

      await _prepareMiniGamesInternal(
        _games.first,
      );

      if (_miniGames.isNotEmpty) {
        _lastFetchAt = DateTime.now();
        _rateLimitBlockedUntil = null;
        _errorMessage = null;
      }
    } catch (error, stackTrace) {
      debugPrint(
        'Error al cargar los juegos: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (_isRateLimitError(error)) {
        _activateRateLimit();

        _errorMessage = _buildRateLimitMessage();
      } else {
        _errorMessage =
        'No fue posible cargar los minijuegos. '
            'Revisa tu conexión e inténtalo nuevamente.';
      }

      /*
       * Si ya había juegos cargados, no se eliminan.
       * Esto permite seguir mostrando la información
       * guardada aunque falle una actualización.
       */
      if (_miniGames.isEmpty) {
        _questions = [];
        _activeGame = null;
      }
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> _prepareMiniGamesInternal(
      GameEntity game,
      ) async {
    _isLoadingQuestions = true;
    _activeGame = game;
    _errorMessage = null;

    notifyListeners();

    try {
      final allQuestions =
      await _getQuestionsUseCase(game.id);

      debugPrint(
        'Preguntas recibidas para el juego '
            '${game.id}: ${allQuestions.length}',
      );

      if (allQuestions.isEmpty) {
        _questions = [];
        _miniGames = [];

        _errorMessage =
        'El juego no tiene preguntas disponibles.';

        return;
      }

      _questions =
      List<GameQuestionEntity>.from(
        allQuestions,
      );

      final preparedMiniGames =
      GameMapper.groupQuestions(
        allQuestions,
      );

      /*
       * Solo se muestran los minijuegos que
       * tengan al menos una pregunta.
       */
      _miniGames = preparedMiniGames
          .where(
            (miniGame) =>
        miniGame.questions.isNotEmpty,
      )
          .toList();

      if (_miniGames.isEmpty) {
        _errorMessage =
        'No fue posible clasificar las preguntas recibidas.';

        return;
      }

      await _loadAllStatusInternal();

      _errorMessage = null;
    } catch (error, stackTrace) {
      debugPrint(
        'Error al preparar los minijuegos: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _questions = [];
      _miniGames = [];

      /*
       * Se vuelve a lanzar el error para que
       * fetchGames pueda detectar un error 429.
       */
      rethrow;
    } finally {
      _isLoadingQuestions = false;

      notifyListeners();
    }
  }

  Future<void> _loadAllStatusInternal() async {
    final preferences =
    await SharedPreferences.getInstance();

    _miniGameStatus.clear();
    _savedIndexes.clear();

    for (final miniGame in _miniGames) {
      final key = miniGame.statusKey;

      final isCompleted =
          preferences.getBool(
            'game_completed_$key',
          ) ??
              false;

      final savedSession =
          preferences.getString(
            'game_session_$key',
          ) ??
              '';

      final savedQuestionIndex =
          preferences.getInt(
            'game_index_$key',
          ) ??
              0;

      final safeIndex =
      savedQuestionIndex < 0
          ? 0
          : savedQuestionIndex;

      _savedIndexes[key] = safeIndex;

      if (isCompleted) {
        _miniGameStatus[key] =
            MiniGameStatus.completed;
      } else if (savedSession.isNotEmpty ||
          safeIndex > 0) {
        _miniGameStatus[key] =
            MiniGameStatus.inProgress;
      } else {
        _miniGameStatus[key] =
            MiniGameStatus.notStarted;
      }
    }
  }

  /// Actualiza los estados utilizando SharedPreferences.
  ///
  /// Este método no llama al backend.
  Future<void> refreshLocalStatuses() async {
    if (_miniGames.isEmpty) {
      return;
    }

    await _loadAllStatusInternal();

    notifyListeners();
  }

  Future<void> selectMiniGame(
      VocationalMiniGameEntity miniGame,
      ) async {
    final preferences =
    await SharedPreferences.getInstance();

    _questions =
    List<GameQuestionEntity>.from(
      miniGame.questions,
    );

    final savedQuestionIndex =
        preferences.getInt(
          'game_index_${miniGame.statusKey}',
        ) ??
            0;

    if (_questions.isEmpty) {
      _savedIndex = 0;
    } else if (savedQuestionIndex < 0 ||
        savedQuestionIndex >=
            _questions.length) {
      _savedIndex = 0;

      await preferences.setInt(
        'game_index_${miniGame.statusKey}',
        0,
      );
    } else {
      _savedIndex = savedQuestionIndex;
    }

    _savedIndexes[miniGame.statusKey] =
        _savedIndex;

    _errorMessage = null;

    notifyListeners();
  }

  Future<void> startSessionIfNeeded(
      String gameId, {
        required String statusKey,
      }) async {
    if (_sessionId != null &&
        _sessionId!.isNotEmpty &&
        _activeSessionStatusKey == statusKey) {
      return;
    }

    final preferences =
    await SharedPreferences.getInstance();

    /*
     * Limpiar únicamente la sesión que está en
     * memoria cuando se abre otro minijuego.
     *
     * La sesión anterior sigue guardada en
     * SharedPreferences.
     */
    if (_activeSessionStatusKey != statusKey) {
      _sessionId = null;
    }

    final savedSession =
    preferences.getString(
      'game_session_$statusKey',
    );

    final savedQuestionIndex =
        preferences.getInt(
          'game_index_$statusKey',
        ) ??
            0;

    try {
      if (savedSession != null &&
          savedSession.isNotEmpty) {
        _sessionId = savedSession;

        if (_questions.isEmpty) {
          _savedIndex = 0;
        } else if (savedQuestionIndex < 0 ||
            savedQuestionIndex >=
                _questions.length) {
          _savedIndex = 0;
        } else {
          _savedIndex = savedQuestionIndex;
        }
      } else {
        final response =
        await _startGameUseCase(gameId);

        final newSessionId =
        _extractSessionId(response);

        if (newSessionId.isEmpty) {
          throw StateError(
            'El backend no devolvió un sessionId.',
          );
        }

        _sessionId = newSessionId;
        _savedIndex = 0;

        await preferences.setString(
          'game_session_$statusKey',
          newSessionId,
        );

        await preferences.setInt(
          'game_index_$statusKey',
          0,
        );
      }

      _activeSessionStatusKey = statusKey;

      _savedIndexes[statusKey] =
          _savedIndex;

      if (getMiniGameStatus(statusKey) !=
          MiniGameStatus.completed) {
        _miniGameStatus[statusKey] =
            MiniGameStatus.inProgress;
      }

      _errorMessage = null;

      notifyListeners();
    } catch (error, stackTrace) {
      debugPrint(
        'Error al iniciar la sesión: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      _sessionId = null;
      _activeSessionStatusKey = null;

      if (_isRateLimitError(error)) {
        _activateRateLimit();

        _errorMessage = _buildRateLimitMessage();
      } else {
        _errorMessage =
        'No fue posible iniciar el minijuego.';
      }

      notifyListeners();

      rethrow;
    }
  }

  String _extractSessionId(
      Map<String, dynamic> response,
      ) {
    final dynamic responseData =
    response['data'];

    if (responseData is Map) {
      final map =
      Map<String, dynamic>.from(
        responseData,
      );

      final nestedId =
          map['sessionId'] ??
              map['session_id'] ??
              map['id'];

      if (nestedId != null &&
          nestedId.toString().isNotEmpty) {
        return nestedId.toString();
      }
    }

    final directId =
        response['sessionId'] ??
            response['session_id'] ??
            response['id'];

    return directId?.toString() ?? '';
  }

  Future<void> saveProgress({
    required String gameId,
    required int currentIndex,
  }) async {
    /*
     * En este método gameId representa el
     * statusKey del minijuego.
     */
    final statusKey = gameId;

    final preferences =
    await SharedPreferences.getInstance();

    final safeIndex =
    currentIndex < 0
        ? 0
        : currentIndex;

    await preferences.setInt(
      'game_index_$statusKey',
      safeIndex,
    );

    _savedIndex = safeIndex;
    _savedIndexes[statusKey] =
        safeIndex;

    if (getMiniGameStatus(statusKey) !=
        MiniGameStatus.completed) {
      _miniGameStatus[statusKey] =
          MiniGameStatus.inProgress;
    }

    notifyListeners();
  }

  Future<void> sendAnswer({
    required String gameId,
    required String questionId,
    required String optionId,
    required String answer,
    required Map<String, dynamic> weights,
    required int currentIndex,
    required String progressKey,
    Map<String, dynamic>? interactionData,
  }) async {
    if (_sessionId == null ||
        _sessionId!.isEmpty) {
      _errorMessage =
      'No existe una sesión activa.';

      notifyListeners();

      throw StateError(
        'No existe una sesión activa.',
      );
    }

    try {
      await _sendAnswerUseCase(
        gameId,
        <String, dynamic>{
          'sessionId': _sessionId,
          'questionId': questionId,
          'selectedOptionId': optionId,
          'rawData': <String, dynamic>{
            'answerText': answer,
            'weights': weights,
            if (interactionData != null)
              ...interactionData,
          },
        },
      );

      await saveProgress(
        gameId: progressKey,
        currentIndex: currentIndex,
      );

      _errorMessage = null;
    } catch (error, stackTrace) {
      debugPrint(
        'Error al enviar respuesta: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (_isRateLimitError(error)) {
        _activateRateLimit();

        _errorMessage = _buildRateLimitMessage();
      } else {
        _errorMessage =
        'No fue posible guardar la respuesta.';
      }

      notifyListeners();

      rethrow;
    }
  }

  Future<Map<String, dynamic>> finishGame(
      String gameId, {
        required String statusKey,
      }) async {
    final currentSessionId = _sessionId;

    if (currentSessionId == null ||
        currentSessionId.isEmpty) {
      _errorMessage =
      'No existe una sesión para finalizar.';

      notifyListeners();

      throw StateError(
        'No existe una sesión para finalizar.',
      );
    }

    try {
      final response =
      await _finishGameUseCase(
        gameId,
        currentSessionId,
      );

      final dynamic responseData =
          response['data'] ?? response;

      final preferences =
      await SharedPreferences.getInstance();

      await preferences.remove(
        'game_session_$statusKey',
      );

      await preferences.remove(
        'game_index_$statusKey',
      );

      await preferences.setBool(
        'game_completed_$statusKey',
        true,
      );

      _sessionId = null;
      _activeSessionStatusKey = null;
      _savedIndex = 0;

      _savedIndexes[statusKey] = 0;

      _miniGameStatus[statusKey] =
          MiniGameStatus.completed;

      _errorMessage = null;

      notifyListeners();

      if (responseData is Map) {
        return Map<String, dynamic>.from(
          responseData,
        );
      }

      return <String, dynamic>{};
    } catch (error, stackTrace) {
      debugPrint(
        'Error al finalizar el juego: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (_isRateLimitError(error)) {
        _activateRateLimit();

        _errorMessage = _buildRateLimitMessage();
      } else {
        _errorMessage =
        'No fue posible finalizar el minijuego.';
      }

      notifyListeners();

      rethrow;
    }
  }

  Future<void> resetMiniGameProgress(
      String statusKey,
      ) async {
    final preferences =
    await SharedPreferences.getInstance();

    await preferences.remove(
      'game_session_$statusKey',
    );

    await preferences.remove(
      'game_index_$statusKey',
    );

    await preferences.remove(
      'game_completed_$statusKey',
    );

    if (_activeSessionStatusKey == statusKey) {
      _sessionId = null;
      _activeSessionStatusKey = null;
    }

    _savedIndexes[statusKey] = 0;

    _miniGameStatus[statusKey] =
        MiniGameStatus.notStarted;

    _savedIndex = 0;
    _errorMessage = null;

    notifyListeners();
  }

  bool _isRateLimitError(Object error) {
    final errorText =
    error.toString().toLowerCase();

    return errorText.contains(
      'too many requests',
    ) ||
        errorText.contains('429') ||
        errorText.contains('rate limit') ||
        errorText.contains(
          'demasiadas solicitudes',
        );
  }

  void _activateRateLimit() {
    _rateLimitBlockedUntil =
        DateTime.now().add(
          _rateLimitDuration,
        );
  }

  void _clearExpiredRateLimit(
      DateTime now,
      ) {
    final blockedUntil =
        _rateLimitBlockedUntil;

    if (blockedUntil == null) {
      return;
    }

    if (!now.isBefore(blockedUntil)) {
      _rateLimitBlockedUntil = null;
    }
  }

  String _buildRateLimitMessage() {
    final minutes = rateLimitMinutesRemaining;

    if (minutes <= 1) {
      return 'El servidor está recibiendo demasiadas '
          'solicitudes. Espera aproximadamente un minuto '
          'antes de intentarlo nuevamente.';
    }

    return 'El servidor está recibiendo demasiadas '
        'solicitudes. Intenta nuevamente en aproximadamente '
        '$minutes minutos.';
  }

  void clearQuestions() {
    _questions = [];
    _savedIndex = 0;

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;

    notifyListeners();
  }
}