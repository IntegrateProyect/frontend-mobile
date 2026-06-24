import '../entities/student_profile_entity.dart';
import '../repositories/student_repository.dart';

class GetStudentProfileUseCase {
  final StudentRepository repository;

  GetStudentProfileUseCase(this.repository);

  Future<StudentProfileEntity> call() {
    return repository.getProfile();
  }
}
