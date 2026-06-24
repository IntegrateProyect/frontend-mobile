import '../entities/counselor_profile_entity.dart';
import '../entities/student_consultation_entity.dart';

abstract class CounselorRepository {
  Future<CounselorProfileEntity> getProfile();
  Future<List<StudentConsultationEntity>> getConsultations();
  Future<void> respondToConsultation(String consultationId, String response);
}
