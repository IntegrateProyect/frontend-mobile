import '../entities/admin_stats_entity.dart';
import '../entities/app_user_entity.dart';

abstract class AdminRepository {
  Future<AdminStatsEntity> getGlobalStats();
  Future<List<AppUserEntity>> getAllUsers();
  Future<void> toggleUserStatus(String userId, bool isActive);
  Future<void> deleteUser(String userId);
}
