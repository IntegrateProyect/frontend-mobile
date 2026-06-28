import '../entities/counselor_profile_entity.dart';
import '../entities/student_consultation_entity.dart';

abstract class CounselorRepository {
  Future<CounselorProfileEntity> getProfile();
  
  // Groups
  Future<List<dynamic>> getGroups();
  Future<Map<String, dynamic>> createGroup(String name, String? accessCode);
  Future<List<dynamic>> getGroupStudents(String groupId);
  
  // Students
  Future<List<dynamic>> getStudents();
  Future<Map<String, dynamic>> getStudentFile(String studentId);
  
  // Actions
  Future<void> registerSession(String studentId, Map<String, dynamic> sessionData);
  Future<void> assignTask(Map<String, dynamic> taskData);
  
  // Consultations
  Future<List<StudentConsultationEntity>> getConsultations();
  Future<void> respondToConsultation(String consultationId, String response);

  // Stats
  Future<Map<String, dynamic>> getStats();
}
