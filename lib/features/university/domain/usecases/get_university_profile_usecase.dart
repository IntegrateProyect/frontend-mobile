import '../entities/university_profile_entity.dart';
import '../repositories/university_repository.dart';

class GetUniversityProfileUseCase {
  final UniversityRepository repository;

  GetUniversityProfileUseCase(this.repository);

  Future<UniversityProfileEntity> call() {
    return repository.getProfile();
  }
}
