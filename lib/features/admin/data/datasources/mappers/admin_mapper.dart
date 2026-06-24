import '../../../domain/entities/admin_stats_entity.dart';
import '../../../domain/entities/app_user_entity.dart';
import '../models/admin_stats_model.dart';
import '../models/app_user_model.dart';

class AdminMapper {
  static AdminStatsEntity toStatsEntity(AdminStatsModel model) {
    return AdminStatsEntity(
      totalStudents: model.totalStudents,
      totalCounselors: model.totalCounselors,
      totalUniversities: model.totalUniversities,
      totalAlumni: model.totalAlumni,
    );
  }

  static AppUserEntity toUserEntity(AppUserModel model) {
    return AppUserEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      role: model.role,
      isActive: model.isActive,
    );
  }
}
