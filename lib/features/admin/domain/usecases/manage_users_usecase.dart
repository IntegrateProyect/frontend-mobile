import '../entities/app_user_entity.dart';
import '../repositories/admin_repository.dart';

class ManageUsersUseCase {
  final AdminRepository repository;

  ManageUsersUseCase(this.repository);

  Future<List<AppUserEntity>> getUsers() => repository.getAllUsers();
  Future<void> toggleStatus(String id, bool isActive) => repository.toggleUserStatus(id, isActive);
  Future<void> deleteUser(String id) => repository.deleteUser(id);
}
