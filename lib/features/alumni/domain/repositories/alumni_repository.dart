import '../entities/alumni_profile_entity.dart';
import '../entities/success_story_entity.dart';

abstract class AlumniRepository {
  Future<AlumniProfileEntity> getProfile();
  Future<void> updateProfile(AlumniProfileEntity profile);
  Future<List<SuccessStoryEntity>> getSuccessStories();
  Future<void> shareSuccessStory(SuccessStoryEntity story);
}
