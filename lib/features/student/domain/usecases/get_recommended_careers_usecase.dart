import '../entities/career_entity.dart';
import '../repositories/student_repository.dart';

class GetRecommendedCareersUseCase {
  final StudentRepository repository;

  GetRecommendedCareersUseCase(this.repository);

  Future<List<CareerEntity>> call() {
    return repository.getRecommendedCareers();
  }
}
