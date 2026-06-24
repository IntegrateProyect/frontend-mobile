import '../repositories/student_repository.dart';

class SaveFavoriteUseCase {
  final StudentRepository repository;

  SaveFavoriteUseCase(this.repository);

  Future<void> call(String id, String type) {
    return repository.saveFavorite(id, type);
  }
}
