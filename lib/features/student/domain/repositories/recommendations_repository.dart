import '../../../university/domain/entities/university_catalog_page_entity.dart';
import '../entities/career_entity.dart';

abstract class RecommendationsRepository {
  Future<List<CareerEntity>> getRecommendedCareers({
    int topN = 5,
  });

  Future<UniversityCatalogPageEntity> getCompatibleUniversities({
    int page = 1,
    int limit = 20,
    String search = '',
  });
}
