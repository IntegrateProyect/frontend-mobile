import '../repositories/favorites_repository.dart';

class SaveFavoriteUseCase {
  final FavoritesRepository repository;

  SaveFavoriteUseCase(this.repository);

  Future<void> call(String id, String type) {
    return repository.saveFavorite(id, type);
  }
}
