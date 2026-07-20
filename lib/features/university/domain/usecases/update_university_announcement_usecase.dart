import '../entities/university_announcement_entity.dart';
import '../repositories/university_repository.dart';

class UpdateUniversityAnnouncementUseCase {
  final UniversityRepository repository;

  UpdateUniversityAnnouncementUseCase(this.repository);

  Future<void> call(UniversityAnnouncementEntity announcement) => repository.updateAnnouncement(announcement);
}
