import '../repositories/counselor_repository.dart';

class GetGroupsUseCase {
  final CounselorRepository repository;

  GetGroupsUseCase(this.repository);

  Future<List<dynamic>> call() {
    return repository.getGroups();
  }
}
