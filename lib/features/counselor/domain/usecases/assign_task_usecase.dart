import '../repositories/counselor_repository.dart';

class AssignTaskUseCase {
  final CounselorRepository repository;

  AssignTaskUseCase(this.repository);

  Future<void> call(Map<String, dynamic> taskData) {
    return repository.assignTask(taskData);
  }
}
