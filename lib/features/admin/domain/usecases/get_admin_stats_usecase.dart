import '../entities/admin_stats_entity.dart';
import '../repositories/admin_repository.dart';

class GetAdminStatsUseCase {
  final AdminRepository repository;

  GetAdminStatsUseCase(this.repository);

  Future<AdminStatsEntity> call() {
    return repository.getGlobalStats();
  }
}
