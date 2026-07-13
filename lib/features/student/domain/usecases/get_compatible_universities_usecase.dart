import '../entities/university_catalog_page_entity.dart';
import '../repositories/student_repository.dart';

class GetCompatibleUniversitiesUseCase {
  final StudentRepository repository;

  GetCompatibleUniversitiesUseCase(
      this.repository,
      );

  Future<UniversityCatalogPageEntity> call({
    int page = 1,
    int limit = 20,
    String search = '',
  }) {
    return repository
        .getCompatibleUniversities(
      page: page,
      limit: limit,
      search: search,
    );
  }
}