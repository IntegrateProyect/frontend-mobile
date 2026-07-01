import '../repositories/counselor_repository.dart';

class GetGroupDetailsUseCase {
  final CounselorRepository repository;

  GetGroupDetailsUseCase(this.repository);

  Future<Map<String, dynamic>> call(String groupId) {
    return repository.getGroupDetails(groupId);
  }
}
