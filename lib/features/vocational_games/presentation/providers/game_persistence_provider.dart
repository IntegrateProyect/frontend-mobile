import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/vocational_mini_game_entity.dart';

enum MiniGameStatus { notStarted, inProgress, completed }

class GamePersistenceProvider extends ChangeNotifier {
  final Map<String, MiniGameStatus> _miniGameStatus = {};
  final Map<String, int> _savedIndexes = {};
  final Map<String, String> _savedSessions = {};

  MiniGameStatus getMiniGameStatus(String key) => _miniGameStatus[key] ?? MiniGameStatus.notStarted;
  int getSavedIndex(String key) => _savedIndexes[key] ?? 0;
  String? getSavedSession(String key) => _savedSessions[key];

  double getMiniGameProgress(String key, int total) {
    if (total <= 0) return 0;
    final status = getMiniGameStatus(key);
    if (status == MiniGameStatus.completed) return 1.0;
    final currentIndex = getSavedIndex(key);
    return (currentIndex / total).clamp(0.0, 1.0);
  }

  Future<void> loadAllStatuses(List<VocationalMiniGameEntity> miniGames) async {
    final preferences = await SharedPreferences.getInstance();
    _miniGameStatus.clear();
    _savedIndexes.clear();
    _savedSessions.clear();

    for (final miniGame in miniGames) {
      final key = miniGame.statusKey;
      final isCompleted = preferences.getBool('game_completed_$key') ?? false;
      final savedSession = preferences.getString('game_session_$key') ?? '';
      final savedIndex = preferences.getInt('game_index_$key') ?? 0;

      _savedIndexes[key] = savedIndex < 0 ? 0 : savedIndex;
      if (savedSession.isNotEmpty) _savedSessions[key] = savedSession;

      if (isCompleted) {
        _miniGameStatus[key] = MiniGameStatus.completed;
      } else if (savedSession.isNotEmpty || savedIndex > 0) {
        _miniGameStatus[key] = MiniGameStatus.inProgress;
      } else {
        _miniGameStatus[key] = MiniGameStatus.notStarted;
      }
    }
    notifyListeners();
  }

  Future<void> saveProgress(String statusKey, int index, {String? sessionId}) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('game_index_$statusKey', index);
    _savedIndexes[statusKey] = index;
    
    if (sessionId != null) {
      await preferences.setString('game_session_$statusKey', sessionId);
      _savedSessions[statusKey] = sessionId;
    }

    if (_miniGameStatus[statusKey] != MiniGameStatus.completed) {
      _miniGameStatus[statusKey] = MiniGameStatus.inProgress;
    }
    notifyListeners();
  }

  Future<void> markAsCompleted(String statusKey) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('game_completed_$statusKey', true);
    await preferences.remove('game_session_$statusKey');
    await preferences.remove('game_index_$statusKey');
    
    _miniGameStatus[statusKey] = MiniGameStatus.completed;
    _savedIndexes[statusKey] = 0;
    _savedSessions.remove(statusKey);
    notifyListeners();
  }

  Future<void> markAllAsCompleted(List<VocationalMiniGameEntity> miniGames) async {
    for (final game in miniGames) {
      await markAsCompleted(game.statusKey);
    }
  }

  Future<void> resetProgress(String statusKey) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('game_session_$statusKey');
    await preferences.remove('game_index_$statusKey');
    await preferences.remove('game_completed_$statusKey');
    
    _miniGameStatus[statusKey] = MiniGameStatus.notStarted;
    _savedIndexes[statusKey] = 0;
    _savedSessions.remove(statusKey);
    notifyListeners();
  }

  bool areAllCompleted(List<VocationalMiniGameEntity> miniGames) {
    if (miniGames.isEmpty) return false;
    return miniGames.every((g) => getMiniGameStatus(g.statusKey) == MiniGameStatus.completed);
  }
}
