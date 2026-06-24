import '../entities/university_entity.dart';
import '../repositories/student_repository.dart';

class GetCompatibleUniversitiesUseCase {
  final StudentRepository repository;

  GetCompatibleUniversitiesUseCase(this.repository);

  Future<List<UniversityEntity>> call() {
    return repository.getCompatibleUniversities();
  }
}
