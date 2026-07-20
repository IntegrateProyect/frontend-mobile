import '../repositories/university_repository.dart';

class DeleteUniversityAlumniUseCase {
  final UniversityRepository repository;

  DeleteUniversityAlumniUseCase(this.repository);

  Future<void> call(String alumniId) {
    return repository.deleteAlumni(alumniId);
  }
}