import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_question_entity.dart';
import '../../domain/entities/vocational_mini_game_entity.dart'; // Usamos las entidades del dominio
import '../../domain/usecases/get_available_games_usecase.dart';
import '../../domain/usecases/get_game_questions_usecase.dart';
import '../../domain/usecases/start_game_usecase.dart';
import '../../domain/usecases/send_game_answer_usecase.dart';
import '../../domain/usecases/finish_game_usecase.dart';

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

  List<GameEntity> _games = [];
  List<GameQuestionEntity> _questions = [];
  List<VocationalMiniGameEntity> _miniGames = [];
  bool _isLoading = false;
  bool _isLoadingQuestions = false;
  String? _sessionId;
  String? _errorMessage;
  GameEntity? _activeGame;
  int _savedIndex = 0;
  final Map<String, MiniGameStatus> _miniGameStatus = {};

  List<GameEntity> get games => _games;
  List<GameQuestionEntity> get questions => _questions;
  List<VocationalMiniGameEntity> get miniGames => _miniGames;
  bool get isLoading => _isLoading;
  bool get isLoadingQuestions => _isLoadingQuestions;
  String? get errorMessage => _errorMessage;
  GameEntity? get activeGame => _activeGame;
  int get savedIndex => _savedIndex;

  MiniGameStatus getMiniGameStatus(String miniGameKey) => 
      _miniGameStatus[miniGameKey] ?? MiniGameStatus.notStarted;

  double getMiniGameProgress(String key, int total) {
    if (total == 0) return 0.0;
    if (getMiniGameStatus(key) == MiniGameStatus.completed) return 1.0;
    return 0.0;
  }

  Future<void> fetchGames() async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _games = await _getGamesUseCase();
      if (_games.isNotEmpty) {
        await _prepareMiniGamesInternal(_games.first);
      }
    } catch (e) {
      _errorMessage = 'Error al cargar juegos';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _prepareMiniGamesInternal(GameEntity game) async {
    _isLoadingQuestions = true;
    _activeGame = game;
    notifyListeners();

    try {
      final allQuestions = await _getQuestionsUseCase(game.id);
      final grouped = <VocationalCategory, List<GameQuestionEntity>>{};

      for (final q in allQuestions) {
        final cat = _detectCategory(q.text);
        grouped.putIfAbsent(cat, () => []).add(q);
      }

      _miniGames = grouped.entries.map((e) => VocationalMiniGameEntity(
        category: e.key,
        title: _categoryTitle(e.key),
        description: _categoryDescription(e.key),
        questions: e.value,
      )).toList();
      
      _miniGames.sort((a, b) => a.title.compareTo(b.title));
      await _loadAllStatusInternal();
    } catch (e) {
      debugPrint('Error preparing mini games: $e');
    } finally {
      _isLoadingQuestions = false;
      notifyListeners();
    }
  }

  Future<void> _loadAllStatusInternal() async {
    final prefs = await SharedPreferences.getInstance();
    for (final mg in _miniGames) {
      final key = mg.statusKey;
      if (prefs.getBool('game_completed_$key') ?? false) {
        _miniGameStatus[key] = MiniGameStatus.completed;
      } else if ((prefs.getString('game_session_$key') ?? '').isNotEmpty) {
        _miniGameStatus[key] = MiniGameStatus.inProgress;
      } else {
        _miniGameStatus[key] = MiniGameStatus.notStarted;
      }
    }
  }

  Future<void> startSessionIfNeeded(String gameId, {required String statusKey}) async {
    if (_sessionId != null) return;
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('game_session_$statusKey');
    
    if (saved != null && saved.isNotEmpty) {
      _sessionId = saved;
      _savedIndex = prefs.getInt('game_index_$statusKey') ?? 0;
    } else {
      final res = await _startGameUseCase(gameId);
      _sessionId = res['sessionId']?.toString() ?? res['id']?.toString();
      if (_sessionId != null) {
        await prefs.setString('game_session_$statusKey', _sessionId!);
      }
      _savedIndex = 0;
    }
    notifyListeners();
  }

  Future<void> selectMiniGame(VocationalMiniGameEntity miniGame) async {
    _questions = miniGame.questions;
    final prefs = await SharedPreferences.getInstance();
    _savedIndex = prefs.getInt('game_index_${miniGame.statusKey}') ?? 0;
    notifyListeners();
  }

  Future<void> saveProgress({required String gameId, required int currentIndex}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('game_index_$gameId', currentIndex);
    _miniGameStatus[gameId] = MiniGameStatus.inProgress;
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
    await _sendAnswerUseCase(gameId, {
      'sessionId': _sessionId,
      'questionId': questionId,
      'selectedOptionId': optionId,
      'rawData': {
        'answerText': answer, 
        'weights': weights,
        if (interactionData != null) ...interactionData,
      },
    });
    await saveProgress(gameId: progressKey, currentIndex: currentIndex);
  }

  Future<Map<String, dynamic>> finishGame(String gameId, {required String statusKey}) async {
    final res = await _finishGameUseCase(gameId, _sessionId!);
    final data = res['data'] ?? res;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('game_session_$statusKey');
    await prefs.remove('game_index_$statusKey');
    await prefs.setBool('game_completed_$statusKey', true);
    
    _sessionId = null;
    _miniGameStatus[statusKey] = MiniGameStatus.completed;
    
    notifyListeners();
    return data is Map ? Map<String, dynamic>.from(data) : {};
  }

  void clearQuestions() {
    _questions = [];
    notifyListeners();
  }

  VocationalCategory _detectCategory(String raw) {
    final t = raw.toLowerCase();
    if (t.contains('calcular') || t.contains('logica')) return VocationalCategory.calculo;
    if (t.contains('musica') || t.contains('ritmo')) return VocationalCategory.musical;
    if (t.contains('pintar') || t.contains('arte')) return VocationalCategory.artistico;
    if (t.contains('reparar') || t.contains('maquina')) return VocationalCategory.mecanico;
    if (t.contains('ayudar') || t.contains('social')) return VocationalCategory.social;
    if (t.contains('escribir') || t.contains('leer')) return VocationalCategory.literario;
    if (t.contains('convencer') || t.contains('lider')) return VocationalCategory.persuasivo;
    if (t.contains('plantas') || t.contains('bio')) return VocationalCategory.biologico;
    return VocationalCategory.fisico;
  }

  String _categoryTitle(VocationalCategory c) {
    switch (c) {
      case VocationalCategory.calculo: return 'Lógica y Cálculo';
      case VocationalCategory.fisico: return 'Ciencia Física';
      case VocationalCategory.biologico: return 'Biología y Salud';
      case VocationalCategory.mecanico: return 'Mecánica';
      case VocationalCategory.social: return 'Servicio Social';
      case VocationalCategory.literario: return 'Lectura y Escritura';
      case VocationalCategory.persuasivo: return 'Liderazgo';
      case VocationalCategory.artistico: return 'Arte y Diseño';
      case VocationalCategory.musical: return 'Música';
    }
  }

  String _categoryDescription(VocationalCategory c) => 'Retos de tipo ${c.name}.';
}
