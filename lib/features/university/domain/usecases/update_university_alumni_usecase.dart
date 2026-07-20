import '../repositories/university_repository.dart';

class UpdateUniversityAlumniUseCase {
  final UniversityRepository repository;

  UpdateUniversityAlumniUseCase(this.repository);

  Future<void> call(String alumniId, Map<String, dynamic> alumniData) {
    return repository.updateAlumni(alumniId, alumniData);
  }
}
