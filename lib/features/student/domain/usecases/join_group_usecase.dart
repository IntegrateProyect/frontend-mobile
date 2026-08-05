import '../repositories/student_group_repository.dart';

class JoinGroupUseCase {
  final StudentGroupRepository repository;

  JoinGroupUseCase(this.repository);

  Future<void> call(String accessCode) {
    return repository.joinGroup(accessCode);
  }
}
