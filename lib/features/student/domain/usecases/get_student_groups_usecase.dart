import '../repositories/student_group_repository.dart';

class GetStudentGroupsUseCase {
  final StudentGroupRepository repository;

  GetStudentGroupsUseCase(this.repository);

  Future<List<dynamic>> call() {
    return repository.getGroups();
  }
}
