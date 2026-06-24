import '../../../domain/entities/counselor_profile_entity.dart';
import '../../../domain/entities/student_consultation_entity.dart';
import '../models/counselor_profile_model.dart';
import '../models/student_consultation_model.dart';

class CounselorMapper {
  static CounselorProfileEntity toProfileEntity(CounselorProfileModel model) {
    return CounselorProfileEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      institution: model.institution,
      profileImageUrl: model.profileImageUrl,
    );
  }

  static StudentConsultationEntity toConsultationEntity(StudentConsultationModel model) {
    return StudentConsultationEntity(
      id: model.id,
      studentId: model.studentId,
      studentName: model.studentName,
      message: model.message,
      createdAt: model.createdAt,
      status: model.status,
    );
  }
}
