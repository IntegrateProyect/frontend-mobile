import '../../../student/domain/entities/student_profile_entity.dart';
import '../entities/counselor_profile_entity.dart';
import '../entities/student_consultation_entity.dart';
import '../entities/appointment_entity.dart';

abstract class CounselorRepository {
  Future<CounselorProfileEntity> getProfile();
  
  // Groups
  Future<List<dynamic>> getGroups();
  Future<Map<String, dynamic>> getGroupDetails(String groupId);
  Future<Map<String, dynamic>> createGroup(String name, String? accessCode);
  Future<Map<String, dynamic>> updateGroup(String groupId, {String? name, String? accessCode});
  Future<void> deleteGroup(String groupId);
  
  // Students
  Future<List<StudentProfileEntity>> getGroupStudents(String groupId);
  Future<List<StudentProfileEntity>> getStudents();
  Future<Map<String, dynamic>> getStudentFile(String studentId);
  
  // Actions
  Future<void> registerSession(String studentId, Map<String, dynamic> sessionData);
  Future<void> assignTask(Map<String, dynamic> taskData);
  Future<void> requestSupport(String message);
  
  // Consultations
  Future<List<StudentConsultationEntity>> getConsultations();
  Future<void> respondToConsultation(String consultationId, String response);

  // Stats
  Future<Map<String, dynamic>> getStats();

  // Appointments
  Future<List<AppointmentEntity>> getAppointments();
  Future<void> scheduleAppointment(String studentId, DateTime date, String motive);
  Future<List<AppointmentEntity>> getCounselorAppointments();

  // Availability
  Future<List<dynamic>> getAvailability();
  Future<void> saveAvailability(List<Map<String, dynamic>> slots);
}
