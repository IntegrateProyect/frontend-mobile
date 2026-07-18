import '../entities/alumni_profile_entity.dart';
import '../repositories/alumni_repository.dart';

class UpdateAlumniProfileUseCase {
  final AlumniRepository repository;

  UpdateAlumniProfileUseCase(this.repository);

  Future<void> call(AlumniProfileEntity profile) {
    return repository.updateProfile(profile);
  }
}
