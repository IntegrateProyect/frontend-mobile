import '../../domain/entities/alumni_profile_entity.dart';
import '../../domain/entities/success_story_entity.dart';
import '../../domain/repositories/alumni_repository.dart';

class AlumniRepositoryImpl implements AlumniRepository {
  @override
  Future<AlumniProfileEntity> getProfile() async {
    // TODO: Implement actual fetch
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile(AlumniProfileEntity profile) async {
    // TODO: Implement update
  }

  @override
  Future<List<SuccessStoryEntity>> getSuccessStories() async {
    return [];
  }

  @override
  Future<void> shareSuccessStory(SuccessStoryEntity story) async {
    // TODO: Implement sharing
  }
}
