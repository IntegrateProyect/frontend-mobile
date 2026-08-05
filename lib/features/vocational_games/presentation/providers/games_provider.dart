import 'package:flutter/material.dart';
import '../../data/datasources/mappers/game_mapper.dart';
import '../../domain/entities/game_entity.dart';
import '../../domain/entities/vocational_mini_game_entity.dart';
import '../../domain/usecases/get_available_games_usecase.dart';
import '../../domain/usecases/get_game_questions_usecase.dart';

class GamesProvider extends ChangeNotifier {
  final GetAvailableGamesUseCase _getGamesUseCase;
  final GetGameQuestionsUseCase _getQuestionsUseCase;

  GamesProvider({
    required GetAvailableGamesUseCase getGamesUseCase,
    required GetGameQuestionsUseCase getQuestionsUseCase,
  })  : _getGamesUseCase = getGamesUseCase,
        _getQuestionsUseCase = getQuestionsUseCase;

  List<GameEntity> _games = [];
  List<VocationalMiniGameEntity> _miniGames = [];
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastFetchAt;
  bool _isDisposed = false;

  List<GameEntity> get games => List.unmodifiable(_games);
  List<VocationalMiniGameEntity> get miniGames => List.unmodifiable(_miniGames);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> fetchGames({bool force = false}) async {
    if (_isLoading) return;

    final now = DateTime.now();
    if (!force && _miniGames.isNotEmpty && _lastFetchAt != null && 
        now.difference(_lastFetchAt!) < const Duration(minutes: 5)) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();

    try {
      final loadedGames = await _getGamesUseCase();
      if (loadedGames.isEmpty) {
        _games = [];
        _miniGames = [];
        _errorMessage = 'No hay juegos disponibles actualmente.';
      } else {
        _games = loadedGames;
        await _loadMiniGames(loadedGames.first);
        _lastFetchAt = DateTime.now();
      }
    } catch (e) {
      _errorMessage = 'Error al cargar los juegos. Revisa tu conexión.';
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<void> _loadMiniGames(GameEntity game) async {
    try {
      final questions = await _getQuestionsUseCase(game.id);
      if (questions.isNotEmpty) {
        _miniGames = GameMapper.groupQuestions(questions)
            .where((mg) => mg.questions.isNotEmpty)
            .toList();
      }
    } catch (e) {
      debugPrint('Error grouping questions: $e');
      rethrow;
    }
  }

  void clearError() {
    _errorMessage = null;
    _safeNotifyListeners();
  }
}
