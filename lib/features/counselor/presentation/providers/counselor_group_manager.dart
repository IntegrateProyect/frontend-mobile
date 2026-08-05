import '../../domain/usecases/create_group_usecase.dart';
import '../../domain/usecases/update_group_usecase.dart';
import '../../domain/repositories/counselor_repository.dart';

class CounselorGroupManager {
  final CreateGroupUseCase _createGroupUseCase;
  final UpdateGroupUseCase _updateGroupUseCase;
  final CounselorRepository _repository;

  CounselorGroupManager({
    required CreateGroupUseCase createGroupUseCase,
    required UpdateGroupUseCase updateGroupUseCase,
    required CounselorRepository repository,
  })  : _createGroupUseCase = createGroupUseCase,
        _updateGroupUseCase = updateGroupUseCase,
        _repository = repository;

  Future<void> createGroup(String name, String? accessCode) async {
    await _createGroupUseCase.call(name, accessCode);
  }

  Future<void> updateGroup(String groupId, {String? name, String? accessCode}) async {
    await _updateGroupUseCase.call(groupId, name: name, accessCode: accessCode);
  }

  Future<void> deleteGroup(String groupId) async {
    await _repository.deleteGroup(groupId);
  }
}
