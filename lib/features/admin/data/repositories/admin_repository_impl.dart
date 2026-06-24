import '../../domain/entities/admin_stats_entity.dart';
import '../../domain/entities/app_user_entity.dart';
import '../../domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  @override
  Future<AdminStatsEntity> getGlobalStats() async {
    // TODO: Implement actual data fetch
    throw UnimplementedError();
  }

  @override
  Future<List<AppUserEntity>> getAllUsers() async {
    return [];
  }

  @override
  Future<void> toggleUserStatus(String userId, bool isActive) async {
    // TODO: Implement toggle
  }

  @override
  Future<void> deleteUser(String userId) async {
    // TODO: Implement delete
  }
}
