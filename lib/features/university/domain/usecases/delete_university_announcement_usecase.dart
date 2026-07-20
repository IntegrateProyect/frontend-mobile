import '../repositories/university_repository.dart';

class DeleteUniversityAnnouncementUseCase {
  final UniversityRepository repository;

  DeleteUniversityAnnouncementUseCase(this.repository);

  Future<void> call(String announcementId) => repository.deleteAnnouncement(announcementId);
}
