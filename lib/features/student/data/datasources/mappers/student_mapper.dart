
import '../../../domain/entities/alumni_entity.dart';
import '../../../domain/entities/career_entity.dart';
import '../../../domain/entities/event_entity.dart';
import '../../../domain/entities/scholarship_entity.dart';
import '../../../domain/entities/student_profile_entity.dart';
import '../../../domain/entities/university_entity.dart';
import '../../../domain/entities/vocational_result_entity.dart';
import '../models/alumni_model.dart';
import '../models/career_model.dart';
import '../models/event_model.dart';
import '../models/scholarship_model.dart';
import '../models/student_profile_model.dart';
import '../models/university_model.dart';
import '../models/vocational_result_model.dart';

class StudentMapper {
  static StudentProfileEntity toProfileEntity(StudentProfileModel model) {
    return StudentProfileEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      bio: model.bio,
      profileImageUrl: model.profileImageUrl,
    );
  }

  static VocationalResultEntity toVocationalResultEntity(VocationalResultModel model) {
    return VocationalResultEntity(
      id: model.id,
      date: model.date,
      topCareer: model.topCareer,
      scores: model.scores,
    );
  }

  static CareerEntity toCareerEntity(CareerModel model) {
    return CareerEntity(
      id: model.id,
      name: model.name,
      description: model.description,
      fields: model.fields,
    );
  }

  static UniversityEntity toUniversityEntity(UniversityModel model) {
    return UniversityEntity(
      id: model.id,
      name: model.name,
      location: model.location,
      logoUrl: model.logoUrl,
      availableCareers: model.availableCareers,
    );
  }

  static ScholarshipEntity toScholarshipEntity(ScholarshipModel model) {
    return ScholarshipEntity(
      id: model.id,
      title: model.title,
      provider: model.provider,
      description: model.description,
      amount: model.amount,
    );
  }

  static EventEntity toEventEntity(EventModel model) {
    return EventEntity(
      id: model.id,
      title: model.title,
      date: model.date,
      location: model.location,
      description: model.description,
    );
  }

  static AlumniEntity toAlumniEntity(AlumniModel model) {
    return AlumniEntity(
      id: model.id,
      name: model.name,
      career: model.career,
      university: model.university,
      currentJob: model.currentJob,
      profileImageUrl: model.profileImageUrl,
    );
  }
}
