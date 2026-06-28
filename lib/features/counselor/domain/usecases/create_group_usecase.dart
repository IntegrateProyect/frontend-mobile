import '../repositories/counselor_repository.dart';

class CreateGroupUseCase {
  final CounselorRepository repository;

  CreateGroupUseCase(this.repository);

  Future<Map<String, dynamic>> call(String name, String? accessCode) {
    return repository.createGroup(name, accessCode);
  }
}
