import 'package:flutter/material.dart';

import '../../domain/usecases/save_favorite_usecase.dart';

class FavoritesProvider extends ChangeNotifier {
  final SaveFavoriteUseCase _saveFavoriteUseCase;

  FavoritesProvider({
    required SaveFavoriteUseCase saveFavoriteUseCase,
  }) : _saveFavoriteUseCase = saveFavoriteUseCase;

  final Set<String> _favoriteIds = {};

  bool _isLoading = false;
  String? _errorMessage;

  Set<String> get favoriteIds {
    return Set.unmodifiable(_favoriteIds);
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  Future<void> toggleFavorite(
      String id,
      String type,
      ) async {
    final wasFavorite = _favoriteIds.contains(id);

    if (wasFavorite) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _saveFavoriteUseCase(id, type);
    } catch (error) {
      if (wasFavorite) {
        _favoriteIds.add(id);
      } else {
        _favoriteIds.remove(id);
      }

      _errorMessage = 'No se pudo guardar el favorito.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}