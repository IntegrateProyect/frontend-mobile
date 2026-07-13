import '../entities/alumni_entity.dart';
import '../entities/career_entity.dart';
import '../entities/event_entity.dart';
import '../entities/scholarship_entity.dart';
import '../entities/student_profile_entity.dart';
import '../entities/university_catalog_page_entity.dart';
import '../entities/vocational_result_entity.dart';
import '../entities/appointment_entity.dart';

abstract class StudentRepository {
  Future<StudentProfileEntity> getProfile();

  Future<void> updateProfile(
      StudentProfileEntity profile,
      );

  Future<List<VocationalResultEntity>>
  getVocationalResults();

  Future<List<CareerEntity>>
  getRecommendedCareers();

  Future<UniversityCatalogPageEntity>
  getCompatibleUniversities({
    int page = 1,
    int limit = 20,
    String search = '',
  });

  Future<void> saveFavorite(
      String id,
      String type,
      );

  Future<void> requestCounselorSupport(
      String message,
      );

  Future<List<ScholarshipEntity>>
  getScholarships();

  Future<List<EventEntity>> getEvents();

  Future<List<AlumniEntity>> getAlumni();

  // Appointments
  Future<void> scheduleAppointment(DateTime date, String motive);
  Future<List<AppointmentEntity>> getAppointments();
}
