import '../entities/student_counselor_entity.dart';
import '../repositories/student_group_repository.dart';

class GetStudentCounselorUseCase {
  final StudentGroupRepository repository;

  GetStudentCounselorUseCase(this.repository);

  Future<StudentCounselorEntity?> call() {
    return repository.getCounselor();
  }
}
