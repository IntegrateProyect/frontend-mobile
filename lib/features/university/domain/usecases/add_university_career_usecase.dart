import '../entities/university_career_entity.dart';
import '../repositories/university_repository.dart';

class AddUniversityCareerUseCase {
  final UniversityRepository repository;

  AddUniversityCareerUseCase(this.repository);

  Future<void> call(UniversityCareerEntity career) => repository.addCareer(career);
}
