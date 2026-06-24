import '../../../domain/entities/alumni_profile_entity.dart';
import '../../../domain/entities/success_story_entity.dart';
import '../models/alumni_profile_model.dart';
import '../models/success_story_model.dart';

class AlumniMapper {
  static AlumniProfileEntity toProfileEntity(AlumniProfileModel model) {
    return AlumniProfileEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      career: model.career,
      university: model.university,
      currentJob: model.currentJob,
      bio: model.bio,
      profileImageUrl: model.profileImageUrl,
    );
  }

  static SuccessStoryEntity toStoryEntity(SuccessStoryModel model) {
    return SuccessStoryEntity(
      id: model.id,
      alumniName: model.alumniName,
      title: model.title,
      story: model.story,
      imageUrl: model.imageUrl,
      createdAt: model.createdAt,
    );
  }

  static SuccessStoryModel fromStoryEntity(SuccessStoryEntity entity) {
    return SuccessStoryModel(
      id: entity.id,
      alumniName: entity.alumniName,
      title: entity.title,
      story: entity.story,
      imageUrl: entity.imageUrl,
      createdAt: entity.createdAt,
    );
  }
}
