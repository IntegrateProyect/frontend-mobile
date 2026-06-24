import 'package:flutter/material.dart';
import '../../domain/usecases/save_favorite_usecase.dart';

class FavoritesProvider extends ChangeNotifier {
  final SaveFavoriteUseCase _saveFavoriteUseCase;

  final List<String> _favoriteIds = [];
  bool _isLoading = false;

  FavoritesProvider({required SaveFavoriteUseCase saveFavoriteUseCase})
      : _saveFavoriteUseCase = saveFavoriteUseCase;

  List<String> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;

  Future<void> toggleFavorite(String id, String type) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _saveFavoriteUseCase(id, type);
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);
}
