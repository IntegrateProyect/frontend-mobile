import '../entities/career_entity.dart';
import '../repositories/recommendations_repository.dart';

class GetRecommendedCareersUseCase {
  final RecommendationsRepository repository;

  GetRecommendedCareersUseCase(this.repository);

  Future<List<CareerEntity>> call({
    int topN = 5,
  }) {
    return repository.getRecommendedCareers(
      topN: topN,
    );
  }
}
