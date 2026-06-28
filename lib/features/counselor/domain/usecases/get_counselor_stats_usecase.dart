import '../repositories/counselor_repository.dart';

class GetCounselorStatsUseCase {
  final CounselorRepository repository;

  GetCounselorStatsUseCase(this.repository);

  Future<Map<String, dynamic>> call() {
    return repository.getStats();
  }
}
