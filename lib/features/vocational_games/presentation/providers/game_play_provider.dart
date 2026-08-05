import 'package:flutter/material.dart';
import '../../domain/entities/game_entity.dart';
import '../../domain/entities/game_question_entity.dart';
import '../../domain/usecases/finish_game_usecase.dart';
import '../../domain/usecases/send_game_answer_usecase.dart';
import '../../domain/usecases/start_game_usecase.dart';

class GamePlayProvider extends ChangeNotifier {
  final StartGameUseCase _startGameUseCase;
  final SendGameAnswerUseCase _sendAnswerUseCase;
  final FinishGameUseCase _finishGameUseCase;

  GamePlayProvider({
    required StartGameUseCase startGameUseCase,
    required SendGameAnswerUseCase sendAnswerUseCase,
    required FinishGameUseCase finishGameUseCase,
  })  : _startGameUseCase = startGameUseCase,
        _sendAnswerUseCase = sendAnswerUseCase,
        _finishGameUseCase = finishGameUseCase;

  String? _sessionId;
  GameEntity? _activeGame;
  List<GameQuestionEntity> _questions = [];
  int _currentIndex = 0;
  String? _errorMessage;
  bool _isSubmitting = false;

  String? get sessionId => _sessionId;
  GameEntity? get activeGame => _activeGame;
  List<GameQuestionEntity> get questions => List.unmodifiable(_questions);
  int get currentIndex => _currentIndex;
  String? get errorMessage => _errorMessage;
  bool get isSubmitting => _isSubmitting;

  void setupSession(GameEntity game, List<GameQuestionEntity> questions, int savedIndex, String? existingSessionId) {
    _activeGame = game;
    _questions = questions;
    _currentIndex = savedIndex;
    _sessionId = existingSessionId;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> startNewSession(String gameId) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _startGameUseCase(gameId);
      _sessionId = _extractId(response);
      _currentIndex = 0;
    } catch (e) {
      _errorMessage = 'Error al iniciar el juego';
      rethrow;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> submitAnswer({
    required String gameId,
    required String questionId,
    required String optionId,
    required String answer,
    required Map<String, dynamic> weights,
    Map<String, dynamic>? interactionData,
  }) async {
    if (_sessionId == null) throw StateError('No hay sesión activa');

    try {
      await _sendAnswerUseCase(
        gameId,
        {
          'sessionId': _sessionId,
          'questionId': questionId,
          'selectedOptionId': optionId,
          'rawData': {
            'answerText': answer,
            'weights': weights,
            if (interactionData != null) ...interactionData,
          },
        },
      );
      _currentIndex++;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al guardar respuesta';
      rethrow;
    }
  }

  Future<Map<String, dynamic>> finishSession(String gameId) async {
    if (_sessionId == null) throw StateError('No hay sesión activa');

    try {
      final response = await _finishGameUseCase(gameId, _sessionId!);
      _sessionId = null;
      notifyListeners();
      return Map<String, dynamic>.from(response['data'] ?? response);
    } catch (e) {
      _errorMessage = 'Error al finalizar el juego';
      rethrow;
    }
  }

  String _extractId(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map) return (data['sessionId'] ?? data['id']).toString();
    return (response['sessionId'] ?? response['id']).toString();
  }
}
