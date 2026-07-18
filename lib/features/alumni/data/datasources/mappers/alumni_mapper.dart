import '../../../domain/entities/alumni_profile_entity.dart';
import '../../../domain/entities/success_story_entity.dart';
import '../models/alumni_profile_model.dart';
import '../models/success_story_model.dart';

class AlumniMapper {
  static AlumniProfileEntity toProfileEntity(AlumniProfileModel model) {
    return AlumniProfileEntity(
      name: model.name,
      email: model.email,
      graduationYear: model.graduationYear,
      degree: model.degree,
      company: model.company,
    );
  }

  static SuccessStoryEntity toStoryEntity(SuccessStoryModel model) {
    return SuccessStoryEntity(
      id: model.id,
      alumniName: model.alumniName,
      career: model.career,
      graduationYear: model.graduationYear,
      story: model.story,
      createdAt: model.createdAt,
    );
  }

  static SuccessStoryModel fromStoryEntity(SuccessStoryEntity entity) {
    return SuccessStoryModel(
      id: entity.id,
      alumniName: entity.alumniName,
      career: entity.career,
      graduationYear: entity.graduationYear,
      story: entity.story,
      createdAt: entity.createdAt,
    );
  }
}
