import '../entities/student_profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetStudentProfileUseCase {
  final ProfileRepository repository;

  GetStudentProfileUseCase(this.repository);

  Future<StudentProfileEntity> call() {
    return repository.getProfile();
  }
}
