import '../entities/alumni_profile_entity.dart';
import '../repositories/alumni_repository.dart';

class GetAlumniProfileUseCase {
  final AlumniRepository repository;

  GetAlumniProfileUseCase(this.repository);

  Future<AlumniProfileEntity> call() {
    return repository.getProfile();
  }
}
