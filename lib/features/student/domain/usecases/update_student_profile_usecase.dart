import '../entities/student_profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateStudentProfileUseCase {
  final ProfileRepository repository;

  UpdateStudentProfileUseCase(this.repository);

  Future<void> call(StudentProfileEntity profile) {
    return repository.updateProfile(profile);
  }
}
