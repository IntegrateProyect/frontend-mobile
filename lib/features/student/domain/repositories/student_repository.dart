import '../../../university/domain/entities/scholarship_entity.dart';
import '../entities/alumni_entity.dart';
import '../entities/career_entity.dart';
import '../entities/event_entity.dart';

import '../entities/student_profile_entity.dart';
import '../entities/vocational_result_entity.dart';

abstract class StudentRepository {
  Future<StudentProfileEntity> getProfile();

  Future<void> updateProfile(StudentProfileEntity profile);

  Future<List<VocationalResultEntity>> getVocationalResults();

  Future<List<CareerEntity>> getRecommendedCareers();

  Future<void> saveFavorite(String id, String type);

  Future<List<ScholarshipEntity>> getScholarships();

  Future<List<EventEntity>> getEvents();

  Future<List<AlumniEntity>> getAlumni();
}
