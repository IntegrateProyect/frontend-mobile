import '../../../../core/api/IApi.dart';
import '../../../../core/utils/UserService.dart';
import '../../domain/entities/admin_stats_entity.dart';
import '../../domain/entities/app_user_entity.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/models/app_user_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final IApi api;
  final UserService userService;

  AdminRepositoryImpl({required this.api, required this.userService});

  @override
  Future<AdminStatsEntity> getGlobalStats() async {
    final token = await userService.getToken();
    final data = await api.getAdminStats(token ?? '');
    
    // Asumiendo que la API devuelve los campos totalStudents, totalCounselors, etc.
    return AdminStatsEntity(
      totalStudents: (data['totalStudents'] ?? data['students_count'] ?? 0) as int,
      totalCounselors: (data['totalCounselors'] ?? data['counselors_count'] ?? 0) as int,
      totalUniversities: (data['totalUniversities'] ?? data['universities_count'] ?? 0) as int,
      totalAlumni: (data['totalAlumni'] ?? data['alumni_count'] ?? 0) as int,
    );
  }

  @override
  Future<List<AppUserEntity>> getAllUsers() async {
    final token = await userService.getToken();
    final list = await api.getAllUsers(token ?? '');
    return list.map((item) => AppUserModel.fromJson(item)).toList();
  }

  @override
  Future<void> toggleUserStatus(String userId, bool isActive) async {
    final token = await userService.getToken();
    await api.toggleUserStatus(token ?? '', userId, isActive);
  }

  @override
  Future<void> deleteUser(String userId) async {
    final token = await userService.getToken();
    await api.deleteUser(token ?? '', userId);
  }
}
