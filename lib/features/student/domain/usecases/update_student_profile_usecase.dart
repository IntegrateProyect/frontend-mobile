import '../entities/student_profile_entity.dart';
import '../repositories/student_repository.dart';

class UpdateStudentProfileUseCase {
  final StudentRepository repository;

  UpdateStudentProfileUseCase(this.repository);

  Future<void> call(StudentProfileEntity profile) {
    return repository.updateProfile(profile);
  }
}
