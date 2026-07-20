import '../repositories/university_repository.dart';

class CreateUniversityAlumniUseCase {
  final UniversityRepository repository;

  CreateUniversityAlumniUseCase(this.repository);

  Future<void> call(Map<String, dynamic> alumniData) {
    return repository.createAlumni(alumniData);
  }
}
