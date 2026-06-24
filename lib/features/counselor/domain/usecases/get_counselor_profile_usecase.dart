import '../entities/counselor_profile_entity.dart';
import '../repositories/counselor_repository.dart';

class GetCounselorProfileUseCase {
  final CounselorRepository repository;

  GetCounselorProfileUseCase(this.repository);

  Future<CounselorProfileEntity> call() {
    return repository.getProfile();
  }
}
