import 'package:flutter/material.dart';
import '../../../vocational_games/domain/usecases/get_available_games_usecase.dart';
import '../../domain/entities/vocational_result_entity.dart';
import '../../domain/usecases/get_vocational_results_usecase.dart';

class StudentProgressProvider extends ChangeNotifier {
  final GetVocationalResultsUseCase _getResultsUseCase;
  final GetAvailableGamesUseCase _getGamesUseCase;

  StudentProgressProvider({
    required GetVocationalResultsUseCase getResultsUseCase,
    required GetAvailableGamesUseCase getGamesUseCase,
  })  : _getResultsUseCase = getResultsUseCase,
        _getGamesUseCase = getGamesUseCase;

  List<VocationalResultEntity> _results = [];
  List<dynamic> _availableGames = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<VocationalResultEntity> get results => List.unmodifiable(_results);
  List<dynamic> get availableGames => List.unmodifiable(_availableGames);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get hasVocationalResults => _results.isNotEmpty;

  bool get hasStartedGames {
    if (_results.isNotEmpty) return true;

    return _availableGames.any((game) {
      final data = _asMap(game);
      if (data == null) return false;

      final status = _gameStatus(data);
      final progress = _toDouble(
        data['progress'] ??
            data['progressPercentage'] ??
            data['progress_percentage'] ??
            data['completionPercentage'] ??
            data['completion_percentage'],
      );

      final attempts = _toInt(
        data['attempts'] ??
            data['attemptCount'] ??
            data['attempt_count'],
      );

      return status == 'STARTED' ||
          status == 'IN_PROGRESS' ||
          status == 'COMPLETED' ||
          status == 'FINISHED' ||
          progress > 0 ||
          attempts > 0;
    });
  }

  bool get hasCompletedGames {
    if (_results.isNotEmpty) return true;
    if (_availableGames.isEmpty) return false;

    final gameMaps = _availableGames
        .map(_asMap)
        .whereType<Map<String, dynamic>>()
        .toList();

    if (gameMaps.isEmpty) return false;

    return gameMaps.every((data) {
      final status = _gameStatus(data);
      final progress = _toDouble(
        data['progress'] ??
            data['progressPercentage'] ??
            data['progress_percentage'] ??
            data['completionPercentage'] ??
            data['completion_percentage'],
      );

      final completedValue =
          data['completed'] ?? data['isCompleted'] ?? data['is_completed'];

      return status == 'COMPLETED' ||
          status == 'FINISHED' ||
          progress >= 100 ||
          completedValue == true;
    });
  }

  Future<void> loadProgressData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final resultsFuture = _getResultsUseCase();
      final gamesFuture = _getGamesUseCase();

      final responses = await Future.wait([resultsFuture, gamesFuture]);

      _results = responses[0] as List<VocationalResultEntity>;
      _availableGames = responses[1] as List<dynamic>;
    } catch (e) {
      _errorMessage = 'Error al cargar el progreso';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  String _gameStatus(Map<String, dynamic> data) {
    return (data['status'] ??
            data['progressStatus'] ??
            data['progress_status'] ??
            data['state'] ??
            '')
        .toString()
        .trim()
        .toUpperCase();
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
