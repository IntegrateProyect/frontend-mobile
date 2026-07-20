import '../entities/university_alumni_entity.dart';
import '../repositories/university_repository.dart';

class GetUniversityAlumniUseCase {
  final UniversityRepository repository;

  GetUniversityAlumniUseCase(this.repository);

  Future<List<UniversityAlumniEntity>> call() {
    return repository.getAlumni();
  }
}
