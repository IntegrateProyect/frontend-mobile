import '../entities/university_career_entity.dart';
import '../repositories/university_repository.dart';

class GetUniversityCareersUseCase {
  final UniversityRepository repository;

  GetUniversityCareersUseCase(this.repository);

  Future<List<UniversityCareerEntity>> call() => repository.getCareers();
}
