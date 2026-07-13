import 'package:flutter/foundation.dart';
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
  final GetAvailableGamesUseCase _getGames;
  final GetGameQuestionsUseCase _getQuestions;
  final StartGameUseCase _startGame;
  final SendGameAnswerUseCase _sendAnswer;
  final FinishGameUseCase _finishGame;

  GamesProvider({
    required GetAvailableGamesUseCase getGamesUseCase,
    required GetGameQuestionsUseCase getQuestionsUseCase,
    required StartGameUseCase startGameUseCase,
    required SendGameAnswerUseCase sendAnswerUseCase,
    required FinishGameUseCase finishGameUseCase,
  })  : _getGames = getGamesUseCase,
        _getQuestions = getQuestionsUseCase,
        _startGame = startGameUseCase,
        _sendAnswer = sendAnswerUseCase,
        _finishGame = finishGameUseCase;

  List<GameEntity> _games = [];
  List<GameQuestionEntity> _questions = [];
  List<VocationalMiniGameEntity> _miniGames = [];

  final Map<String, MiniGameStatus> _statuses = {};
  final Map<String, int> _savedIndexes = {};

  GameEntity? _activeGame;

  String? _sessionId;
  String? _sessionKey;
  String? _errorMessage;

  bool _isLoading = false;
  bool _isLoadingQuestions = false;

  int _savedIndex = 0;

  Map<String, dynamic> _lastBackendResult = {};

  List<GameEntity> get games => List.unmodifiable(_games);

  List<GameQuestionEntity> get questions {
    return List.unmodifiable(_questions);
  }

  List<VocationalMiniGameEntity> get miniGames {
    return List.unmodifiable(_miniGames);
  }

  GameEntity? get activeGame => _activeGame;

  String? get sessionId => _sessionId;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  bool get isLoadingQuestions => _isLoadingQuestions;

  int get savedIndex => _savedIndex;

  Map<String, dynamic> get lastBackendResult {
    return Map.unmodifiable(_lastBackendResult);
  }

  MiniGameStatus getMiniGameStatus(String key) {
    return _statuses[key] ?? MiniGameStatus.notStarted;
  }

  double getMiniGameProgress(
      String key,
      int totalQuestions,
      ) {
    if (totalQuestions <= 0) {
      return 0;
    }

    if (getMiniGameStatus(key) ==
        MiniGameStatus.completed) {
      return 1;
    }

    final answeredQuestions = _savedIndexes[key] ?? 0;

    return (answeredQuestions / totalQuestions)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  Future<void> fetchGames() async {
    _isLoading = true;
    _errorMessage = null;

    _games = [];
    _questions = [];
    _miniGames = [];

    _activeGame = null;
    _sessionId = null;
    _sessionKey = null;
    _savedIndex = 0;

    _statuses.clear();
    _savedIndexes.clear();

    notifyListeners();

    try {
      _games = await _getGames();

      if (_games.isEmpty) {
        _errorMessage =
        'No hay minijuegos disponibles.';
        return;
      }

      /*
       * Actualmente el backend tiene un juego principal
       * que contiene todas las preguntas RIASEC.
       *
       * Las preguntas se separan en minijuegos visuales
       * mediante GameMapper.groupQuestions().
       */
      await _prepareMiniGames(_games.first);
    } catch (error, stackTrace) {
      _errorMessage =
      'No se pudieron cargar los minijuegos.';

      debugPrint(
        'Error fetchGames: $error\n$stackTrace',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _prepareMiniGames(
      GameEntity game,
      ) async {
    _isLoadingQuestions = true;
    _errorMessage = null;
    _activeGame = game;

    notifyListeners();

    try {
      final loadedQuestions =
      await _getQuestions(game.id);

      if (loadedQuestions.isEmpty) {
        _questions = [];
        _miniGames = [];

        _errorMessage =
        'Este juego no tiene preguntas disponibles.';

        return;
      }

      _questions = loadedQuestions;

      _miniGames = GameMapper.groupQuestions(
        loadedQuestions,
      );

      if (_miniGames.isEmpty) {
        _errorMessage =
        'No se pudieron organizar las preguntas.';
        return;
      }

      await _loadStoredProgress();
    } catch (error, stackTrace) {
      _questions = [];
      _miniGames = [];

      _errorMessage =
      'No se pudieron cargar las preguntas.';

      debugPrint(
        'Error prepareMiniGames: '
            '$error\n$stackTrace',
      );
    } finally {
      _isLoadingQuestions = false;
      notifyListeners();
    }
  }

  Future<void> _loadStoredProgress() async {
    final preferences =
    await SharedPreferences.getInstance();

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
      );

      final savedQuestionIndex =
          preferences.getInt(
            'game_index_$key',
          ) ??
              0;

      _savedIndexes[key] = savedQuestionIndex;

      if (isCompleted) {
        _statuses[key] =
            MiniGameStatus.completed;
        continue;
      }

      final hasSavedSession =
          savedSession != null &&
              savedSession.isNotEmpty;

      if (hasSavedSession ||
          savedQuestionIndex > 0) {
        _statuses[key] =
            MiniGameStatus.inProgress;
      } else {
        _statuses[key] =
            MiniGameStatus.notStarted;
      }
    }
  }

  Future<void> selectMiniGame(
      VocationalMiniGameEntity miniGame,
      ) async {
    final key = miniGame.statusKey;

    final preferences =
    await SharedPreferences.getInstance();

    if (_sessionKey != key) {
      _sessionId = null;
      _sessionKey = null;
    }

    _questions = List<GameQuestionEntity>.from(
      miniGame.questions,
    );

    _savedIndex =
        preferences.getInt(
          'game_index_$key',
        ) ??
            0;

    if (_savedIndex < 0 ||
        _savedIndex >= _questions.length) {
      _savedIndex = 0;
    }

    _savedIndexes[key] = _savedIndex;

    notifyListeners();
  }

  Future<void> startSessionIfNeeded(
      String gameId, {
        String? statusKey,
      }) async {
    final key = statusKey ?? gameId;

    final hasCurrentSession =
        _sessionKey == key &&
            _sessionId != null &&
            _sessionId!.isNotEmpty;

    if (hasCurrentSession) {
      return;
    }

    final preferences =
    await SharedPreferences.getInstance();

    var savedSession =
    preferences.getString(
      'game_session_$key',
    );

    var savedQuestionIndex =
        preferences.getInt(
          'game_index_$key',
        ) ??
            0;

    final wasCompleted =
        preferences.getBool(
          'game_completed_$key',
        ) ??
            false;

    /*
     * Si el minijuego ya fue completado y el alumno
     * lo abre nuevamente, se inicia una sesión nueva.
     */
    if (wasCompleted) {
      await preferences.remove(
        'game_session_$key',
      );

      await preferences.remove(
        'game_index_$key',
      );

      await preferences.setBool(
        'game_completed_$key',
        false,
      );

      savedSession = null;
      savedQuestionIndex = 0;

      _statuses[key] =
          MiniGameStatus.notStarted;
    }

    if (savedSession != null &&
        savedSession.isNotEmpty) {
      _sessionId = savedSession;
      _sessionKey = key;
      _savedIndex = savedQuestionIndex;

      _savedIndexes[key] =
          savedQuestionIndex;

      _statuses[key] =
          MiniGameStatus.inProgress;

      notifyListeners();
      return;
    }

    final response = await _startGame(gameId);

    _sessionId = _extractSessionId(response);
    _sessionKey = key;
    _savedIndex = savedQuestionIndex;

    _savedIndexes[key] =
        savedQuestionIndex;

    if (_sessionId == null ||
        _sessionId!.isEmpty) {
      _sessionId = null;
      _sessionKey = null;

      _statuses[key] =
          MiniGameStatus.notStarted;

      notifyListeners();

      throw StateError(
        'El backend no devolvió '
            'un identificador de sesión.',
      );
    }

    await preferences.setString(
      'game_session_$key',
      _sessionId!,
    );

    await preferences.setBool(
      'game_completed_$key',
      false,
    );

    _statuses[key] =
        MiniGameStatus.inProgress;

    notifyListeners();
  }

  String? _extractSessionId(
      Map<String, dynamic> response,
      ) {
    final data = _asMap(response['data']);

    final possibleSessionId =
        response['sessionId'] ??
            response['session_id'] ??
            response['id'] ??
            data['sessionId'] ??
            data['session_id'] ??
            data['id'];

    final value =
    possibleSessionId?.toString().trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    return value;
  }

  Future<void> saveProgress({
    required String gameId,
    required int currentIndex,
  }) async {
    final safeIndex =
    currentIndex < 0 ? 0 : currentIndex;

    final preferences =
    await SharedPreferences.getInstance();

    await preferences.setInt(
      'game_index_$gameId',
      safeIndex,
    );

    await preferences.setBool(
      'game_completed_$gameId',
      false,
    );

    _savedIndex = safeIndex;
    _savedIndexes[gameId] = safeIndex;

    _statuses[gameId] =
        MiniGameStatus.inProgress;

    notifyListeners();
  }

  Future<void> sendAnswer({
    required String gameId,
    required String questionId,
    required String optionId,
    required String answer,
    required Map<String, dynamic> weights,
    required int currentIndex,
    String? progressKey,
    Map<String, dynamic> interactionData =
    const <String, dynamic>{},
  }) async {
    final key = progressKey ?? gameId;

    _errorMessage = null;

    try {
      await startSessionIfNeeded(
        gameId,
        statusKey: key,
      );

      if (_sessionId == null ||
          _sessionId!.isEmpty) {
        throw StateError(
          'No existe una sesión activa.',
        );
      }

      final answerData = <String, dynamic>{
        'sessionId': _sessionId!,
        'questionId': questionId,
        'selectedOptionId': optionId,
        'rawData': <String, dynamic>{
          ...interactionData,
          'answerText': answer,
          'weights': weights,
        },
      };

      await _sendAnswer(
        gameId,
        answerData,
      );

      await saveProgress(
        gameId: key,
        currentIndex: currentIndex,
      );
    } catch (error, stackTrace) {
      _errorMessage =
      'No se pudo guardar la respuesta.';

      debugPrint(
        'Error sendAnswer: '
            '$error\n$stackTrace',
      );

      notifyListeners();
      rethrow;
    }
  }

  Future<Map<String, dynamic>> finishGame(
      String gameId, {
        String? statusKey,
      }) async {
    final key = statusKey ?? gameId;

    _errorMessage = null;

    try {
      await startSessionIfNeeded(
        gameId,
        statusKey: key,
      );

      if (_sessionId == null ||
          _sessionId!.isEmpty) {
        throw StateError(
          'No existe una sesión activa.',
        );
      }

      final response = await _finishGame(
        gameId,
        _sessionId!,
      );

      final responseData = _asMap(
        response['data'] ?? response,
      );

      final backendResult = _asMap(
        responseData['results'] ??
            responseData['result'] ??
            responseData,
      );

      _lastBackendResult = backendResult;

      final preferences =
      await SharedPreferences.getInstance();

      await preferences.remove(
        'game_session_$key',
      );

      await preferences.remove(
        'game_index_$key',
      );

      await preferences.setBool(
        'game_completed_$key',
        true,
      );

      _sessionId = null;
      _sessionKey = null;
      _savedIndex = 0;

      _savedIndexes[key] = 0;

      _statuses[key] =
          MiniGameStatus.completed;

      notifyListeners();

      return backendResult;
    } catch (error, stackTrace) {
      _errorMessage =
      'No se pudo finalizar el minijuego.';

      debugPrint(
        'Error finishGame: '
            '$error\n$stackTrace',
      );

      notifyListeners();
      rethrow;
    }
  }

  Map<String, dynamic> _asMap(
      dynamic value,
      ) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(
        value,
      );
    }

    return <String, dynamic>{};
  }

  void clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;
    notifyListeners();
  }

  void clearQuestions() {
    _questions = [];
    _errorMessage = null;

    notifyListeners();
  }

  void clearAllGameData() {
    _games = [];
    _questions = [];
    _miniGames = [];

    _activeGame = null;

    _sessionId = null;
    _sessionKey = null;
    _errorMessage = null;

    _isLoading = false;
    _isLoadingQuestions = false;

    _savedIndex = 0;
    _lastBackendResult = {};

    _statuses.clear();
    _savedIndexes.clear();

    notifyListeners();
  }
}