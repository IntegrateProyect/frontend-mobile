import '../../domain/entities/counselor_profile_entity.dart';
import '../../domain/entities/student_consultation_entity.dart';
import '../../domain/repositories/counselor_repository.dart';

class CounselorRepositoryImpl implements CounselorRepository {
  @override
  Future<CounselorProfileEntity> getProfile() async {
    // TODO: Implement actual data fetch
    throw UnimplementedError();
  }

  @override
  Future<List<StudentConsultationEntity>> getConsultations() async {
    return [];
  }

  @override
  Future<void> respondToConsultation(String consultationId, String response) async {
    // TODO: Implement respond
  }
}
