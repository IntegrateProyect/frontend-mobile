import '../entities/university_career_entity.dart';
import '../repositories/university_repository.dart';

class ManageCareersUseCase {
  final UniversityRepository repository;

  ManageCareersUseCase(this.repository);

  Future<List<UniversityCareerEntity>> getCareers() => repository.getCareers();
  Future<void> addCareer(UniversityCareerEntity career) => repository.addCareer(career);
  Future<void> deleteCareer(String id) => repository.deleteCareer(id);
}
