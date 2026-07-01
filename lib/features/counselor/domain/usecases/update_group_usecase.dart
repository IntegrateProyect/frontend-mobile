import '../repositories/counselor_repository.dart';

class UpdateGroupUseCase {
  final CounselorRepository repository;

  UpdateGroupUseCase(this.repository);

  Future<Map<String, dynamic>> call(String groupId, {String? name, String? accessCode}) {
    return repository.updateGroup(groupId, name: name, accessCode: accessCode);
  }
}
