import '../entities/university_announcement_entity.dart';
import '../repositories/university_repository.dart';

class CreateUniversityAnnouncementUseCase {
  final UniversityRepository repository;

  CreateUniversityAnnouncementUseCase(this.repository);

  Future<void> call(UniversityAnnouncementEntity announcement) => repository.createAnnouncement(announcement);
}
