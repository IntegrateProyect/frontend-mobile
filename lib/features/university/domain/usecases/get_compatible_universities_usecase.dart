import '../entities/university_catalog_page_entity.dart';
import '../repositories/university_repository.dart';

class GetCompatibleUniversitiesUseCase {
  final UniversityRepository repository;

  GetCompatibleUniversitiesUseCase(this.repository);

  Future<UniversityCatalogPageEntity> call({
    int page = 1,
    int limit = 20,
    String search = '',
  }) {
    return repository.getCompatibleUniversities(
      page: page,
      limit: limit,
      search: search,
    );
  }
}
