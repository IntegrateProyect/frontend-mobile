import '../entities/success_story_entity.dart';
import '../repositories/alumni_repository.dart';

class ManageStoriesUseCase {
  final AlumniRepository repository;

  ManageStoriesUseCase(this.repository);

  Future<List<SuccessStoryEntity>> getStories() => repository.getSuccessStories();
  
  Future<void> shareStory({required String title, required String content}) => 
      repository.shareStory(title: title, content: content);
}
