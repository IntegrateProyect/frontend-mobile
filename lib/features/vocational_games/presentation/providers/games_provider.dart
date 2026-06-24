import 'package:flutter/material.dart';
import '../../domain/entities/game_entity.dart';
import '../../domain/usecases/get_available_games_usecase.dart';

class GamesProvider extends ChangeNotifier {
  final GetAvailableGamesUseCase _getGamesUseCase;

  List<GameEntity> _games = [];
  bool _isLoading = false;

  GamesProvider({required GetAvailableGamesUseCase getGamesUseCase})
      : _getGamesUseCase = getGamesUseCase;

  List<GameEntity> get games => _games;
  bool get isLoading => _isLoading;

  Future<void> fetchGames() async {
    _isLoading = true;
    notifyListeners();
    try {
      _games = await _getGamesUseCase();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
